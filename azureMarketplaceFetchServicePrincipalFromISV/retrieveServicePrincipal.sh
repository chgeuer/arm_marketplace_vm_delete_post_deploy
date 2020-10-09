#!/bin/bash

PARAM_SERVICE_PRINCIPAL_RETRIEVAL_URL="https://postman-echo.com/post?secret=supersecret123.-"
AZ_SCRIPTS_OUTPUT_PATH="./1.json"



AZURE_RESOURCE_GROUP="{\"id\":\"/subscriptions/724467b5-bee4-484b-bf13-d6a5505d2b51/resourceGroups/isv1\",\"name\":\"isv1\",\"type\":\"Microsoft.Resources/resourceGroups\",\"location\":\"westeurope\",\"properties\":{\"provisioningState\":\"Succeeded\"}}"

AZURE_ENVIRONMENT="{\"name\":\"AzureCloud\",\"gallery\":\"https://gallery.azure.com/\",\"graph\":\"https://graph.windows.net/\",\"portal\":\"https://portal.azure.com\",\"graphAudience\":\"https://graph.windows.net/\",\"activeDirectoryDataLake\":\"https://datalake.azure.net/\",\"batch\":\"https://batch.core.windows.net/\",\"media\":\"https://rest.media.azure.net\",\"sqlManagement\":\"https://management.core.windows.net:8443/\",\"vmImageAliasDoc\":\"https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json\",\"resourceManager\":\"https://management.azure.com/\",\"authentication\":{\"loginEndpoint\":\"https://login.microsoftonline.com/\",\"audiences\":[\"https://management.core.windows.net/\",\"https://management.azure.com/\"],\"tenant\":\"common\",\"identityProvider\":\"AAD\"},\"suffixes\":{\"acrLoginServer\":\".azurecr.io\",\"azureDatalakeAnalyticsCatalogAndJob\":\"azuredatalakeanalytics.net\",\"azureDatalakeStoreFileSystem\":\"azuredatalakestore.net\",\"azureFrontDoorEndpointSuffix\":\"azurefd.net\",\"keyvaultDns\":\".vault.azure.net\",\"sqlServerHostname\":\".database.windows.net\",\"storage\":\"core.windows.net\"}}"

AZURE_SUBSCRIPTION="{\"id\":\"/subscriptions/724467b5-bee4-484b-bf13-d6a5505d2b51\",\"managedByTenants\":[],\"subscriptionId\":\"724467b5-bee4-484b-bf13-d6a5505d2b51\",\"tenantId\":\"942023a6-efbe-4d97-a72d-532ef7337595\",\"displayName\":\"chgeuer-work\",\"state\":\"NotDefined\"}"

