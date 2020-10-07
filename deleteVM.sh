#!/bin/bash

echo "Greeting was \"${GREETINGS}\""

echo "Downloading jq"
curl \
   --request GET \
   --location \
   --silent \
   --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
   --output ./jq && chmod +x ./jq

echo "Logging in with managed identity"
echo "$( az login --identity )"

echo "###################"
echo "VM to delete is \"${DUMMY_VM_ID}\""
echo "$( az vm delete --verbose --yes --ids "${DUMMY_VM_ID}" )"

echo "###################"
echo "Managed disk to delete is \"${DUMMY_DISK}\""
echo "$( az disk delete --verbose --yes --no-wait --ids "${DUMMY_DISK}" )"

echo "###################"
echo "NIC to delete is \"${DUMMY_NIC}\""
echo "$( az network nic delete --verbose --no-wait --ids "${DUMMY_NIC}" )"

echo "###################"
echo "Public IP to delete is \"${DUMMY_IP}\""
echo "$( az network public-ip delete --verbose --ids "${DUMMY_IP}" )"

echo "DONE... Good bye"
