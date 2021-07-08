Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
 
set-executionpolicy unrestricted
set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$False
set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope Session
set-ExecutionPolicy remotesigned

#Join AD for a new Esxi host
 
Get-VMHostAuthentication -VMHost wok-esx0101-m01.resldap.net | Set-VMHostAuthentication -JoinDomain -Domain "idldap.net" -User snarendr -Password XXXXXXX
 
Advanced configuration

Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'Net.BlockGuestBPDU' | Set-AdvancedSetting -Value '1' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'Net.TcpipHeapMax' | Set-AdvancedSetting -Value '1536' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'Net.TcpipHeapSize' | Set-AdvancedSetting -Value '32' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'NFS.MaxVolumes' | Set-AdvancedSetting -Value '256' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'NFS.MaxQueueDepth' | Set-AdvancedSetting -Value '128' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'Security.AccountLockFailures' | Set-AdvancedSetting -Value '3' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'Security.AccountUnlockTime' | Set-AdvancedSetting -Value '900' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'UserVars.ESXiShellInteractiveTimeOut' | Set-AdvancedSetting -Value '900' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'UserVars.ESXiShellTimeOut' | Set-AdvancedSetting -Value '900' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'UserVars.SuppressHyperthreadWarning' | Set-AdvancedSetting -Value '1' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'UserVars.SuppressShellWarning' | Set-AdvancedSetting -Value '0' -Confirm:$false
Get-AdvancedSetting -Entity sl-esx01-p006.resldap.net -Name 'Syslog.global.logDirUnique' | Set-AdvancedSetting -Value $True -Confirm:$false
