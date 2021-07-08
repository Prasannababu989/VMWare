#PowerCLI install

Find-Module -Name VMware.PowerCLI
Install-Module -Name VMware.PowerCLI -Scope AllUsers
Import-Module VMware.VimAutomation.Core
Get-Command -Module *VMWare*

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
 
set-executionpolicy unrestricted
set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$False
set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope Session
set-ExecutionPolicy remotesigned
