param webAppName string
param resourceGroupName string
param certificatePfx string
param certificatePassword string
param certificateThumbprint string

// Reference Existing resource
resource existing_appService 'Microsoft.Web/sites@2022-09-01' existing = {
  name: webAppName
}

resource sslBinding 'Microsoft.Web/sites/hostNameBindings@2020-06-01' = {
  name: '${webAppName}/sslbinding'
  properties: {
    sslState: 'SniEnabled'
    thumbprint: certificateThumbprint
    toUpdate: {
      name: 'SniHostName'
      sslState: 'SniEnabled'
      thumbprint: certificateThumbprint
    }
  }
}

output webAppUrl string = existing_appService.properties.defaultHostName
