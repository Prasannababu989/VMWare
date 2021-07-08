###
###   Gather ESXi Host Settings
###
###        20/02/2021
###

Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCEIP $false -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false  2>&1 | Out-Null

clear host

#
# Connect to Virtual Center
#

Write-Host "" 
Write-Host "" 

$vcenter = Read-Host -Prompt "Please enter FQDN of the Virtual Center" 

clear host

Write-Host ""
Write-Host ""

Write-Host "Connecting to " $vCenter -ForegroundColor Green 

Write-Host ""
Write-Host ""

$creds = get-credential

Connect-VIServer $vcenter -Credential $creds

Clear host
Write-Host ""
Write-Host ""

Write-Host "Querying ESXi Host Settings.......please wait!!!"  -ForegroundColor white


Add-PSSnapin VMware.VimAutomation.Core -ErrorAction 'SilentlyContinue'


#The command below will get the name of the ESXi host
$esxi = Get-VMHost | Sort Name

#Get ESXi Build Version
$getVersion = $esxi | Select-Object Name, Version, Build, MaxEVCMode, HyperthreadingActive, NumCpu, MemoryTotalGB, Model, ProcessorType, @{N = 'Serial Number'; E = { (Get-EsxCli -VMHost $_).hardware.platform.get().SerialNumber } } | Sort-Object Name | ConvertTo-Html -Fragment -PreContent "<h3>ESXi Version/Build</h3>"

#Check if alarms are disable for ESXi host

$alarmenabled = $esxi | Where-Object { $_.extensiondata.AlarmActionsEnabled -eq $true } | select Name, ConnectionState | Sort-Object Name | ConvertTo-Html -Fragment -PreContent "<h3>Alarms Actions ENABLED</h3>"
$alarmdisabled = $esxi | Where-Object { $_.extensiondata.AlarmActionsEnabled -eq $false } | select Name, ConnectionState | Sort-Object Name | ConvertTo-Html -Fragment -PreContent "<h3>Alarms Actions DISABLED</h3>"


#Get Advanced Settings
$getAdv = Get-AdvancedSetting -Entity (Get-VMHost) -Name UserVars.ESXiShellTimeOut, UserVars.ESXiShellInteractiveTimeOut, Security.AccountLockFailures, Security.AccountUnlockTime, syslog.global.logdir, syslog.global.logdirunique, Syslog.global.logHost, ScratchConfig.ConfiguredScratchLocation, Net.BlockGuestBPDU, NFS.MaxVolumes, Net.TcpipHeapSize, Net.TcpipHeapMax | Select Entity, Name, Value | sort-object -Property Name, Entity | ConvertTo-Html -Fragment -PreContent "<h3>ESXi Advanced Settings</h3>"

#Get DNS Settings
$getDNS = Get-VMHostNetwork -VMHost $esxi | Select HostName, @{Name = "DNS IP Address"; Expression = { $_.DnsAddress } } | sort-object -Property Hostname | ConvertTo-Html -Fragment -PreContent "<h3>DNS Information</h3>"

#Get NTP Service
$getNTP = $esxi | Sort-Object Name | Select-Object Name, @{N = "NTP Service Running"; E = { ($_ | Get-VmHostService | Where-Object { $_.key -eq "ntpd" }).Running } }, @{N = "StartupPolicy (On = Start and Stop with Host)"; E = { ($_ | Get-VmHostService | Where-Object { $_.key -eq "ntpd" }).Policy } }, @{N = "NTP Servers"; E = { $_ | Get-VMHostNtpServer } } | sort-object -Property Name | ConvertTo-Html -Fragment -PreContent "<h3>NTP Service</h3>"

#Get Domain Membership
$getAD = Get-VMHostAuthentication -VMHost $esxi | Select VMHost, Domain, DomainMembershipStatus, @{Name = "Trusted Domains"; Expression = { $_.TrustedDomains } }  | ConvertTo-Html -Fragment -PreContent "<h3>Domain Membership</h3>"

#Get Active Directory Service 
$getADsvc = $esxi | Sort-Object Name | Select-Object Name, @{N = "Active Directory Service Running"; E = { ($_ | Get-VmHostService | Where-Object { $_.key -eq "lwsmd" }).Running } }, @{N = "StartupPolicy (On = Start and Stop with Host)"; E = { ($_ | Get-VmHostService | Where-Object { $_.key -eq "lwsmd" }).Policy } } | sort-object -Property Name | ConvertTo-Html -Fragment -PreContent "<h3> Active Directory Service</h3>"

#Get Active Directory Firewall Setting
$getadfw = $esxi | Get-VMHostFirewallException |  where { $_.Name -eq "Active Directory All" } | select VMHost, Name, Enabled, Protocols | sort-object -Property VMHost | ConvertTo-Html -Fragment -PreContent "<h3>Active Directory Firewall</h3>"

