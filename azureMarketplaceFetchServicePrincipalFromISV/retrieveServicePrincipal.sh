#!/bin/bash

set -euo

# curl --request GET --location --silent --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" --output ./jq && chmod +x ./jq && alias jq="./jq"

#
# Capture the complete context we're seeing, and shove it to the publisher.
#
# TODO: Come up with a more nuances approach on which data we really need.
#
request_body="$( \
    echo "{}" \
    | jq --arg x "${AZURE_RESOURCE_GROUP}" '.resourceGroup=($x | fromjson)' \
    | jq --arg x "${AZURE_DEPLOYMENT}"     '.deployment=($x    | fromjson)' \
    | jq --arg x "${AZURE_ENVIRONMENT}"    '.environment=($x   | fromjson)' \
    | jq --arg x "${AZURE_SUBSCRIPTION}"   '.subscription=($x  | fromjson)' \
    )"

#
# TODO define how specifically the publisher's API is called and how authenticated
#
response_body="$( \
  curl \
    --silent \
    --request POST \
    --url "${PARAM_SERVICE_PRINCIPAL_RETRIEVAL_URL}" \
    --header "Content-Type: application/json" \
    --data "${request_body}" \
    )"

#
# TODO Must match the real ISV, we're getting garbage out of postman here
#
RESPONSE_PATH_CLIENT_ID=".headers.host"
RESPONSE_PATH_CLIENT_SECRET=".data.deployment.properties.templateHash"
RESPONSE_PATH_TENANT_ID=".data.deployment.properties.templateHash"

client_id="$(     echo "${response_body}" | jq "${RESPONSE_PATH_CLIENT_ID}" )"
client_secret="$( echo "${response_body}" | jq "${RESPONSE_PATH_CLIENT_SECRET}" )"
tenant_id="$(     echo "${response_body}" | jq "${RESPONSE_PATH_TENANT_ID}" )"

# we're setting the following output properties on the deploymentScript:
# - 'response_body' is the response body from the web vall
# - 'service_principal' is the service principal credential { 'client_id': '...', 'client_secret: '...', 'tenant_id': '...'}

echo "$( echo "{}" \
  | jq --arg x "${response_body}" '.response_body=($x | fromjson)' \
  | jq --arg x "${client_id}"     '.service_principal.client_id=($x | fromjson)' \
  | jq --arg x "${client_secret}" '.service_principal.client_secret=($x | fromjson)' \
  | jq --arg x "${tenant_id}"     '.service_principal.tenant_id=($x | fromjson)' \
)" > "${AZ_SCRIPTS_OUTPUT_PATH}"
