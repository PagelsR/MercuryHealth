param configStoreName string
param webappName string
param signInNameObjectId string
param loadTestResourceName string

// Reference Existing resource
resource existing_appService 'Microsoft.Web/sites@2022-09-01' existing = {
  name: webappName
}

// Reference Existing resource
resource existing_appConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = {
  name: configStoreName
}

// Reference Existing resource
resource existing_LoadTestService 'Microsoft.LoadTestService/loadTests@2022-12-01' existing = {
  name: loadTestResourceName
}

// ****************************************************************
// Add Role Assignment - App Configuration Data Reader
// ****************************************************************

// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

// Try #2 <<<<<<<<<<<<<<<<<< WORKS!!!
// App Configuration Data Reader role definition ID
var AppConfigDataReaderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071')

resource appConfigRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(existing_appConfig.id, AppConfigDataReaderRoleDefinitionId)
  scope: existing_appConfig
  properties: {
    principalId: existing_appService.identity.principalId
    roleDefinitionId: AppConfigDataReaderRoleDefinitionId
  }
  dependsOn: [
    existing_appConfig
    existing_appService
  ]
}


// Load Testing Owner role definition ID
// Assinged to email Object ID to Azure Portal user to view the Load Test Service results
var loadTestOwnderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45bb0b16-2f0c-4e78-afaa-a07599b003f6')

resource loadTestingRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(existing_LoadTestService.id, loadTestOwnderRoleDefinitionId)
  scope: existing_LoadTestService
  properties: {
    principalId: signInNameObjectId
    roleDefinitionId: loadTestOwnderRoleDefinitionId
  }
  dependsOn: [
    existing_LoadTestService
  ]
}
