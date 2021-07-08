Clear-Host
#**************************************************************
$labcreds = Get-Credential
#****************************************************************

#Connect to VCenter
Connect-VIServer lsvchyd03.lab.opentext.com -Credential $labcreds
disconnect-VIServer lsvchyd03.lab.opentext.com
#*****************************************************************
##Variables for Hyderatbad VCenter lsvchyd03.lab.opentext.com
get-vmhost|Select-Object name,
Get-vmhost lsesxhyd88.lab.opentext.com | Get-Cluster

$ESXHydCluster = Get-Advancedsetting (Get-Cluster ResourceCluster3-HYD | Get-VMHost) -Name "UserVars.ESXiShellTimeOut" | Select-Object Value
$ESXHydCluster.Count
$ESXHydCluster.Value
#****************************************************************

if ($ESXHydCluster.Value -ne "900") 
{
  Write-Host "ESXi Host not set to 900. It is set to" $ESXhYDCluster.Value
   # { Set-VMHostAdvancedConfiguration (Get-VMHost lsesxhyd88.lab.opentext.com) -Name "UserVars.ESXiShellTimeOut" -Value "0" }
  Write-Host "Success" -ForegroundColor DarkGreen
 }
   else   { 
 write-host "Failed or Value is not 900" -ForegroundColor Red }

 
if ($ESXHydCluster.Value -ne "900") 
{
  Write-Host "ESXi Host not set to 900. It is set to" $ESXhYDCluster.Value

  Write-Host "Success" -ForegroundColor DarkGreen
 }
   else   { 
 write-host "Failed or Value is not 900" -ForegroundColor Red }
}  }


$ESXShell=Get-cluster ResourceCluster5-HYD |Get-VMHost|Get-AdvancedSetting -Name "UserVars.ESXiShellTimeOut"
Foreach ($value in $ESXShell){
$Value | Where-Object {$_.Value -eq "0"}
Write-Host "Value is 0"-ForegroundColor Yellow
} 

If ($ESXShell.value -eq "9000"){
Write host ("This is right value")
}else{
write host ("This is not right ") 
}

Get-VMhost lsesxhyd44.lab.opentext.com | Select-Object ExtensionData 
(Get-VMhost -Name lsesxhyd44.lab.opentext.com).ExtensionDatat

Get-VMHost|Select-Object Name, Version, Build


$Host1 = Get-VMHost|Select-Object Name, Version, Build, MaxEVCMode, HyperthreadingActive, NumCpu, MemoryTotalGB, Model, ProcessorType, @{N = 'Serial Number'; E = { (Get-EsxCli -VMHost $_).hardware.platform.get().SerialNumber } } | Sort-Object Name | ConvertTo-Html -Fragment -PreContent "<h3>ESXi Version/Build</h3>"

$Host1| Where-Object {$_.ExtensionData.AlarmActionEnabled -eq "true"}|select name

Get-VMHost|Select-Object Name, Version, Build | Where-Object { $_.extensiondata.AlarmActionsEnabled -eq $true }


Write-Host "Alaram Disabled"



Select-Object Name, Version, Build, MaxEVCMode, HyperthreadingActive, NumCpu, MemoryTotalGB, Model, ProcessorType, @{N = 'Serial Number'; E = { (Get-EsxCli -VMHost $_).hardware.platform.get().SerialNumber } } | Sort-Object Name | ConvertTo-Html -Fragment -PreContent "<h3>ESXi Version/Build</h3>"


