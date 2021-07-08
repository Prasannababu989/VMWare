#PowerCLI install
Find-Module -Name VMware.PowerCLI
Install-Module -Name VMware.PowerCLI -Scope AllUsers
Import-Module VMware.VimAutomation.Core
Get-Command -Module *VMWare*

#Connect VCenter
Connect-VIServer lsvchyd03.lab.opentext.com -User pvasanth.lab -Password Welcome032021
$cvcs = Connect-VIServer ban-vcs02-l001.otxlab.net
 -User pvasanth.lab -Password Welcome032021
Get-ExecutionPolicy 
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Disconnect-VIServer *

#VM
Get-VM
Get-VM | Select-Object Name,PowerState
$VM = Get-VM | Select-Object Name,PowerState
Get-VM | Where-Object {$_.PowerState -eq "Poweredoff"}
Get-VM | Where-Object {$_.PowerState -eq "Poweredoff"} | Export-csv "C:\temp\PowerShell\VMpowestate.csv"
Get-VM | Where-Object {$_.PowerState -eq "Poweredoff"} | Select-Object Name,Num
Get-VM | Get-Member
Get-Datacenter
Get-VMHost -name ban-esx02-l060.otxlab.net | Select-Object -Entity
Get-AdvancedSetting -Entity (Get-VMHost ban-esx02-l060.otxlab.net)
Get-VirtualSwitch -Name (Get-VMHost ban-esx02-l060.otxlab.net)
Get-VirtualSwitch | Select-Object -Property VMHost,Name | Export-Csv "C:\temp\Learn PowerShell\BangNetwork.csv"
Get-VMHost -name ban-esx02-l060.otxlab.net |Select-Object Name,NetworkInfo | Select-Object -Property VMHost,Name | Export-Csv "C:\temp\Learn PowerShell\BangNetwork.csv"
Get-AdvancedSetting -Entity (Get-VMHost lsesxhyd26. jlab.opentext.com) -Name "Syslog.global.logDir" | Select-Object Entity, Name, Value
Get-VMHost -name ban-esx02-l063.otxlab.net|Get-VMHostNetwork
Get-VMHost -name ban-esx02-l063.otxlab.net|Get-VMHostHardware
Get-VMHost -name ban-esx02-l063.otxlab.net|Get-VMHostService | Where-Object {$_.key -eq 'snmpd'} | Select-Object Label,Running
Get-VMHost |Get-VMHostService | Where-Object {$_.key -eq 'snmpd'} | Select-Object VMHost,Label,Running|Export-Csv 'C:\temp\Learn PowerShell\Bang_snmp.csv'


#Get list of VMs
Get-VM
Get-VM | where-object {$_.PowerState-eq "Poweredoff"}

#VMHost
Get-VMhost | Sort-Object CpuUsageMhz
$VMH = Get-VMhost | Sort-Object CpuUsageMhz
Get-VMhost | Select-Object Name, Powerstate, MemoryTotalGB
Get-VMhost lsesxhyd60.lab.opentext.com | Get-VM | Select-Object Name, MemoryGB
Get-VMhost lsesxhyd60.lab.opentext.com | Select-Object -Property *
Get-VMhost | Select-Object -Property *
Get-VMhost lsesxhyd60.lab.opentext.com | Select-Object Name,Manufacturer,Model
Get-VMhost lsesxhyd60.lab.opentext.com | Select-Object Name,Manufacturer,Model | export-csv "C:\temp\Learn PowerShell\test.csv"
Get-VMhost | Select-Object Name,Manufacturer,Model | export-csv "C:\temp\Learn PowerShell\test.csv"
Get-VMhost lsesxhyd60.lab.opentext.com | Get-VM ravi4562-SA71
Get-VMhost lsesxhyd60.lab.opentext.com | Get-VM ravi4562-SA71 | Select-Object-Object -Property *
Get-VM ravi4562-SA71 | Select-Object-Object Name, Version, ToolsVersion, ToolsVersionStatus
Get-VM | Get-member
Get-VM RHEL77AIP-xS4b | Select-Object-Object -expandproperty ExtensionData | Select-Object -expandproperty guest
#Get list of Hosts
Get-VMHost
Get-VMHost|Select-Object-Object Name,connectionstate
Get-VMHost |Sort  Name |Get-View

