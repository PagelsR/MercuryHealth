param skuName string = 'S1'
//param skuCapacity int = 1
param location string = resourceGroup().location
// param Deployed_Environment string
param sqlserverName string
param sqlserverfullyQualifiedDomainName string
param sqlDBName string

// Azure SQL Credentials
@secure()
param sqlAdminLoginPassword string
@secure()
param sqlAdminLoginName string

param webAppPlanName string
param webSiteName string
param webAppDevSlotName string
param resourceGroupName string
param appInsightsName string
// param appInsightsInstrumentationKey string
// param appInsightsConnectionString string
param defaultTags object

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: webAppPlanName
  location: location
  tags: defaultTags
  properties: {}
  sku: {
    name: skuName
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webSiteName
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  tags: defaultTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      healthCheckPath: '/healthy'
      netFrameworkVersion: 'v6.0'
      alwaysOn: true
      autoHealEnabled: true
    }
  }
}

/////////////////////////////////////////////////
// Used for Multiple App Service Deployment Slots
/////////////////////////////////////////////////

// Create Web App's staging slot
resource webappSlotDevName 'Microsoft.Web/sites/slots@2022-09-01' = {
  name: webAppDevSlotName //'${appService.name}/${webAppDevSlotName}'
  parent: appService
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'webAppSlots'
  }
  properties: {
    enabled: true
    httpsOnly: true
    serverFarmId: appServicePlan.id
  }
}

// Set specific app settings to be "sticky" slot specific value
resource webSlotConfig 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'slotConfigNames'
  parent: appService
  properties: {
    appSettingNames: [
      'WebAppUrl'
      'AspNetCore_Environment'
    ]
  }
}

// Location population tags
// https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability

resource standardWebTestPageHome  'Microsoft.Insights/webtests@2022-06-15' = {
  name: 'Page Home'
  location: location
  tags: {
    'hidden-link:${subscription().id}/resourceGroups/${resourceGroupName}/providers/microsoft.insights/components/${appInsightsName}': 'Resource'
   }
  kind: 'ping'
  properties: {
    SyntheticMonitorId: appInsightsName
    Name: 'Page Home'
    Description: null
    Enabled: true
    Frequency: 300
    Timeout: 120 
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      {
        Id: 'us-va-ash-azr'  // East US
      }
      {
        Id: 'us-fl-mia-edge' // Central US
      }
      {
        Id: 'us-ca-sjc-azr' // West US
      }
      {
        Id: 'emea-au-syd-edge' // Austrailia East
      }
      {
        Id: 'apac-jp-kaw-edge' // Japan East
      }
    ]
    Configuration: null
    Request: {
      RequestUrl: 'https://${appService.name}.azurewebsites.net/'
      Headers: null
      HttpVerb: 'GET'
      RequestBody: null
      ParseDependentRequests: false
      FollowRedirects: null
    }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      IgnoreHttpStatusCode: false
      ContentValidation: null
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 7
    }
  }
}

resource standardWebTestPageNutritions  'Microsoft.Insights/webtests@2022-06-15' = {
  name: 'Page Nutritions'
  location: location
  tags: {
    'hidden-link:${subscription().id}/resourceGroups/${resourceGroupName}/providers/microsoft.insights/components/${appInsightsName}': 'Resource'
  }
  kind: 'ping'
  properties: {
    SyntheticMonitorId: appInsightsName
    Name: 'Page Nutritions'
    Description: null
    Enabled: true
    Frequency: 300
    Timeout: 120 
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      {
        Id: 'us-va-ash-azr'  // East US
      }
      {
        Id: 'us-fl-mia-edge' // Central US
      }
      {
        Id: 'us-ca-sjc-azr' // West US
      }
      {
        Id: 'emea-au-syd-edge' // Austrailia East
      }
      {
        Id: 'apac-jp-kaw-edge' // Japan East
      }
    ]
    Configuration: null
    Request: {
      RequestUrl: 'https://${appService.name}.azurewebsites.net/Nutritions/'
      Headers: null
      HttpVerb: 'GET'
      RequestBody: null
      ParseDependentRequests: false
      FollowRedirects: null
    }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      IgnoreHttpStatusCode: false
      ContentValidation: null
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 7
    }
  }
}

resource standardWebTestPageExercises  'Microsoft.Insights/webtests@2022-06-15' = {
  name: 'Page Exercises'
  location: location
  tags: {
     'hidden-link:${subscription().id}/resourceGroups/${resourceGroupName}/providers/microsoft.insights/components/${appInsightsName}': 'Resource'
  }
  kind: 'ping'
  properties: {
    SyntheticMonitorId: appInsightsName
    Name: 'Page Exercises'
    Description: null
    Enabled: true
    Frequency: 300
    Timeout: 120 
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      {
        Id: 'us-va-ash-azr'  // East US
      }
      {
        Id: 'us-fl-mia-edge' // Central US
      }
      {
        Id: 'us-ca-sjc-azr' // West US
      }
      {
        Id: 'emea-au-syd-edge' // Austrailia East
      }
      {
        Id: 'apac-jp-kaw-edge' // Japan East
      }
    ]
    Configuration: null
    Request: {
      RequestUrl: 'https://${appService.name}.azurewebsites.net/Exercises/'
      Headers: null
      HttpVerb: 'GET'
      RequestBody: null
      ParseDependentRequests: false
      FollowRedirects: null
    }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      IgnoreHttpStatusCode: false
      ContentValidation: null
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 7
    }
  }
}

var secretConnectionString = 'Server=tcp:${sqlserverfullyQualifiedDomainName},1433;Initial Catalog=${sqlDBName};Persist Security Info=False;User Id=${sqlAdminLoginName}@${sqlserverName};Password=${sqlAdminLoginPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'

output out_appService string = appService.id
output out_webSiteName string = appService.properties.defaultHostName
output out_appServiceprincipalId string = appService.identity.principalId
output out_secretConnectionString string = secretConnectionString
