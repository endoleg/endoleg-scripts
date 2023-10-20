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

<#
#Here is a version that adds “Open Powershell” with a submenu of “Open Powershell here” and “Open Powershell here Admin”

if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\shell\01MenuPowerShell") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\shell\01MenuPowerShell" -force -ea SilentlyContinue };
if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\01MenuPowerShell") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\background\shell\01MenuPowerShell" -force -ea SilentlyContinue };
if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\open") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\open" -force -ea SilentlyContinue };
if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\open\command" -force -ea SilentlyContinue };
if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas" -force -ea SilentlyContinue };
if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas\command" -force -ea SilentlyContinue };
if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\shell\Powershell") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\shell\Powershell" -force -ea SilentlyContinue };
if((Test-Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\Powershell") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Directory\background\shell\Powershell" -force -ea SilentlyContinue };
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\shell\01MenuPowerShell' -Name 'MUIVerb' -Value "Open PowerShell" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\shell\01MenuPowerShell' -Name 'Icon' -Value "powershell.exe" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\shell\01MenuPowerShell' -Name 'ExtendedSubCommandsKey' -Value "Directory\\ContextMenus\\MenuPowerShell" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\background\shell\01MenuPowerShell' -Name 'MUIVerb' -Value "Open PowerShell" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\background\shell\01MenuPowerShell' -Name 'Icon' -Value "powershell.exe" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\background\shell\01MenuPowerShell' -Name 'ExtendedSubCommandsKey' -Value "Directory\\ContextMenus\\MenuPowerShell" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\open' -Name 'MUIVerb' -Value "PowerShell here" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\open' -Name 'Icon' -Value "powershell.exe" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\open\command' -Name '(default)' -Value "powershell.exe -noexit -command Set-Location '%V'" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas' -Name 'MUIVerb' -Value "PowerShell here (Admin)" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas' -Name 'Icon' -Value "powershell.exe" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas' -Name 'HasLUAShield' -Value "" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\ContextMenus\MenuPowerShell\shell\runas\command' -Name '(default)' -Value "powershell.exe -noexit -command Set-Location '%V'" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\shell\Powershell' -Name 'Extended' -Value "" -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Directory\background\shell\Powershell' -Name 'Extended' -Value "" -PropertyType String -Force -ea SilentlyContinue;
#>
