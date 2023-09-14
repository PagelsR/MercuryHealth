// Deploy Azure infrastructure for app + data + monitoring

// Region for all resources
param location string = resourceGroup().location
param webSiteName string
param keyvaultName string

// var kvValue_CertificateName = 'ExampleCertificate'
// var kvValue_CertificateValue = '<base64-encoded-pfx-content>'

@secure()
param cloudFlareAPIToken string

@secure()
param cloudFlareZoneID string

// Reference Existing resource
// resource existing_keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
//   name: keyvaultName
// }

// Create KeyVault Secret for PFX contents
// resource secretCert 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
//   name: kvValue_CertificateName
//   parent: existing_keyvault
//   properties: {
//     value: kvValue_CertificateValue
//   }
// }


// Add DNS Registration for Web App
// module dnsRegistration './99-DNSCertificateBindings.bicep' = {
//   name: 'dnsRegistration'
//   params: {
//     webAppName: webSiteName
//     location: location
//     cloudFlareAPIToken: cloudFlareAPIToken
//     cloudFlareZoneId: cloudFlareZoneID
//     cloudFlareRecordName: 'mercuryhealth.org'
//     keyvaultName: keyvaultName

//     }
// }

module dnsRegistration './99-DNSCertificateBindingsV2.bicep' = {
  name: 'dnsRegistration'
  params: {
    webAppName: webSiteName
    location: location
    cloudFlareAPIToken: cloudFlareAPIToken
    cloudFlareZoneId: cloudFlareZoneID
    cloudFlareRecordName: 'mercuryhealth.org'
    }
}

output out_endpointUri string = dnsRegistration.outputs.endpointUri
//output certificateThumbprint string = dnsRegistration.outputs.certificateThumbprint

