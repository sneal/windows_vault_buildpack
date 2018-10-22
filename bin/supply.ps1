echo "-----> Windows Vault Buildpack"

$buildDir = $args[0]
$depsDir = $args[2]
$index = $args[3]

$buildPackBinDir = $PSScriptRoot
$profileDir = Join-Path $buildDir -ChildPath '.profile.d'
$vaultBatDest = Join-Path $profileDir -ChildPath 'load_vault.bat'
$vaultPs1Src = Join-Path $buildPackBinDir -ChildPath 'load_vault.ps1'
$vaultPs1Dest = (Join-Path $depsDir -ChildPath $index | Join-Path -ChildPath 'load_vault.ps1')
$vaultPs1Exe = "%~dp0\..\..\deps\$index\load_vault.ps1"

# create batch file which will execute the powershell script in the dep/$idx dir
New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
echo '@echo off' | Out-File -Encoding ASCII "$vaultBatDest"
echo "powershell.exe -ExecutionPolicy Unrestricted -File ""$vaultPs1Exe""" | Out-File -Append -Encoding ASCII "$vaultBatDest"

# copy the load_vault.ps1 script to the dep/$idx dir
Copy-Item $vaultPs1Src -Destination $vaultPs1Dest
