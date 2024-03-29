param keyvaultName string
param kvValue_configStoreConnectionName string
param kvValue_ConnectionStringName string
param webAppName string
//param webAppDevSlotName string
param functionAppName string
param kvValue_AzureWebJobsStorageName string
param kvValue_ApimSubscriptionKeyName string
param kvValue_WebsiteContentAzureFileConnectionStringName string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param Deployed_Environment string
param ApimWebServiceURL string
//param loadTestsName string

@secure()
param AzObjectIdPagels string

// App Configuration Settings
param configStoreEndPoint string
//param configStoreName string
param FontNameKey string
param FontColorKey string
param FontSizeKey string

@secure()
param kvValue_configStoreConnectionValue string

@secure()
param kvValue_ConnectionStringValue string

@secure()
param appServiceprincipalId string

@secure()
param funcAppServiceprincipalId string

@secure()
param kvValue_AzureWebJobsStorageValue string

@secure()
param kvValue_ApimSubscriptionKeyValue string

param tenant string = subscription().tenantId

@secure()
param ADOServiceprincipalObjectId string

// Define KeyVault accessPolicies
param accessPolicies array = [
  {
    tenantId: tenant
    objectId: appServiceprincipalId
    permissions: {
      keys: [
        'get'
        'list'
      ]
      secrets: [
        'get'
        'list'
      ]
    }
  }
  {
    tenantId: tenant
    objectId: funcAppServiceprincipalId
    permissions: {
      keys: [
        'get'
        'list'
      ]
      secrets: [
        'get'
        'list'
      ]
    }
  }
  {
    tenantId: tenant
    objectId: AzObjectIdPagels
    permissions: {
      keys: [
        'get'
        'list'
      ]
      secrets: [
        'get'
        'list'
        'set'
        'delete'
      ]
    }
  }
  {
    tenantId: tenant
    objectId: ADOServiceprincipalObjectId
    permissions: {
      keys: [
        'get'
        'list'
      ]
      secrets: [
        'get'
        'list'
      ]
    }
  }
]

// Reference Existing resource
resource existing_keyvault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

// Create KeyVault accessPolicies
resource keyvaultaccessmod 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: existing_keyvault
  properties: {
    accessPolicies: accessPolicies
  }
}

// Create KeyVault Secrets
resource secret1 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: kvValue_configStoreConnectionName
  parent: existing_keyvault
  properties: {
    value: kvValue_configStoreConnectionValue
  }
}

// create secret for Web App
resource secret2 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: kvValue_ConnectionStringName
  parent: existing_keyvault
  properties: {
    contentType: 'text/plain'
    value: kvValue_ConnectionStringValue
  }
}
//create secret for Func App
resource secret3 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: kvValue_AzureWebJobsStorageName
  parent: existing_keyvault
  properties: {
    contentType: 'text/plain'
    value: kvValue_AzureWebJobsStorageValue
  }
}
// create secret for Func App
resource secret4 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: kvValue_WebsiteContentAzureFileConnectionStringName
  parent: existing_keyvault
  properties: {
    contentType: 'text/plain'
    value: kvValue_AzureWebJobsStorageValue
  }
}
// create secret for Func App
resource secret5 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: kvValue_ApimSubscriptionKeyName
  parent: existing_keyvault
  properties: {
    contentType: 'text/plain'
    value: kvValue_ApimSubscriptionKeyValue
  }
}

/////////////////////////////////////////////////
// Used for App Service Single Slot
/////////////////////////////////////////////////

// Reference Existing resource
resource existing_appService 'Microsoft.Web/sites@2022-09-01' existing = {
  name: webAppName
}

//Create Web sites/config 'appsettings' - Web App
resource webSiteAppSettingsStrings 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'appsettings'
  parent: existing_appService
  properties: {
    'ConnectionStrings:MercuryHealthWebContext': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_ConnectionStringName})'
    'ConnectionStrings:AppConfig': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_configStoreConnectionName})'
    DeployedEnvironment: Deployed_Environment
    WEBSITE_RUN_FROM_PACKAGE: '1'
    WEBSITE_SENTINEL: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    WebAppUrl: 'https://${existing_appService.name}.azurewebsites.net/'
    ASPNETCORE_ENVIRONMENT: 'Production'
    WEBSITE_FONTNAME: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontNameKey})'
    WEBSITE_FONTCOLOR: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontColorKey})'
    WEBSITE_FONTSIZE: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontSizeKey})'
    WEBSITE_ENABLE_SYNC_UPDATE_SITE: 'true'
  }
  dependsOn: [
    secret1
    secret2
  ]
}

