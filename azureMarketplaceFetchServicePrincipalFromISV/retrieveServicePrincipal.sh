#!/bin/bash

# curl --request GET --location --silent --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" --output ./jq && chmod +x ./jq && alias jq="./jq"

azure_env="$( \
    echo "{}" \
    | jq --arg x "${AZURE_RESOURCE_GROUP}" '.resourceGroup=($x | fromjson)' \
    | jq --arg x "${AZURE_DEPLOYMENT}"     '.deployment=($x    | fromjson)' \
    | jq --arg x "${AZURE_ENVIRONMENT}"    '.environment=($x   | fromjson)' \
    | jq --arg x "${AZURE_SUBSCRIPTION}"   '.subscription=($x  | fromjson)' \
	)"

servicePrincipalDetails="$( \
  curl \
    --silent \
    --request POST \
	  --url "${PARAM_SERVICE_PRINCIPAL_RETRIEVAL_URL}" \
	  --header "Content-Type: application/json" \
	  --data "${azure_env}" \
    )"

#
# TODO
#
# Must match the real ISV, we're getting garbage out of postman here
#
RESPONSE_PATH_CLIENT_ID=".headers.host"
RESPONSE_PATH_CLIENT_SECRET=".data.deployment.properties.templateHash"
RESPONSE_PATH_TENANT_ID=".data.deployment.properties.templateHash"

client_id="$(     echo "${servicePrincipalDetails}" | jq "${RESPONSE_PATH_CLIENT_ID}" )"
client_secret="$( echo "${servicePrincipalDetails}" | jq "${RESPONSE_PATH_CLIENT_SECRET}" )"
tenant_id="$(     echo "${servicePrincipalDetails}" | jq "${RESPONSE_PATH_TENANT_ID}" )"

output="$( \
  echo "{}" \
    | jq --arg x "${servicePrincipalDetails}" '.allthestuff=($x | fromjson)' \
    | jq --arg x "${client_id}"               '.servicePrincipal.client_id=($x | fromjson)' \
    | jq --arg x "${client_secret}"           '.servicePrincipal.client_secret=($x | fromjson)' \
    | jq --arg x "${tenant_id}"               '.servicePrincipal.tenant_id=($x | fromjson)' \
)"

echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"