#Get Syslog Service
$getsyslogsvc = $esxi | Sort-Object Name  | Select-Object Name, @{N = "Syslog Service Running"; E = { ($_ | Get-VmHostService | Where { $_.Label -like "*syslog*" }).Running } }, @{N = "StartupPolicy (On = Start and Stop with Host)"; E = { ($_ | Get-VmHostService | Where { $_.Label -like "*syslog*" }).Policy } } | sort-object -Property Name | ConvertTo-Html -Fragment -PreContent "<h3> Syslog Service</h3>"

#Get Syslog Firewall Setting
$getsyslogfw = $esxi | Get-VMHostFirewallException | where { $_.Name -eq "syslog" } | select VMHost, Name, Enabled, Protocols | sort-object -Property VMHost | sort-object -Property VMHost | ConvertTo-Html -Fragment -PreContent "<h3>Syslog Firewall</h3>"

#Get High Performance Setting
$getPowerMgmt = Get-AdvancedSetting -Entity $esxi -Name 'Power.CPUPolicy'  | Select Entity, Name, Value | sort-object -Property Entity | ConvertTo-Html -Fragment -PreContent "<h3>Power Management</h3>"

#Get vSwitch MTU Settings
$getvmKernelMTU = $esxi | Get-VMHostNetworkAdapter | Where { $_.GetType().Name -eq "HostVMKernelVirtualNicImpl" } | Select VMHost, Name, MTU, IP, SubnetMask | sort-object VMhost, Name |  ConvertTo-Html -Fragment -PreContent "<h3>VMkernel MTU Settings</h3>"
$getvSwitchMTU = Get-VirtualSwitch -Name vSwitch0 -VMHost $esxi | Select VMHost, Name, MTU | sort-object VMhost | ConvertTo-Html -Fragment -PreContent "<h3>vSwitch MTU Settings</h3>"

#Get Core Dump Collector

$row = @()
$list = @()
$vmhosts = $esxi 
foreach ($vmhost in $vmhosts) {
    $esxcli = Get-EsxCli -VMHost $vmhost.Name 
    $row = $esxcli.system.coredump.network.get() 
    $row | Add-Member -NotePropertyName HostName -NotePropertyValue $vmhost.name 
    $list = $list + $row
}
$coredump = $list | Select Hostname, Enabled, HostVNic, NetworkServerIP, NetworkServerPort | Sort-Object Hostname | ConvertTo-Html -Fragment -PreContent "<h3>ESXi Core Dump Collector</h3>"


#Get eNIC version

$hosts = $esxi
$versions = @{}
Foreach ($vihost in $hosts) {
    $esxcli = Get-VMHost $vihost | Get-EsxCli 
    $versions.Add($vihost, ($esxcli.system.module.get("nenic") |
            Select Version))
}
$getenic = $versions.GetEnumerator() | Sort Name  |  ConvertTo-Html -Fragment -PreContent "<h3>ENIC Driver Information</h3>" 

#Get fNIC version

$hosts = $esxi
$versions = @{}
Foreach ($vihost in $hosts) {
    $esxcli = Get-VMHost $vihost | Get-EsxCli
    $versions.Add($vihost, ($esxcli.system.module.get("nfnic") |
            Select Version))
}
$getfnic = $versions.GetEnumerator() | Sort Name  |  ConvertTo-Html -Fragment -PreContent "<h3>FNIC Driver Information</h3>" 


#Get vSwitch NIC Teaming

$row = @()
$list = @()
$vmhosts = $esxi 
foreach ($hst in $vmhosts) {
    $row = $hst | Get-VirtualSwitch -Name vSwitch0 | Get-NicTeamingPolicy | Select VirtualSwitch, @{N = "Active NIC"; E = { $_.ActiveNic } }, @{N = "Standby NIC"; E = { $_.StandbyNic } }, FailbackEnabled
    $row | Add-Member -NotePropertyName HostName -NotePropertyValue $hst.name  
    $list = $list + $row
}
$getvswitchteaming1 = $list | select Hostname, VirtualSwitch, "Active NIC", "Standby NIC", FailbackEnabled | Sort-Object Hostname | ConvertTo-Html -Fragment -PreContent "<h3>vSwitch Teaming & Failover</h3>"

