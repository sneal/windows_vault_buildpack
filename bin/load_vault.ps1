echo "Populating the local Windows vault"

# ensure we have services bound
if (Test-Path env:VCAP_SERVICES) {
  # find all services tagged with windows-vault
  $vcapservices = (echo $env:VCAP_SERVICES | ConvertFrom-Json)
  $creds = $vcapservices.psobject.properties.value | ? { $_.tags -eq 'windows-vault' } | % { $_.credentials }

  # find all services tagged with 'windows-vault'
  foreach ($cred in $creds) {
    # ensure the creds match the schema we support
    if (-not ($cred.username -and $cred.password -and $cred.network_address)) {
      echo 'Failed to store credentials because one or more properties were missing: username, password, network_address.'
    }
    else {
      echo "Storing encrypted credentials for $($cred.network_address)"
      vaultcmd /addcreds:"Windows Credentials" /credtype:"Windows Domain Password Credential" /identity:"$($cred.username)" /authenticator:"$($cred.password)" /resource:"$($cred.network_address)" /savedby:windows-vault-bp | Out-Null
    }
  }
}
