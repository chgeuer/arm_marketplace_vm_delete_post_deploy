#!/bin/bash

## Unnecessary. `jq` is already on the box
# curl \
#    --request GET \
#    --location \
#    --silent \
#    --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
#    --output ./jq && chmod +x ./jq
# alias jq="./jq"

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


# TODO MUST MATCH REAL API, we're getting garbage out of postman here
RESPONSE_PATH_CLIENT_ID=".headers.host"
RESPONSE_PATH_CLIENT_SECRET=".data.deployment.properties.templateHash"

client_id="$( echo "${servicePrincipalDetails}" | jq -r "${RESPONSE_PATH_CLIENT_ID}" )"
client_secret="$( echo "${servicePrincipalDetails}" | jq -r "${RESPONSE_PATH_CLIENT_SECRET}" )"

output="$( \
  echo "{}" \
    | jq --arg x "${azure_env}"               '.environment=($x | fromjson)' \
    | jq --arg x "${servicePrincipalDetails}" '.servicePrincipalDetails=($x | fromjson)' \
    | jq --arg x "${client_id}"               '.servicePrincipal.client_id=($x | fromjson)' \
    | jq --arg x "${client_secret}"           '.servicePrincipal.client_secret=($x | fromjson)' \
	)"

echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"