#Get Events 
Get-vievent -Start "03/30/2021 10:00:00" -Finish "03/30/2021 11:00:00" | Where-Object {$_.FullFormattedMessage -like "*Alarm*"}
Get-VMhost | get-member 


# To get ESX host advanced setting
Get-VMHost -name lsesxhyd80.lab.opentext.com | Get-AdvancedSetting -Name Syslog.global.logDir
Get-AdvancedSetting -Entity (Get-VMHost ) -Name Syslog.global.logHost,Syslog.global.logDir | Select-Object Entity, Name, Value

Get-AdvancedSetting -Entity (Get-VMHost ban-esx02-l038.lab.opentext.com) -Name "Syslog.global.logDir" | Select-Object Entity, Name, Value
Get-VMHost -name lsesxhyd80.lab.opentext.com|Get-VMHostService|Where-Object {$_.key -eq 'TSM-SSH'} | Select-Object Label,Running
Get-VMHost|Get-VMHostService|Where-Object {$_.key -eq 'TSM-SSH'} | Select-Object VMHost,Label,Running
Get-VMHost | Get-VMHostService | Get-Member

#List Out services
Get-VMHost -name lsesxhyd26.lab.opentext.com | Get-VMHostService | Format-Table -AutoSize
Get-VMHost -name ban-esx02-l063.otxlab.net|Get-member | Get-VMHostService 
Get-VMHost | Select-Object Name,DatastoreIdList,Manufacturer,Model,Version | export-csv "C:\temp\Learn PowerShell/Bang.csv"
Get-VMHost | Get-Member

Get-AlarmAction -AlarmDefinition (Get-AlarmDefinition | Select-Object -First 10) | Get-AlarmActionTrigger
Get-AlarmDefinition -Server lsvchyd03.lab.opentext.com
Get-Cluster |Get-AdvancedSetting
Get-Cluster ResourceCluster20-HYD | Get-DrsRecommendation -Priority 4,5

#Get list of VMs
Get-VM
Get-VM | where-object {$_.PowerState-eq "Poweredoff"}

#Get list of Hosts
Get-VMHost
Get-VMHost|Select-Object-Object Name,connectionstate
Get-VMHost | Sort Name |Get-View

#Get Events 
Get-vievent -Start "03/30/2021 10:00:00" -Finish "03/30/2021 11:00:00" | Where-Object {$_.FullFormattedMessage -like "*Alarm*"}
Get-VMhost | get-member 


# To get ESX host advanced setting
Get-VMHost -name lsesxhyd80.lab.opentext.com | Get-AdvancedSetting -Name 'Syslog.global.logDir'
Get-AdvancedSetting -Entity (Get-VMHost ) -Name "Syslog.global.logDir" | Select-Object Entity, Name, Value
Get-AdvancedSetting -Entity (Get-VMHost lsesxhyd26.lab.opentext.com) -Name "Syslog.global.logDir" | Select-Object Entity, Name, Value
Get-VMHost|Get-VMHostService ssh

#List Out services
Get-VMHost -name lsesxhyd26.lab.opentext.com | Get-VMHostService | Format-Table -AutoSize
Get-VMHost|Get-VMHostService 

Get-AlarmAction -AlarmDefinition (Get-AlarmDefinition | Select-Object -First 10) | Get-AlarmActionTrigger
Get-AlarmDefinition -Server lsvchyd03.lab.opentext.com

# Connect VCenter
Connect-VIServer ban-vcs02-l001.otxlab.net -User pvasanth.lab -Password Welcome032021

Get-VMHost | Select-Object Name,PowerState
# Set value UserVars.ESXiShellTimeOut 900
Get-AdvancedSetting -Entity (Get-VMHost) _Name "UserVars.ESXiShellTimeOut"
Get-AdvancedSetting -Entity (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut" | Select-Object Entity, Name, Value

Get-VMHostAdvancedConfiguration (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut"
Set-VMHostAdvancedConfiguration (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut" -Value "900"


Get-Advancedsetting (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut"
Set-VMHostAdvancedConfiguration (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut" -Value "0"


$value = Get-Advancedsetting (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut"

$value = Get-Advancedsetting (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut" | Select-Object Value



$value.Name

$value = Get-Advancedsetting (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut" | Select-Object Value
if ($value.value -eq "0")
{ Write-Host "Sucess" -ForegroundColor DarkGreen}
else
{write-host "Failed" -ForegroundColor Red}






