# Get vSwitch Mgmt & vMotion NIC Teaming
$row = @()
$list = @()
$vmhosts = $esxi 
foreach ($hst in $vmhosts) {
    $row = $hst | Get-VirtualPortGroup -Name "Management Network", "VMotion" | Get-NicTeamingPolicy | Select Hostname, VirtualPortGroup, FailbackEnabled, @{N = "Active NIC"; E = { $_.ActiveNic } }, @{N = "Standby NIC"; E = { $_.StandbyNic } }
    $row | Add-Member -NotePropertyName HostName -NotePropertyValue $hst.name -force
    $list = $list + $row
}
$getvswitchteaming2 = $list | select Hostname, VirtualPortGroup, "Active NIC", "Standby NIC", FailbackEnabled | Sort-Object Hostname | ConvertTo-Html -Fragment -PreContent "<h3>vSwitch Network Teaming & Failover</h3>"



#Get Security Policy
$getsecuritypolicy = Get-VirtualSwitch -Name vSwitch0 -VMHost $esxi | Select-Object VMHost, Name, MTU, @{N = "Security Policy AllowPromiscuous"; E = { $_.ExtensionData.Spec.Policy.Security.AllowPromiscuous } }, @{N = "Security Policy ForgedTransmits"; E = { $_.ExtensionData.Spec.Policy.Security.ForgedTransmits } }, @{N = "Security Policy MacChanges"; E = { $_.ExtensionData.Spec.Policy.Security.MacChanges } }, @{N = "LoadBalancing (Default= Route Based on Originating Port (loadbalance_srcid))"; E = { $_.ExtensionData.Spec.Policy.NicTeaming.Policy } } |  sort-object VMhost | ConvertTo-Html -Fragment -PreContent "<h3>vSwitch Security Policies</h3>"

$getdvswitch = Get-VDSwitch -Name * -VMHost $esxi | Select-Object Name, LinkDiscoveryProtocol, LinkDiscoveryProtocolOperation, Mtu, NumUplinkPorts, Version | ConvertTo-Html -Fragment -PreContent "<h3>Distributed Switch Settings</h3>"


$review = write-host "" | ConvertTo-Html -Fragment -PreContent "<h2 style=background-color:MediumSeaGreen;>ESXi Settings Check Complete</h2>"


#The command below will combine all the information gathered into a single HTML report					

#
# Get the date
#
$thedate = (Get-Date -Format "dd-MM-yyyy")

$header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;width: 90%}
TR:Hover TD {Background-Color: #C1D5F8;}
H3 {font-family: Arial, Helvetica, sans-serif;color: #000099;font-size: 16px;}
TH {border-width: 1px;padding: 10px;border-style: solid;border-color: black;background-color: #6495ED;font-size: 0.9em;text-align:left}
TD {border-width: 1px;padding: 10px;border-style: solid;border-color: black;font-size: 0.9em}
.odd  { background-color:#f2f2f2;font-size: 0.9em }
.even { background-color:#4CAF50;font-size: 0.9em }
</style>
"@

$ESXiHostName = "<h1 style=background-color:MediumSeaGreen;> VMware ESXi Settings: $vcenter ($thedate)

<h4 style=background-color:Gray;>
<p>
<details open>
  <summary>Overview</summary>
  <ol>
    <li>Scripts checks the 'current' settings in preparation for NHRR & InfoSec ESXi Host Scans</li>
    <li>Review All Settings and ensure they align with the required VMware Recommended Practices</li>
    <li><a href=https://confluence.opentext.com/display/CSDINFCOM/Documentation+-+VMware+Recommendations> Reference Confluence Page: VMware Recommended Settings</a></li> 
    <li>NOTE: The script may error in some cases for 'fnic' driver, both fnic and enic drivers should be upgraded to latest supported versions</li>
    <li><a href=https://confluence.opentext.com/pages/viewpage.action?pageId=491182393 >Reference Confluence Page: Check enic/fnic versions</a></li>
    </ol>
</details>
</p>
</h4>
</h1>"


$Report = $null
$Report = ConvertTo-HTML -body "$ESXiHostName $getVersion $alarmenabled $alarmdisabled $getenic $getfnic $getAdv $coredump $getDNS $getAD  $getADsvc $getadfw $getNTP $getsyslogsvc $getsyslogfw $getPowerMgmt $getvSwitchMTU $getvmKernelMTU $getvswitchteaming1 $getvswitchteaming2 $getsecuritypolicy $getdvswitch $review" -title "ESXi Settings Report" -PostContent $header


#The command below will generate the report to an HTML file

$Filename = "C:\temp\ESXi-Settings-Report" + "_" + $vcenter + "_" + $thedate + ".htm"
$Report | out-file -filepath $Filename
Invoke-Expression $Filename

Write-Host ""
Write-Host ""
Write-Host "HTML Report will appear soon......."  -ForegroundColor Green
Write-Host ""

Disconnect-VIServer -server * -Confirm:$false

# Report is complete











