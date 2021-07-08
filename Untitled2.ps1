
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


















# Output NFS settings
$result = @()
ForEach ($vmhost in $hosts) {
    $nfsget = $esxcli.system.settings.advanced.list.CreateArgs()
    $nfsget.option = "/SunRPC/MaxConnPerIP"
    $nfsupdate = $esxcli.system.settings.advanced.list.Invoke($nfsget)

    $result += [PSCustomObject] @{
        Hostname = $vmhost
        Path = "$($nfsupdate | Select -ExpandProperty Path)" 
        IntValue = "$($nfsupdate | select -ExpandProperty IntValue)"
        Description = "$($nfsupdate | Select -ExpandProperty Description)"
    }
        
$result | Out-File -FilePath "$outputdir\NFSMaxConnPost_$clsname-$date.txt"
}