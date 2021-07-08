Clear-Host
#**************************************************************
$labcreds = Get-Credential
#****************************************************************

#Connect to VCenter
Connect-VIServer lsvchyd03.lab.opentext.com -Credential $labcreds
#*****************************************************************
##Variables for Hyderatbad VCenter lsvchyd03.lab.opentext.com
$HCluster = Get-Cluster
$HVMHosts = Get-VMHost
$HVMS = Get-VM
#****************************************************************

#Loop- to get VMS list which are powered off with Windows OS
$HVMS = Get-vm
foreach ($HVM in $HVMS) {
    $HVM | Where-Object { $_.PowerState -eq "PoweredOff" } | Select-Object Name, Powerstate, Guest
}

#Get Advanced Settings of each host in a VC
# UserVars.ESXiShellTimeOut
foreach ($HVMHost in $HVMHosts) {
    $HVMHost | Get-AdvancedSetting -name 'Net.BlockGuestBPDU'
    $HVMHost | Get-AdvancedSetting -name 'Net.TcpipHeapMax' 
    $HVMHost | Get-AdvancedSetting -name 'Net.TcpipHeapSize'
    $HVMHost | Get-AdvancedSetting -name 'NFS.MaxVolumes' 
    $HVMHost | Get-AdvancedSetting -name 'NFS.MaxQueueDepth' 
    $HVMHost | Get-AdvancedSetting -name 'Security.AccountLockFailures'
    $HVMHost | Get-AdvancedSetting -name 'Security.AccountUnlockTime'
    $HVMHost | Get-AdvancedSetting -name 'UserVars.ESXiShellInteractiveTimeOut'
    $HVMHost | Get-AdvancedSetting -name 'UserVars.ESXiShellTimeOut'
    $HVMHost | Get-AdvancedSetting -name 'UserVars.SuppressHyperthreadWarning'
    $HVMHost | Get-AdvancedSetting -name 'UserVars.SuppressShellWarning'
    $HVMHost | Get-AdvancedSetting -name 'Syslog.global.logDirUnique'
} 
 
#Result in CSV file
$Output = @()
$ESXHosts = Get-VMHost
foreach ($ESXHost in $ESXHosts) {
    $output += Get-VMHost $ESXHost | Get-AdvancedSetting -name UserVars.ESXiShellTimeOut
} 
$output | Export-Csv C:\users\pvasanth\Desktop\prasanna.csv
