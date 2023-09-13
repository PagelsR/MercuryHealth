// Deploy Azure infrastructure for app + data + monitoring

//targetScope = 'subscription'
// Region for all resources
param location string = resourceGroup().location
param createdBy string = 'Randy Pagels' // resourceGroup().managedBy
param costCenter string = '74f644d3e665'
param releaseAnnotationGuid string = newGuid()
param Deployed_Environment string

@secure()
param cloudFlareAPIToken string

@secure()
param cloudFlareZoneID string

// Generate Azure SQL Credentials
var sqlAdminLoginName = 'AzureAdmin'
var sqlAdminLoginPassword = '${substring(base64(uniqueString(resourceGroup().id)), 0, 10)}.${uniqueString(resourceGroup().id)}'

// Variables for Recommended abbreviations for Azure resource types
// https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
var webAppPlanName = 'plan-${uniqueString(resourceGroup().id)}'
var webSiteName = 'app-${uniqueString(resourceGroup().id)}'
var sqlserverName = toLower('sql-${uniqueString(resourceGroup().id)}')
var sqlDBName = toLower('sqldb-${uniqueString(resourceGroup().id)}')
var configStoreName = 'appcs-v2-${uniqueString(resourceGroup().id)}'
var appInsightsName = 'appi-${uniqueString(resourceGroup().id)}'
var appInsightsWorkspaceName = 'appw-${uniqueString(resourceGroup().id)}'
var appInsightsAlertName = 'ResponseTime-${uniqueString(resourceGroup().id)}'
var functionAppName = 'func-${uniqueString(resourceGroup().id)}'
var functionAppServiceName = 'funcplan-${uniqueString(resourceGroup().id)}'
var apiServiceName = 'apim-${uniqueString(resourceGroup().id)}'
var loadTestsName = 'loadtests-${uniqueString(resourceGroup().id)}'
//var loadTests2ndLocation = 'northeurope'
//var loadTests2ndName = 'loadtests-${uniqueString(resourceGroup().id)}-${loadTests2ndLocation}'
var keyvaultName = 'kv-${uniqueString(resourceGroup().id)}'
var blobstorageName = 'stablob${uniqueString(resourceGroup().id)}'
var dashboardName = 'dashboard-${uniqueString(resourceGroup().id)}'
// var frontDoorName = 'fd-${uniqueString(resourceGroup().id)}'
// var logicAppName = 'logic-${uniqueString(resourceGroup().id)}'
// var cognitiveServiceName = 'cog-${uniqueString(resourceGroup().id)}'

// Slot names
//var functionAppDevSlotName = 'dev'
var webAppDevSlotName = 'dev'

// Tags
var defaultTags = {
  Env: Deployed_Environment
  App: 'Mercury Health'
  CostCenter: costCenter
  CreatedBy: createdBy
}

// KeyVault Secret Names
param kvValue_configStoreConnectionName string = 'ConnectionStringsAppConfig'
param kvValue_ConnectionStringName string = 'ConnectionStringsMercuryHealthWebContext'
param kvValue_AzureWebJobsStorageName string = 'AzureWebJobsStorage'
param kvValue_WebsiteContentAzureFileConnectionString string = 'WebsiteContentAzureFileConnectionString'
param kvValue_ApimSubscriptionKeyName string = 'ApimSubscriptionKey'

// App Configuration Settings
var FontNameKey = 'FontName'
var FontColorKey = 'FontColor'
var FontSizeKey = 'FontSize'
var FontNameValue = 'Calibri'
var FontColorValue = 'Black'
var FontSizeValue = '14'

// Create Azure KeyVault
module keyvaultmod './main-8-keyvault.bicep' = {
  name: keyvaultName
  params: {
    location: location
    vaultName: keyvaultName
    }
 }
 
