# Gather our hosts
$hosts = Get-VMHost

# Modify NFS Settings
ForEach ($vmhost in $hosts) {
    $esxcli = Get-EsxCli -VMHost $vmhost -V2
    $nfsargs = $esxcli.system.settings.advanced.set.CreateArgs()
    $nfsargs.option = "/SunRPC/MaxConnPerIP"
    $nfsargs.intvalue = "32"
    $esxcli.system.settings.advanced.set.Invoke($nfsargs)
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