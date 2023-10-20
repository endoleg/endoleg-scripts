If (!(Test-Path "HKCR:"))
{
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
$registryPath = "HKCR:\Directory\Background\shell"
$Name = "AdminPowershell"
New-Item -Path $registryPath -Name $Name -Force | Out-Null
$registryPath = "HKCR:\Directory\Background\shell\AdminPowershell"
$Name = "command"
New-Item -Path $registryPath -Name $Name -Force | Out-Null
$registryPath = "HKCR:\Directory\Background\shell\AdminPowershell\command"
$Name = "(Default)"
$value = "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe start-process powershell -verb runas"
IF(!(Test-Path $registryPath))
{
New-Item -Path $registryPath -Force | Out-Null
}
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force | Out-Null
If (!(Test-Path "HKCR:"))
{
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
$registryPath = "HKCR:\Directory\Background\shell"
$Name = "AdminPowershellISE"
New-Item -Path $registryPath -Name $Name -Force | Out-Null
$registryPath = "HKCR:\Directory\Background\shell\AdminPowershellISE"
$Name = "command"
New-Item -Path $registryPath -Name $Name -Force | Out-Null
$registryPath = "HKCR:\Directory\Background\shell\AdminPowershellISE\command"
$Name = "(Default)"
$value = "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe start-process powershell_ise -verb runas"
IF(!(Test-Path $registryPath))
{
New-Item -Path $registryPath -Force | Out-Null
}
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force | Out-Null
If (!(Test-Path "HKCR:"))
{
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
$registryPath = "HKCR:\Directory\Background\shell"
$Name = "\OpenPowershellHere"
New-Item -Path $registryPath -Name $Name -Force | Out-Null
$registryPath = "HKCR:\Directory\Background\shell\OpenPowershellHere"
$Name = "command"
New-Item -Path $registryPath -Name $Name -Force | Out-Null
$registryPath = "HKCR:\Directory\Background\shell\\OpenPowershellHere\command"
$Name = "(Default)"
$value = "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command Set-Location -LiteralPath '%V'"
IF(!(Test-Path $registryPath))
{
New-Item -Path $registryPath -Force | Out-Null
}
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force | Out-Null