// Create Web App
module webappmod './main-2-webapp.bicep' = {
  name: 'webappdeploy'
  params: {
    webAppPlanName: webAppPlanName
    webSiteName: webSiteName
    webAppDevSlotName: webAppDevSlotName
    resourceGroupName: resourceGroup().name
    Deployed_Environment: Deployed_Environment
    appInsightsName: appInsightsName
    location: location
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    appInsightsConnectionString: appinsightsmod.outputs.out_appInsightsConnectionString
    defaultTags: defaultTags
    sqlAdminLoginName: sqlAdminLoginName
    sqlAdminLoginPassword: sqlAdminLoginPassword
    sqlDBName: sqlDBName
    sqlserverfullyQualifiedDomainName: sqldbmod.outputs.sqlserverfullyQualifiedDomainName
    sqlserverName: sqlserverName
  }
}

// Create SQL database
module sqldbmod './main-3-sqldatabase.bicep' = {
  name: 'sqldbdeploy'
  params: {
    location: location
    sqlserverName: sqlserverName
    sqlDBName: sqlDBName
    sqlAdminLoginName: sqlAdminLoginName
    sqlAdminLoginPassword: sqlAdminLoginPassword
    defaultTags: defaultTags
  }
}

// Create Application Insights
module appinsightsmod './main-4-appinsights.bicep' = {
  name: 'appinsightsdeploy'
  params: {
    location: location
    appInsightsName: appInsightsName
    defaultTags: defaultTags
    appInsightsAlertName: appInsightsAlertName
    appInsightsWorkspaceName: appInsightsWorkspaceName
  }
}

// Create Function App
module functionappmod './main-6-funcapp.bicep' = {
  name: 'functionappdeploy'
  params: {
    location: location
    functionAppServiceName: functionAppServiceName
    functionAppName: functionAppName
    defaultTags: defaultTags
  }
  dependsOn:  [
    appinsightsmod
  ]
}

// Create API Management
module apimservicemod './main-7-apimanagement.bicep' = {
  name: apiServiceName
    params: {
    location: location
    defaultTags: defaultTags
    apiServiceName: apiServiceName
    appInsightsName: appInsightsName
    applicationInsightsID: appinsightsmod.outputs.out_applicationInsightsID
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    webSiteName: webSiteName
    
  }
  dependsOn:  [
    appinsightsmod
  ]
}

// Create Azure Load Tests
module loadtestsmod './main-9-loadtests.bicep' = {
  name: loadTestsName
  params: {
    location: location
    loadTestsName: loadTestsName
    // loadTests2ndLocation: loadTests2ndLocation
    // loadTests2ndName: loadTests2ndName
    defaultTags: defaultTags
  }
}

// module blogstoragemod './main-12-blobstorage.bicep' = {
//   name: blobstorageName
//   params: {
//     location: location
//      storageAccountName: blobstorageName
//   }
// }

module configstoremod './main-5-configstore.bicep' = {
  name: configStoreName
  params: {
    location: location
     defaultTags: defaultTags
     configStoreName: configStoreName
     FontNameKey: FontNameKey
     FontNameValue: FontNameValue
     FontColorKey: FontColorKey
     FontColorValue: FontColorValue
     FontSizeKey: FontSizeKey
     FontSizeValue: FontSizeValue
  }
  dependsOn:  [
    webappmod
    functionappmod
  ]
}

// module logicappmod './main-15-logicapp.bicep' = {
//   name: logicAppName
//   params: {
//     defaultTags: defaultTags
//     logicAppName: logicAppName
//     location: location
//     // connections_office365_externalid: connections_office365_externalid
//     // connections_sql_externalid: connections_sql_externalid
//     // connections_teams_externalid: connections_teams_externalid
//   }
// }

// module cognitiveservicemod 'main-16-cognitiveservice.bicep' = {
//   name: cognitiveServiceName
//   params: {
//     defaultTags: defaultTags
//     cognitiveServiceName: cognitiveServiceName
//     location: location
//   }
// }

module portaldashboardmod './main-11-Dashboard.bicep' = {
  name: dashboardName
  params: {
    location: location
    applicationInsightsName:appInsightsName
    name: dashboardName
    tags: defaultTags
  }
}

