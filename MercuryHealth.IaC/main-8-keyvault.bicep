param location string = resourceGroup().location
param vaultName string
param tenant string = subscription().tenantId

param accessPolicies array = []

param networkAcls object = {
  ipRules: []
  virtualNetworkRules: []
}

resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: vaultName
  location: location
  properties: {
    tenantId: tenant
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableSoftDelete: false
    accessPolicies: accessPolicies
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: false
    networkAcls: networkAcls
  }
}

output proxyKey object = keyvault
output keyvaultName string = keyvault.name
// output out_secretName1 string = secretName1
// output out_secretName2 string = secretName2
// output out_secretValue2 string = secretValue2
