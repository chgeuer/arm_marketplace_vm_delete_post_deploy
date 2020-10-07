#!/bin/bash

echo "Greeting was \"${GREETINGS}\" -- ${AZ_SCRIPTS_OUTPUT_PATH}"

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

if [[ ${vm_output} == "" ]];   then vm_output="\"Success\""; fi;
if [[ ${disk_output} == "" ]]; then disk_output="\"Success\""; fi;
if [[ ${nic_output} == "" ]];  then nic_output="\"Success\""; fi;
if [[ ${pip_output} == "" ]];  then pip_output="\"Success\""; fi;

# Hit some external service
ip="$( curl --silent --url "https://postman-echo.com/ip" | jq .ip )"

# Create JSON structure
output="$( echo "{}" | \
    jq --arg x "${login_output}" '.output.login=($x | fromjson)'   | \
    jq --arg x "${vm_output}"    '.output.vm=($x | fromjson)'   | \
    jq --arg x "${disk_output}"  '.output.disk=($x | fromjson)' | \
    jq --arg x "${nic_output}"   '.output.nic=($x | fromjson)'  | \
    jq --arg x "${pip_output}"   '.output.pip=($x | fromjson)'  | \
    jq --arg x "${ip}"           '.ip=$x'                         )"

AZ_SCRIPTS_OUTPUT_PATH="scriptoutputs.json"


# https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template?tabs=CLI#work-with-outputs-from-cli-script
echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"

echo "XXX ${output}"
echo "AZ_SCRIPTS_OUTPUT_PATH content: "
cat "${AZ_SCRIPTS_OUTPUT_PATH}"
