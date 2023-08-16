param location string
param cloudFlareRecordName string
//param cloudFlareProxy bool

param keyvaultName string
param webAppName string
param webAppPlanName string

@secure()
param cloudFlareAPIToken string

@secure()
param cloudFlareZoneId string



// var record = 'mercuryhealth.org'
// var domain = 'naya.ns.cloudflare.com'
var record = 'www'
//var domain = cloudFlareRecordName

// @description('The custom hostname that you wish to add.')
// param customHostname string = cloudFlareRecordName

@description('Existing Key Vault resource Id for the SSL certificate, leave this blank if not enabling SSL')
param existingKeyVaultId string = '/subscriptions/295e777c-2a1b-456a-989e-3c9b15d52a8e/resourceGroups/MPNRPagelsVault/providers/Microsoft.KeyVault/vaults/${keyvaultName}'
//param secretName  string = 'ExampleCertificateNoPass'

resource existing_keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: existingKeyVaultId
}

@description('Key Vault Secret that contains a PFX certificate, leave this blank if not enabling SSL')
param existingKeyVaultSecretName string = 'ExampleCertificateNoPass'

var certificateName = 'ExampleCertificateNoPass' //'${webAppName}-cert'
var enableSSL = (!empty(existingKeyVaultId))



// Reference Existing resource - App Service Plan
resource existing_appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: webAppPlanName
  location: location
}

// Reference Existing resource - App Service
resource existing_appService 'Microsoft.Web/sites@2022-09-01' existing = {
  name: webAppName
}

// resource cloudflareDnsRecord 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'cloudflare'
//   location: location
//   kind: 'AzurePowerShell'
//   properties: {
//     forceUpdateTag: '1'
//     azPowerShellVersion: '8.3'
//     arguments: '-hostname "${record}" -domain "${domain}" -destination "${existing_appService.properties.defaultHostName}"'
//     environmentVariables: [
//       {
//         name: 'CLOUDFLARE_API_TOKEN'
//         secureValue: cloudFlareAPIToken
//       }
//       {
//         name: 'CLOUDFLARE_ZONE_ID'
//         secureValue: cloudFlareZoneId
//       }
//     ]
//     scriptContent: '''
//       param([string] $hostname, [string] $domain, [string] $destination)

//       $zoneid = $Env:CLOUDFLARE_ZONE_ID
//       $url = "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records"
      
//       $addresses = (
//           ("awverify.$hostname.$domain", "awverify.$destination"),
//           ("$hostname.$domain", "$destination")
//       )
      
//       foreach($address in $addresses)
//       {
//           $name = $address[0]
//           $content = $address[1]
//           $token = $Env:CLOUDFLARE_API_TOKEN
      
//           $existingRecord = Invoke-RestMethod -Method get -Uri "$url/?name=$name" -Headers @{
//               "Authorization" = "Bearer $token"
//           }
      
//           if($existingRecord.result.Count -eq 0)
//           {
//               $Body = @{
//                   "type" = "CNAME"
//                   "name" = $name
//                   "content" = $content
//                   "ttl" = "120"
//               }
              
//               $Body = $Body | ConvertTo-Json -Depth 10
//               $result = Invoke-RestMethod -Method Post -Uri $url -Headers @{ "Authorization" = "Bearer $token" } -Body $Body -ContentType "application/json"
              
//               Write-Output $result.result
//           }
//           else 
//           {
//               Write-Output "Record already exists"
//           }
//       }    
//     '''
//     supportingScriptUris: []
//     timeout: 'PT30M'
//     cleanupPreference: 'OnSuccess'
//     retentionInterval: 'P1D'
//   }
// }

// resource hostName 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
//   name: '${record}.${domain}'
//   parent: existing_appService

//   dependsOn: [
//     cloudflareDnsRecord
//   ]
// }


resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: existing_keyVault
  name: existingKeyVaultSecretName
  properties: {
    contentType: 'application/x-pkcs12'
    // value: 'your-certificate-value'
  }
}





resource certificate 'Microsoft.Web/certificates@2019-08-01' = if (enableSSL) {
  name: certificateName
  location: location
  properties: {
    keyVaultId: existingKeyVaultId
    keyVaultSecretName: existingKeyVaultSecretName
    serverFarmId: existing_appServicePlan.id
    password: ''
  }
  dependsOn: [
    existing_appService
  ]
}

resource webAppName_cloudFlareRecordName 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: existing_appService
  name: cloudFlareRecordName
  properties: {
    sslState: (enableSSL ? 'SniEnabled' : null)
    thumbprint: (enableSSL ? certificate.properties.thumbprint : null)
  }
}



output keyVaultSecretValue string = keyVaultSecret.properties.value

// resource certificateOrder 'Microsoft.CertificateRegistration/certificateOrders@2022-09-01' = {
//   name: '${webAppName}-certificate'
//   location: location
//   properties: {
//     certificates: {
//       password: 'your-certificate-password'
//       distinguishedName: {
//       commonName: webAppName
//       }
//     }
//   }
//   sku: {
//     name: 'Standard_DomainValidation'
//   }
//   dependsOn: [
//     existing_appService
//   ]
// }

// resource certificateBinding 'Microsoft.Web/sites/hostNameBindings@2021-02-01' = {
//   parent: existing_appService
//   name: '${webAppName}-certificate-binding'
//   properties: {
//     siteName: existing_appService.name
//     sslState: 'SniEnabled'
//     thumbprint: certificateOrder.properties.certificates[0].thumbprint
//     sslType: 'Standard'
//   }
//   dependsOn: [
//     certificateOrder
//   ]
// }





output endpointUri string = existing_appService.properties.defaultHostName
//output certificateThumbprint string = certificateOrder.properties.certificates[0].thumbprint