AZURE_DEPLOYMENT="{\"name\":\"Microsoft.Template\",\"tags\":{\"primaryResourceId\":\"/subscriptions/724467b5-bee4-484b-bf13-d6a5505d2b51/resourcegroups/isv1\",\"marketplaceItemId\":\"Microsoft.Template\"},\"properties\":{\"template\":{\"$schema\":\"https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#\",\"contentVersion\":\"1.0.0.0\",\"parameters\":{\"servicePrincipalRetrievalURL\":{\"defaultValue\":\"https://postman-echo.com/post?token=supersecret123.-\",\"type\":\"SecureString\",\"metadata\":{\"description\":\"ISV specific secret to allow a managed app deployment to call home and request ISV to provision a service principal for that deployment.\"}},\"useRelativeScript\":{\"defaultValue\":false,\"type\":\"Bool\"}},\"variables\":{\"location\":\"[resourceGroup().location]\",\"defaultTemplateLocation\":\"https://raw.githubusercontent.com/chgeuer/arm_marketplace_vm_delete_post_deploy/main/azureMarketplaceFetchServicePrincipalFromISV/\",\"artifactsLocation\":\"[if(parameters('useRelativeScript'), deployment().properties.templateLink.uri, variables('defaultTemplateLocation') )]\",\"ephemeral\":\"[concat(uniqueString(resourceGroup().id, deployment().name))]\",\"names\":{\"vNetName\":\"vnet\",\"vNetSubnetName\":\"default\",\"networkSecurityGroupNameSubnet\":\"default-nsg\",\"reportUsageIdentity\":\"[concat('report-usage-identity-for-resource-group-', resourceGroup().name)]\",\"vmName\":\"[concat(variables('ephemeral'), '-vm')]\",\"networkInterfaceName\":\"[concat(variables('ephemeral'), '-nic')]\",\"servicePrincipalRetrievalScript\":\"setupServicePrincipal\",\"reportUsageServicePrincipalKeyvault\":\"[concat('keyvault-', variables('ephemeral'))]\"},\"apiVersions\":{\"MicrosoftNetwork\":\"2020-05-01\",\"MicrosoftCompute\":\"2020-06-01\",\"keyvault_vaults\":\"2018-02-14\",\"keyvault_vaults_secrets\":\"2018-02-14\",\"MicrosoftResourcesDeploymentScripts\":\"2019-10-01-preview\",\"managedidentity_userassignedidentities\":\"2018-11-30\",\"MicrosoftAuthorizationRoleAssignments\":\"2020-04-01-preview\"},\"buildInRolesID\":{\"Owner\":\"[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]\",\"Contributor\":\"[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', 'b24988ac-6180-42a0-ab88-20f7382dd24c')]\",\"Reader\":\"[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')]\"}},\"resources\":[{\"type\":\"Microsoft.ManagedIdentity/userAssignedIdentities\",\"apiVersion\":\"[variables('apiVersions').managedidentity_userassignedidentities]\",\"name\":\"[variables('names').reportUsageIdentity]\",\"location\":\"[variables('location')]\"},{\"type\":\"Microsoft.Authorization/roleAssignments\",\"apiVersion\":\"[variables('apiVersions').MicrosoftAuthorizationRoleAssignments]\",\"name\":\"[guid(concat(variables('ephemeral'), variables('names').reportUsageIdentity))]\",\"dependsOn\":[\"[resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', variables('names').reportUsageIdentity)]\"],\"properties\":{\"roleDefinitionId\":\"[variables('buildInRolesID').Contributor]\",\"principalId\":\"[reference(resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', variables('names').reportUsageIdentity), variables('apiVersions').managedidentity_userassignedidentities).principalId]\",\"scope\":\"[resourceGroup().id]\",\"principalType\":\"ServicePrincipal\"}},{\"type\":\"Microsoft.KeyVault/vaults\",\"apiVersion\":\"[variables('apiVersions').keyvault_vaults]\",\"name\":\"[variables('names').reportUsageServicePrincipalKeyvault]\",\"location\":\"[variables('location')]\",\"dependsOn\":[\"[concat('Microsoft.ManagedIdentity/userAssignedIdentities/', variables('names').reportUsageIdentity)]\"],\"tags\":{\"displayName\":\"Key Vault\"},\"properties\":{\"tenantId\":\"[subscription().tenantId]\",\"enabledForDeployment\":true,\"enabledForDiskEncryption\":false,\"enabledForTemplateDeployment\":true,\"sku\":{\"name\":\"standard\",\"family\":\"A\"},\"networkAcls\":{\"value\":{\"defaultAction\":\"Allow\",\"bypass\":\"AzureServices\"}},\"accessPolicies\":[{\"tenantId\":\"[subscription().tenantId]\",\"objectId\":\"[reference(resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', variables('names').reportUsageIdentity), variables('apiVersions').managedidentity_userassignedidentities).principalId]\",\"permissions\":{\"secrets\":[\"set\",\"get\",\"list\"]}}]},\"resources\":[{\"type\":\"secrets\",\"apiVersion\":\"[variables('apiVersions').keyvault_vaults_secrets]\",\"name\":\"foo\",\"dependsOn\":[\"[concat('Microsoft.KeyVault/vaults/', variables('names').reportUsageServicePrincipalKeyvault)]\"],\"properties\":{\"value\":\"bar\",\"contentType\":\"string\"}}]},{\"type\":\"Microsoft.Resources/deploymentScripts\",\"apiVersion\":\"[variables('apiVersions').MicrosoftResourcesDeploymentScripts]\",\"name\":\"[variables('names').servicePrincipalRetrievalScript]\",\"location\":\"[variables('location')]\",\"dependsOn\":[\"[resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', variables('names').reportUsageIdentity)]\"],\"kind\":\"AzureCLI\",\"identity\":{\"type\":\"UserAssigned\",\"userAssignedIdentities\":{\"[resourceId(resourceGroup().name, 'Microsoft.ManagedIdentity/userAssignedIdentities', variables('names').reportUsageIdentity)]\":{}}},\"properties\":{\"azCliVersion\":\"2.11.1\",\"timeout\":\"PT30M\",\"retentionInterval\":\"P1D\",\"cleanupPreference\":\"OnSuccess\",\"environmentVariables\":[{\"name\":\"PARAM_SERVICE_PRINCIPAL_RETRIEVAL_URL\",\"secureValue\":\"[parameters('servicePrincipalRetrievalURL')]\"},{\"name\":\"AZURE_RESOURCE_GROUP\",\"value\":\"[string(resourceGroup())]\"},{\"name\":\"AZURE_DEPLOYMENT\",\"value\":\"[string(deployment())]\"},{\"name\":\"AZURE_ENVIRONMENT\",\"value\":\"[string(environment())]\"},{\"name\":\"AZURE_SUBSCRIPTION\",\"value\":\"[string(subscription())]\"}],\"primaryScriptUri\":\"[uri(variables('artifactsLocation'), 'retrieveServicePrincipal.sh')]\"}}],\"outputs\":{\"scriptResults\":{\"type\":\"Object\",\"value\":\"[reference(variables('names').servicePrincipalRetrievalScript).outputs]\"}}},\"templateHash\":\"14213396575093671305\",\"parameters\":{\"useRelativeScript\":{\"value\":false}},\"mode\":\"Incremental\",\"debugSetting\":{\"detailLevel\":\"None\"},\"provisioningState\":\"Accepted\",\"validationLevel\":\"Template\"}}"


curl \
   --request GET \
   --location \
   --silent \
   --url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" \
   --output ./jq && chmod +x ./jq

alias jq="./jq"

azure_env="$( echo "{}" | \
    jq --arg x "${AZURE_RESOURCE_GROUP}" '.resourceGroup=($x | fromjson)' \
    jq --arg x "${AZURE_DEPLOYMENT}"     '.deployment=($x    | fromjson)' \
    jq --arg x "${AZURE_ENVIRONMENT}"    '.environment=($x   | fromjson)' \
    jq --arg x "${AZURE_SUBSCRIPTION}"   '.subscription=($x  | fromjson)' \
	)"

servicePrincipalDetails="$( \
  curl \
    --silent \
    --request POST \
	--url "${PARAM_SERVICE_PRINCIPAL_RETRIEVAL_URL}" \
	--header "Content-Type: application/json" \
	--data "${azure_env}" \
    )"

output="$( echo "{}" | \
    jq --arg x "${azure_env}"               '.environment=($x | fromjson)' \
    jq --arg x "${servicePrincipalDetails}" '.servicePrincipalDetails=($x | fromjson)' \
	)"

# echo "${servicePrincipalDetails}" | jq "."
# echo "${output}" | jq "."

echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"
