#Get DNS information for all Hosts host 
Get-DnsClient

Get-VMHost | Select Name, @{N='DNS Server(s)';E={$_.Extensiondata.Config.Network.DnsConfig.Address -join ' , '}} 


Get-VMHost | Get-VMHostNetwork | Select Hostname, ConsoleGateway, DNSAddress -ExpandProperty ConsoleNic | Select Hostname, PortGroupName, IP, SubnetMask, ConsoleGateway, DNSAddress, Devicename

Get-VMHost | Get-VMHostNetwork | Select HostName, DnsAddress

#Environment
Connect-VIServer ban-vcs02-l001.otxlab.net -User pvasanth.lab -Password Welcome032021
$Cluster = "ban-rnd-vCD-Cluster01"
$ESXHosts = Get-Cluster $Cluster | Get-VMHost

#Get DNS information for all Hosts host 

#Option : 1

ForEach ($ESXHost in $ESXHosts){
 
Get-VMHost | Get-VMHostNetwork | Select HostName, DnsAddress 
}

#Option : 2

Get-VMHost | Select Name, @{N='Prasanna';E={$_.Extensiondata.Config.Network.DnsConfig.Address}}  

