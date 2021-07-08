# to list out VMs in VC with Power State and only with windows OS.

Clear-Host

Connect-VIServer lsvchyd03.lab.opentext.com

$VM=Get-VM
$VM | Where-Object {$_.PowerState -eq "Poweredoff"}
$VM -name winSrvTS-NqNM | select Name, Powerstate, Guest

#Getting list from Txt file
$TestHosts = Get-Content C:\Users\pvasanth\Desktop\LoopTest.txt
foreach($testhost in $TestHosts)
{
Get-VMHost $testhost | Get-AdvancedSetting -name UserVars.ESXiShellTimeOut
}


# Getting VMs with OS
Get-VM |  Where-Object {$_.PowerState -eq "Poweredoff"} | select Name, Powerstate, Guest

Get-VM | Format-Wide

#Loop

$outputvms=@()
$VMs=get-vm
foreach($VM in $VMs)
    {
        $outputvms += get-vm $VM | Where-Object {$_.PowerState -eq "PoweredOff"} | select Name, Powerstate, Guest
    }
$outputvms | Export-Csv C:\Users\pvasanth\Desktop\outputvms.csv
C:\Users\pvasanth\Desktop\outputvms.csv

 

# UserVars.ESXiShellTimeOut

$Output=@()
$ESXHosts = Get-VMHost
foreach($ESXHost in $ESXHosts)
    {
$output += Get-VMHost $ESXHost | Get-AdvancedSetting -name UserVars.ESXiShellTimeOut
     } 
     $output | Export-Csv C:\users\pvasanth\Desktop\prasanna.csv

#Advanced Settings
Get-VMHost lsesxhyd209.lab.opentext.com | Get-AdvancedSetting -name UserVars.ESXiShellTimeOut












#LOOP - For, Foreach
$Vars = "prasanna, Sachin, Prasanna2, Sachin2"
Foreach ($Var in $Vars)
{
Write-host $Var
}



 



$VMHosts | where PowerState -EQ "poweredoff"


$VMHosts | get-member

$VMHosts | Get-VM winSrvTS-NqNM | Get-Member

$VMHosts | where-Object {$_.Name -eq "winSrvTS-NqNM"} | select Guest


$VMHosts.name, $VMHosts.PowerState


foreach ($vmhosts in $vmhosts) {
    Where-Object {$_.PowerState -eq "Poweredoff"}
        write host "These are PoweredOff"
    }






$vmhosts = $esxi 
foreach ($vmhost in $vmhosts) {
    $esxcli = Get-EsxCli -VMHost $vmhost.Name 
    $row = $esxcli.system.coredump.network.get() 
    $row | Add-Member -NotePropertyName HostName -NotePropertyValue $vmhost.name 
    $list = $list + $row
}




