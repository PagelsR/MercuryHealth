param sqlserverName string
param sqlDBName string

// Azure SQL Credentials
@secure()
param sqlAdminLoginName string
@secure()
param sqlAdminLoginPassword string

param location string = resourceGroup().location
param defaultTags object

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlserverName
  location: location
  tags: defaultTags
  properties: {
    administratorLogin: sqlAdminLoginName
    administratorLoginPassword: sqlAdminLoginPassword
    version: '12.0'
    minimalTlsVersion: 'none'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  tags: defaultTags
  sku: {
    name:'Basic'
    tier: 'Basic'
    capacity: 5
  }
  kind: 'v12.0,user'
  properties: {
    requestedBackupStorageRedundancy: 'Local'
    zoneRedundant: false
    availabilityZone: 'NoPreference'
    readScale: 'Disabled'
    autoPauseDelay: 60
    minCapacity: 1
  }
}

resource sqlserverName_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '255.255.255.255'
    startIpAddress: '0.0.0.0'
  }
}

output sqlserverfullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName
