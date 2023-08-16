// Deploy Azure infrastructure for app + data + monitoring

// Region for all resources
param location string = resourceGroup().location
param webSiteName string
param webAppPlanName string
param keyvaultName string

@secure()
param cloudFlareAPIToken string

@secure()
param cloudFlareZoneID string


// Add DNS Registration for Web App
module dnsRegistration './99-DNSCertificateBindings.bicep' = {
  name: 'dnsRegistration'
  params: {
    webAppName: webSiteName
    location: location
    cloudFlareAPIToken: cloudFlareAPIToken
    cloudFlareZoneId: cloudFlareZoneID
    cloudFlareRecordName: 'mercuryhealth.org'
    keyvaultName: keyvaultName
    webAppPlanName: webAppPlanName

    }
    // dependsOn:  [
    //   webappmod
    // ]
}

output out_endpointUri string = dnsRegistration.outputs.endpointUri
//output certificateThumbprint string = dnsRegistration.outputs.certificateThumbprint

