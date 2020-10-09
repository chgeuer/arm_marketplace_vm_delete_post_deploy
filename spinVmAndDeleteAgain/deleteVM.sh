#!/bin/bash

curl \
   --request GET \
   --location \
   --silent \
   --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
   --output ./jq && chmod +x ./jq

alias jq="./jq"

login_output="$( az login --identity )"
vm_output="$(    az vm                delete --yes           --ids "${DUMMY_VM_ID}" )"
disk_output="$(  az disk              delete --yes --no-wait --ids "${DUMMY_DISK}"  )"
nic_output="$(   az network nic       delete       --no-wait --ids "${DUMMY_NIC}"   )"
pip_output="$(   az network public-ip delete                 --ids "${DUMMY_IP}"    )"

#
# These delete operations return an empty response on success
#
if [[ ${vm_output} == "" ]];   then vm_output="{}"; fi;
if [[ ${disk_output} == "" ]]; then disk_output="{}"; fi;
if [[ ${nic_output} == "" ]];  then nic_output="{}"; fi;
if [[ ${pip_output} == "" ]];  then pip_output="{}"; fi;

# Hit some external service
ip="$( curl --silent --url "https://postman-echo.com/ip" | jq -r ".ip" )"

# Create JSON structure
output="$( echo "{}" | \
    jq --arg x "${login_output}" '.tasks.login=($x | fromjson)' | \
    jq --arg x "${vm_output}"    '.tasks.vm=($x | fromjson)'    | \
    jq --arg x "${disk_output}"  '.tasks.disk=($x | fromjson)'  | \
    jq --arg x "${nic_output}"   '.tasks.nic=($x | fromjson)'   | \
    jq --arg x "${pip_output}"   '.tasks.pip=($x | fromjson)'   | \
    jq --arg x "${ip}"           '.ip=$x'                       )"

# https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template?tabs=CLI#work-with-outputs-from-cli-script
echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"
