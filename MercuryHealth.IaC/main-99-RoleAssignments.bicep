// /param loadTestsName string
// param loadTestReaderRoleId string

//param principalId string
param principalObjectIdOfUser string
param configStoreName string
param webappName string
param signInNameObjectId string
param subscriptionId string
param resourceGroupName string
param loadTestResourceName string
//param loadTestReaderRoleId string


// Reference Existing resource
resource existing_appService 'Microsoft.Web/sites@2022-09-01' existing = {
  name: webappName
}

resource existing_appConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = {
  name: configStoreName
}

// ****************************************************************
// Add Role Assignment - App Configuration Data Reader
// ****************************************************************

// Add role assigment for Service Identity
// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
// App Configuration Data Reader. Allows read access to App Configuration data.	516239f1-63e1-4d78-a4de-a74fb236a071
//var AppConfigDataReaderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071')

// Add role assignment to App Config Store
// resource roleAssignmentForAppConfig 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(existing_appConfig.id, AppConfigDataReaderRoleDefinitionId)
//   scope: existing_appConfig
//   properties: {
//     principalType: 'ServicePrincipal'
//     principalId: reference(existing_appService.id, '2020-12-01', 'Full').identity.principalId //existing_appService.identity.principalId
//     roleDefinitionId: AppConfigDataReaderRoleDefinitionId
//   }
// }

// ****************************************************************
// Add Role Assignment - Load Test Owner
// ****************************************************************

// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
// var loadTestOwnderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45bb0b16-2f0c-4e78-afaa-a07599b003f6')

// // // Reference Existing resource
// resource existing_LoadTestService 'Microsoft.LoadTestService/loadTests@2022-12-01' existing = {
//   name: loadTestResourceName
// }

// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(existing_LoadTestService.id, loadTestOwnderRoleDefinitionId)
//   scope: existing_LoadTestService
//   properties: {
//     principalType: 'User'
//     principalId: principalObjectIdOfUser
//     roleDefinitionId: loadTestOwnderRoleDefinitionId
//   }
// }

// NOT WORKING
// Add role assignment to Load Test Service
// resource roleAssignmentForLoadTestService 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(existing_LoadTestService.id, loadTestOwnderRoleDefinitionId)
//   scope: existing_LoadTestService
//   properties: {
//     principalType: 'User'
//     principalId: resourceId('Microsoft.AzureActiveDirectory/', principalObjectIdOfUser) //reference(existing_LoadTestService.id, '2020-12-01', 'Full').identity.principalId //existing_appService.identity.principalId
//     roleDefinitionId: loadTestOwnderRoleDefinitionId
//   }
// }

// ****************************************************************
// TESTING ONLY
// ****************************************************************


// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
//param loadTestOwnerRoleId string = '45bb0b16-2f0c-4e78-afaa-a07599b003f6'
//var loadTestOwnderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45bb0b16-2f0c-4e78-afaa-a07599b003f6')

// Add role assigment for Load Testing Service
// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(subscriptionId, resourceGroupName, loadTestResourceName)
//   type: 'Microsoft.Authorization/roleAssignments'
//   apiVersion: '2020-04-01'
//   properties: {
//     principalId: resourceId('Microsoft.AzureActiveDirectory/userAssignedIdentities', principalIdOfUser)
//     roleDefinitionId: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${loadTestOwnerRoleId}'
//     scope: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.LoadTestService/loadtests/${loadTestResourceName}'
//   }
// }
// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(subscriptionId, resourceGroupName, loadTestResourceName)
//   type: 'Microsoft.Authorization/roleAssignments'
//   apiVersion: '2020-04-01'
//   properties: {
//     principalId: principalObjectIdOfUser
//     roleDefinitionId: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${loadTestOwnerRoleId}'
//     scope: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.LoadTestService/loadtests/${loadTestResourceName}'
//   }
// }

// resource roleAssignment2 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(subscriptionId, resourceGroupName, loadTestResourceName)
//   type: 'Microsoft.Authorization/roleAssignments'
//   apiVersion: '2020-04-01-preview'
//   properties: {
//     principalId: principalObjectIdOfUser
//     roleDefinitionId: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${loadTestOwnderRoleDefinitionId}'
//     scope: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.LoadTestService/loadtests/${loadTestResourceName}'
//   }
// }

// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(subscriptionId, resourceGroupName, loadTestResourceName)
//   type: 'Microsoft.Authorization/roleAssignments'
//   apiVersion: '2020-04-01-preview'
//   properties: {
//     principalId: referenceResourceId('Microsoft.AzureActiveDirectory/userAssignedIdentities', signInNameObjectId)
//     roleDefinitionId: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${loadTestReaderRoleId}'
//     scope: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.LoadTestService/loadtests/${loadTestResourceName}'
//   }
// }


