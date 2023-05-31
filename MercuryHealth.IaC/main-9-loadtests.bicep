param location string = resourceGroup().location
param loadTestsName string
// param loadTests2ndLocation string
// param loadTests2ndName string

param defaultTags object

resource loadtesting 'Microsoft.LoadTestService/loadTests@2022-12-01' = {
    location: location
    name: loadTestsName
    tags: defaultTags
    properties: {
        description: 'Azure Load Testing Service'
    }
    identity: {
        type:'SystemAssigned'
      }
}

// Stand up 2nd location for APIM stats
// resource loadtestingnortheurope 'Microsoft.LoadTestService/loadTests@2022-04-15-preview' = {
//     location: loadTests2ndLocation
//     name: loadTests2ndName
//     tags: defaultTags
//     properties: {
//         description: 'Azure Load Testing Service'
//     }

// }

// resource definition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
//   name: guid(role[builtInRoleType])
//   properties: {
//     roleName: role[builtInRoleType]
//     description: 'Azure Load Testing role'
//     permissions: [
//       {
//         actions: [
//           '*/write'
//         ]
//       }
//     ]
//     assignableScopes: [
//       subscription().id
//     ]
//   }
// }

// resource assignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//     name: guid(loadtesting.id, principalId, role[builtInRoleType])
//     properties: {
//       roleDefinitionId: definition.id
//       principalId: principalId
//     }
//   }
