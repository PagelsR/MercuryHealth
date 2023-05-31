// /param loadTestsName string
// param loadTestReaderRoleId string

//param principalId string
param principalObjectIdOfUser string

param signInName string
param subscriptionId string
param resourceGroupName string
param loadTestResourceName string
//param loadTestReaderRoleId string


// Role: Load Test Contributor
// Scope: /subscriptions/9a0cf54e-d873-4da7-ba83-f9fe8fb5934e/resourceGroups/rg-MercuryHealth-dev/providers/Microsoft.LoadTestService/loadtests/loadtests-x7vgm47suuyt2
// Name: Randy Pagels
// Object ID: 0aa95253-9e37-4af9-a63a-3b35ed78e98b
// Type: User





// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
//param loadTestOwnerRoleId string = '45bb0b16-2f0c-4e78-afaa-a07599b003f6'
var loadTestOwnderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45bb0b16-2f0c-4e78-afaa-a07599b003f6')

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

// Reference Existing resource
resource existing_LoadTestService 'Microsoft.LoadTestService/loadTests@2022-12-01' existing = {
  name: loadTestResourceName
}

// Add role assignment to Load Test Service
resource roleAssignmentForLoadTestService 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(existing_LoadTestService.id, loadTestOwnderRoleDefinitionId)
  scope: existing_LoadTestService
  properties: {
    principalType: 'ServicePrincipal'
    principalId: resourceId('Microsoft.AzureActiveDirectory/userAssignedIdentities', 'rpagels@xpirit.com') //reference(existing_LoadTestService.id, '2020-12-01', 'Full').identity.principalId //existing_appService.identity.principalId
    roleDefinitionId: loadTestOwnderRoleDefinitionId
  }
}

// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(subscriptionId, resourceGroupName, loadTestResourceName)
//   type: 'Microsoft.Authorization/roleAssignments'
//   apiVersion: '2020-04-01-preview'
//   properties: {
//     principalId: referenceResourceId('Microsoft.AzureActiveDirectory/userAssignedIdentities', signInName)
//     roleDefinitionId: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${loadTestReaderRoleId}'
//     scope: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.LoadTestService/loadtests/${loadTestResourceName}'
//   }
// }

// - ------------------------------------------------------------

// Reference Existing resource
// resource existing_ContainerApp 'Microsoft.App/containerApps@2022-10-01' existing = {
//   name: containerAppName
// }

// // Add role assignment to Load Testing Service
// resource roleAssignmentForContainerApp 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(existing_ContainerApp.id, secretUserRole)
//   scope: existing_ContainerApp
//   properties: {
//     principalId: principalId
//     roleDefinitionId: secretUserRole
//   }
// }
