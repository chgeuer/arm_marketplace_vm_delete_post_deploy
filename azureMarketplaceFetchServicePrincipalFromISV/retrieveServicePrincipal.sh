#!/bin/bash

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

output="$( \
  echo "{}" \
    | jq --arg x "${azure_env}"               '.environment=($x | fromjson)' \
    | jq --arg x "${servicePrincipalDetails}" '.servicePrincipalDetails=($x | fromjson)' \
	)"

# echo "${servicePrincipalDetails}" | jq "."
# echo "${output}" | jq "."

echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"
