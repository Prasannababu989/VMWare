
$ESXshelltimeoutvaluesCluster01 = Get-Advancedsetting (Get-Cluster ban-rnd-vCD-Cluster01 | Get-VMHost) -Name "UserVars.ESXiShellTimeOut" | Select-Object Value
$ESXshelltimeoutvaluesCluster01.Count
$ESXshelltimeoutvaluesCluster01.Value

if ($ESXshelltimeoutvaluesCluster01.Value -ne "900") {
    Write-Host "ESXi Host not set to 900. It is set to" $ESXshelltimeoutvaluesCluster01.Value
}
    {Set-VMHostAdvancedConfiguration (Get-VMHost ban-esx02-l012.otxlab.net) -Name "UserVars.ESXiShellTimeOut" -Value "0"}
 #{Write-Host "Sucess" -ForegroundColor DarkGreen}

    else
{write-host "Failed or Value is not 900" -ForegroundColor Red}



$clusterinfo = Get-Cluster ban-rnd-vCD-Cluster01 
$clusterinfo.Name
$clusterinfo.DrsAutomationLevel
$clusterinfo.ExtensionData.Host

Get-Cluster ban-rnd-vCD-Cluster01 | Get-VMHost | Select-Object Name,Manufacturer


#Connect VC
$VC = Connect-VIServer ban-vcs02-l001.otxlab.net -User pvasanth.lab -Password Welcome032021

# Gather our hosts
$hosts = Get-VMHost
$Cluster= Get-Cluster ban-rnd-vCD-Cluster01

# Modify Advancedsetting
ForEach ($vmhost in $hosts) {
    $value = Get-Advancedsetting (Get-VMHost) -Name "UserVars.ESXiShellTimeOut" | Select Entity,Name,Value
        if ($value.value -eq "900")
          {Set-VMHostAdvancedConfiguration (Get-VMHost) -Name "UserVars.ESXiShellTimeOut" -Value "0"}
    #{Write-Host "Success" -ForegroundColor DarkGreen}
          else
          {write-host "Failed or Value is not 900" -ForegroundColor Red}
}