// Reference Existing resource
resource existing_funcAppService 'Microsoft.Web/sites@2022-03-01' existing = {
  name: functionAppName
}
// Create Web sites/config 'appsettings' - Function App
resource funcAppSettingsStrings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'appsettings'
  kind: 'string'
  parent: existing_funcAppService
  properties: {
    AzureWebJobsStorage: '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_AzureWebJobsStorageName})'
    WebsiteContentAzureFileConnectionString: '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_WebsiteContentAzureFileConnectionStringName})'
    ApimSubscriptionKey: '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_ApimSubscriptionKeyName})'
    ApimWebServiceURL: ApimWebServiceURL
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    FUNCTIONS_EXTENSION_VERSION: '~4'
  }
  dependsOn: [
    secret3
    secret4
  ]
}

/////////////////////////////////////////////////
// Used for Multiple App Service Deployment Slots
/////////////////////////////////////////////////

// Reference Existing resource
// resource existing_appService 'Microsoft.Web/sites@2022-03-01' existing = {
//   name: webAppName
// }

// Base app settings shared for all slots
// var base_prod_webappsettings = {
// DeployedEnvironment: Deployed_Environment
//   'ConnectionStrings:MercuryHealthWebContext': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_ConnectionStringName})'
//   'ConnectionStrings:AppConfig': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_configStoreConnectionName})'
//   WEBSITE_RUN_FROM_PACKAGE: '1'
//   WEBSITE_SENTINEL: '1'
//   APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
//   APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
//   APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
//   APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
//   WEBSITE_FONTNAME: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontNameKey})'
//   WEBSITE_FONTCOLOR: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontColorKey})'
//   WEBSITE_FONTSIZE: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontSizeKey})'
//   WEBSITE_ENABLE_SYNC_UPDATE_SITE: 'true'
// }

// // Production slot unique settings
// var production_slot_webappsettings = {
//    WebAppUrl: 'https://${webAppName}.azurewebsites.net/'
//    AspNetCore_Environment: 'Production'
// }

// // Set app settings on Production slot
// resource webAppSettings 'Microsoft.Web/sites/config@2022-09-01' = {
//   name: '${webAppName}/appsettings'
//   properties: union(base_prod_webappsettings, production_slot_webappsettings)
//   dependsOn: [
//     secret1
//     secret2
//   ]
// }

// // Dev slot unique settings
// var dev_slot_webappsettings ={
//   WebAppUrl: 'https://${webAppName}-dev.azurewebsites.net/'
//   AspNetCore_Environment: 'Development'
// }
// // Set app settings on dev slot
// resource webAppStagingSlotSetting 'Microsoft.Web/sites/slots/config@2022-09-01' = {
//   name: '${webAppDevSlotName}/appsettings'
//   properties: union(base_prod_webappsettings, dev_slot_webappsettings)
//   dependsOn: [
//     secret1
//     secret2
//   ]
// }

// Set app settings on dev slot
// resource webAppStagingSlotSetting 'Microsoft.Web/sites/slots/config@2022-09-01' = {
//   name: '${webAppDevSlotName}/appsettings'
//   properties: {
//     'ConnectionStrings:MercuryHealthWebContext': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_ConnectionStringName})'
//     'ConnectionStrings:AppConfig': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${kvValue_configStoreConnectionName})'
//     DeployedEnvironment: Deployed_Environment
//     WEBSITE_RUN_FROM_PACKAGE: '1'
//     WEBSITE_SENTINEL: '1'
//     APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
//     APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
//     APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
//     APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
//     WebAppUrl: 'https://${existing_appService.name}.azurewebsites.net/'
//     ASPNETCORE_ENVIRONMENT: 'Development'
//     WEBSITE_FONTNAME: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontNameKey})'
//     WEBSITE_FONTCOLOR: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontColorKey})'
//     WEBSITE_FONTSIZE: '@Microsoft.AppConfiguration(Endpoint=${configStoreEndPoint}; Key=${FontSizeKey})'
//     WEBSITE_ENABLE_SYNC_UPDATE_SITE: 'true'
//   }
//   dependsOn: [
//     secret1
//     secret2
//   ]
// }



