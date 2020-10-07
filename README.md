# [arm_marketplace_vm_delete_post_deploy](https://github.com/chgeuer/arm_marketplace_vm_delete_post_deploy)

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fchgeuer%2Farm_marketplace_vm_delete_post_deploy%2Fmain%2FdeleteVMPostDeployment.json) 


Goal if this template is to be executed with a managed application deployment from Azure Marketplace.

- Subscription should be allow-listed to use a hidden VM image
- Customer should not be forced to opt in manually
- Template should deploy a single (tiny) VM within the template, which automagically registers the subscription to enlist in the plan
- Post VM deployment, a deploymentScript should delete the VM (and NIC and Disk) again
- To do that, deploymentScript needs Contributor role assignement on managed resource group
