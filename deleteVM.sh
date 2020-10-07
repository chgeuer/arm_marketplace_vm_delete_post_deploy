#!/bin/bash

echo "Downloading jq"
curl \
   --request GET \
   --location \
   --silent \
   --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
   --output ./jq && chmod +x ./jq

echo "Logging in with managed identity"
az login --identity

echo "Greeting was \"${GREETINGS}\""

echo "VM to delete is \"${DUMMY_VM_ID}\""
