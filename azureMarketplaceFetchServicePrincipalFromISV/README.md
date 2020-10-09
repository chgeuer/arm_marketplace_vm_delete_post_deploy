
# README - Azure Marketplace fetch ServicePrincipal from ISV

## Deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fchgeuer%2Farm_marketplace_vm_delete_post_deploy%2Fmain%2FazureMarketplaceFetchServicePrincipalFromISV%2FmainTemplate.json) 

## Summary

In certain scenarios, a "Managed Application" deployment needs to 'call home' to the publisher. This demo shows how this can be bootstrapped.

## Walkthrough

In the Azure Marketplace, customers can purchase offerings which are implemented as a "managed application". 
This means that the Azure resources will be deployed in a resource group in the customer's subscription, but the publisher (ISV) manages this resource group.
The customer explicitly is blocked from accessing the underlying physical resources.

In some scenarios, the publisher (IS) wants to give the managed app (running on the customer side) access to resources on the publisher side, potentially during the initial deployment.
One such scenario could be VMs with Docker starting in the customer's "managed resource group", and the Docker images living in a locked-down Azure Container Registry (ACR) in the publisher's Azure tenant.

The most elegant way for service-to-service authentication in Azure would be to leverage Azure Active Directory, ideally with so-called "managed identity", i.e. where the actual compute resource (VM or ACI) doesn't have local copies of credentials. 
Unfortunately, at the time of writing (October 2020), managed identities cannot be used across Azure AD tenant boundaries. 
In our scenario, the customer's AAD tenant and the publisher's AAD tenant are clearly not the same.

The next option on the table is service-principal based authentication, i.e. the managed app should have access to a service principal which belongs to the publisher's AAD tenant.

### Requirements: 

- Fine-grained authN:
  - Each customer deployment / managed application should have a separate service principal. 
  - Deployments should not share the same credential.
- Early access:
  - The credential should become visible in the managed application during initial povisioning. 
  - In particular, it would be not ideal if the publisher only provisions the credential into the managed application once they receive the [managed application notification](ManagedApplicationNotifications).
- Secure access to the credential
  - The service principal credential should be protected, and require AAD authN to access it.
- Secure Bootstrap
  - Retrieving a valid credential must only be possible for Azure deployments.

In our prototype, the ARM template provisiones a few resources:

1. A `servicePrincipalRetrievalURL` parameter as input to the ARM template contains *confidential* information on where the publisher/ISV exposes an API to retrieve a valid service principal credential. An example could be a tokenized URL, such as `"https://api.contoso.com/retrieveServicePrincipalCredential?authToken=supersecret123"`. 
   - This URL (and potentially embedded security keys) is part of the managed application's ARM template, and as such not visible to the end customer. 
     Only the ISV, the Azure Marketplace team, and the ARM provisioning runtime, should know this information.
2. The `deploymentScript` uses the `servicePrincipalRetrievalURL` to call the ISV's API during the ARM provisioning process.
   - The `deploymentScript` returns the `tenant_id` of the publisher, and the `client_id` and `client_secret` of the service principal.
3. The credential (tuple consisting of `tenant_id`, `client_id` and `client_secret`) is stored as three separate secrets in an Azure KeyVault.
   - Currently it's three secrets, but we could also combine
4. A (user-assigned) managed identity is given read access to the credential in KeyVault. 







[ManagedApplicationNotifications]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/publish-notifications