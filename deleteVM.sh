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
az login --identity

echo "VM to delete is \"${DUMMY_VM_ID}\""
az vm                delete           --ids "${DUMMY_VM_ID}"

echo "Managed disk to delete is \"${DUMMY_DISK}\""
az disk              delete --no-wait --ids "${DUMMY_DISK}"

echo "NIC to delete is \"${DUMMY_NIC}\""
az network nic       delete --no-wait --ids "${DUMMY_NIC}"

echo "Public IP to delete is \"${DUMMY_IP}\""
az network public-ip delete           --ids "${DUMMY_IP}"

echo "DONE... Good bye"
