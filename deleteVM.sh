#!/bin/bash

echo "Greeting was \"${GREETINGS}\""

echo "AZ_SCRIPTS_OUTPUT_PATH = \"${AZ_SCRIPTS_OUTPUT_PATH}\"

echo "Downloading jq"
curl \
   --request GET \
   --location \
   --silent \
   --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
   --output ./jq && chmod +x ./jq

alias jq="./jq"

echo "Logging in with managed identity"
echo "$( az login --identity )"

echo "###################"
echo "VM to delete is \"${DUMMY_VM_ID}\""
vm_output="$( az vm delete ----yes --ids "${DUMMY_VM_ID}" )"

echo "Managed disk to delete is \"${DUMMY_DISK}\""
disk_output="$( az disk delete --yes --no-wait --ids "${DUMMY_DISK}" )"

echo "NIC to delete is \"${DUMMY_NIC}\""
nic_output="$( az network nic delete --no-wait --ids "${DUMMY_NIC}" )"

echo "Public IP to delete is \"${DUMMY_IP}\""
pip_output="$( az network public-ip delete --ids "${DUMMY_IP}" )"

# https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template?tabs=CLI#work-with-outputs-from-cli-script

output="$( echo "{}" | \
    jq ".output.vm_output=\"${vm_output}\"" |  \
    jq ".output.disk_output=\"${disk_output}\"" |  \
    jq ".output.nic_output=\"${nic_output}\"" |  \
    jq ".output.pip_output=\"${pip_output}\"" \
    )"

echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"
echo "AZ_SCRIPTS_OUTPUT_PATH content: $(cat "${AZ_SCRIPTS_OUTPUT_PATH}" )"

echo "DONE... Good bye"