// ObjectId of alias RPagels
param AzObjectIdPagels string = '0aa95253-9e37-4af9-a63a-3b35ed78e98b'

// ObjectId of Service Principal "52a8e_ServicePrincipal_FullAccess"
param ADOServiceprincipalObjectId string = '1681488b-a0ee-4491-a254-728fe9e43d8c'

// Create Configuration Entries
module configsettingsmod './main-13-configsettings.bicep' = {
  name: 'configSettings'
  params: {
    keyvaultName: keyvaultName
    kvValue_configStoreConnectionName: kvValue_configStoreConnectionName
    kvValue_configStoreConnectionValue: configstoremod.outputs.out_configStoreConnectionString
    kvValue_ConnectionStringName: kvValue_ConnectionStringName
    kvValue_ConnectionStringValue: webappmod.outputs.out_secretConnectionString
    appServiceprincipalId: webappmod.outputs.out_appServiceprincipalId
    webAppName: webSiteName
    //webAppDevSlotName: webAppDevSlotName
    AzObjectIdPagels: AzObjectIdPagels
    functionAppName: functionAppName
    funcAppServiceprincipalId: functionappmod.outputs.out_funcAppServiceprincipalId
    configStoreEndPoint: configstoremod.outputs.out_configStoreEndPoint
    FontNameKey: FontNameKey
    FontColorKey: FontColorKey
    FontSizeKey: FontSizeKey
    kvValue_AzureWebJobsStorageName: kvValue_AzureWebJobsStorageName
    kvValue_AzureWebJobsStorageValue: functionappmod.outputs.out_AzureWebJobsStorage
    kvValue_WebsiteContentAzureFileConnectionStringName: kvValue_WebsiteContentAzureFileConnectionString
    kvValue_ApimSubscriptionKeyName: kvValue_ApimSubscriptionKeyName
    kvValue_ApimSubscriptionKeyValue: apimservicemod.outputs.out_ApimSubscriptionKeyString
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    appInsightsConnectionString: appinsightsmod.outputs.out_appInsightsConnectionString
    Deployed_Environment: Deployed_Environment
    ApimWebServiceURL: apimservicemod.outputs.out_ApimWebServiceURL
    ADOServiceprincipalObjectId: ADOServiceprincipalObjectId
    }
    dependsOn:  [
     keyvaultmod
     webappmod
     functionappmod
     configstoremod
   ]
 }

// Add Role Assignments
module roleAssignments './main-99-RoleAssignments.bicep' = {
  name: 'addRoleAssignments'
  params: {
    loadTestResourceName: loadTestsName
    signInNameObjectId: AzObjectIdPagels
    configStoreName: configStoreName
    webappName: webSiteName
    }
    dependsOn:  [
      configsettingsmod
      loadtestsmod
    ]
}

 // Create Front Door
//module frontdoormod './main-14-frontdoor.bicep' = {
//  name: frontDoorName
//  params: {
//  backendAddress: '${apiServiceName}.azure-api.net'  //
//  frontDoorName: frontDoorName
//  }
//}

// Output Params used for IaC deployment in pipeline
output out_webSiteName string = webSiteName
output out_sqlserverName string = sqlserverName
output out_sqlDBName string = sqlDBName
output out_sqlserverFQName string = sqldbmod.outputs.sqlserverfullyQualifiedDomainName
output out_configStoreName string = configStoreName
output out_appInsightsName string = appInsightsName
output out_functionAppName string = functionAppName
output out_apiServiceName string = apiServiceName
output out_loadTestsName string = loadTestsName
output out_apimSubscriptionKey string = apimservicemod.outputs.out_ApimSubscriptionKeyString
output out_keyvaultName string = keyvaultName
output out_secretConnectionString string = webappmod.outputs.out_secretConnectionString
output out_appInsightsApplicationId string = appinsightsmod.outputs.out_appInsightsApplicationId
output out_appInsightsAPIApplicationId string = appinsightsmod.outputs.out_appInsightsAPIApplicationId
output out_releaseAnnotationGuidID string = releaseAnnotationGuid
