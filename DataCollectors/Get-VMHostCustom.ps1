[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $SendTo = '483da62e.opentextcorporation.onmicrosoft.com@amer.teams.ms'
)

function Invoke-Method {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [Object[]]
        $InputObject,
        
        [Parameter(Mandatory = $true)]
        [string]
        $MethodName,
        
        [Parameter()]
        [String[]]
        $MethodParameters = $null,
        
        [Parameter()]
        [switch]
        $Static = $false
    )
    process {
        if ($null -ne $MethodParameters -and $null -ne $InputObject) {
            if ($Static) {
                foreach ($object in $InputObject) {
                    $object::$MethodName.Invoke($MethodParameters)
                }
            }
            else {
                foreach ($object in $InputObject) {
                    $object.$MethodName.Invoke($MethodParameters)
                }
            }
        }
        elseif ($null -ne $InputObject) {
            if ($Static) {
                foreach ($object in $InputObject) {
                    $object::$MethodName.Invoke()
                }
            }
            else {
                foreach ($object in $InputObject) {
                    $object.$MethodName.Invoke()
                }
            }
        }
    }    
}
function Get-VMHostCustom {
    $VMHostView = Get-View -ViewType Hostsystem -Property Name,Hardware,Config,ConfigManager,Parent -ErrorAction Stop
            
    foreach ($VMHost in $VMHostView) {
        try {
            Write-Verbose -Message "Retrieving the view data for VMHost object 'ConfigManager.NetworkSystem' and Invoke-Method 'QueryNetworkHint' for 'vmnic0'."
    
            #region get the cluster or folder the host is under
            if ($VMHost.Parent.Type -eq 'ClusterComputeResource') {
                $Cluster = Get-View -id $VMHost.Parent -ErrorAction SilentlyContinue
            }
            elseif ($VMHost.Parent.Type =eq 'ComputeResource') {
                $Cluster = Get-View -id (Get-View -id $VMHost.Parent -ErrorAction SilentlyContinue).Parent -ErrorAction SilentlyContinue
            }
            else {
                $Cluster = $null
            }
            #endregion
    
            $PNicCDP = Get-View -Id $VMHost.ConfigManager.NetworkSystem -ErrorAction SilentlyContinue | Invoke-Method -MethodName 'QueryNetworkHint' -MethodParameters 'vmnic0'
            if ($null -eq $PNicCDP) {
                Throw "No CDP Data on $($VMHost.Name)"
            }
            $properties = @{
                'VMHost'            = $VMHost.Name
                'Vendor'            = $VMHost.Hardware.SystemInfo.Vendor
                'Model'             = $VMHost.Hardware.SystemInfo.Model
                'BIOS version'      = $VMHost.Hardware.BiosInfo.BiosVersion
                'CPU Model'         = $VMHost.Hardware.CpuPkg[0].Description
                'ESXi Version'      = $VMHost.Config.Product.Version
                'ESXi Build'        = $VMHost.Config.Product.Build
                'VIServer'          = $global:DefaultVIServer.Name
                'VIServerVersion'   = $global:DefaultVIServer.Version
                'VIServerBuild'     = $global:DefaultVIServer.Build
                'Cluster'           = $Cluster.Name
                'ESXi IP'           = ($VMHost.Config.Network.vnic | Where-Object -FilterScript {$_.Portgroup -eq 'Management Network'} ).spec.ip.ipaddress  #(Get-VMHostNetworkAdapter -VMHost $VMHost.name  | Where-Object {$_.Name -eq "vmk0"}).IP
                'DevId'             = $PNicCDP.ConnectedSwitchPort.DevId
                'SoftwareVersion'   = $PNicCDP.ConnectedSwitchPort.SoftwareVersion
                'HardwarePlatform'  = $PNicCDP.ConnectedSwitchPort.HardwarePlatform
                'SystemName'        = $PNicCDP.ConnectedSwitchPort.SystemName
                'SystemOID'         = $PNicCDP.ConnectedSwitchPort.SystemOID
            }
        }
        catch {
            $properties = @{
                'VMHost'            = $VMHost.Name
                'Vendor'            = $VMHost.Hardware.SystemInfo.Vendor
                'Model'             = $VMHost.Hardware.SystemInfo.Model
                'BIOS version'      = $VMHost.Hardware.BiosInfo.BiosVersion
                'CPU Model'         = $VMHost.Hardware.CpuPkg[0].Description
                'ESXi Version'      = $VMHost.Config.Product.Version
                'ESXi Build'        = $VMHost.Config.Product.Build
                'VIServer'          = $global:DefaultVIServer.Name
                'VIServerVersion'   = $global:DefaultVIServer.Version
                'VIServerBuild'     = $global:DefaultVIServer.Build
                'Cluster'           = $Cluster.Name
                'ESXi IP'           = ($VMHost.Config.Network.vnic | Where-Object -FilterScript {$_.Portgroup -eq 'Management Network'} ).spec.ip.ipaddress  #(Get-VMHostNetworkAdapter -VMHost $VMHost.name  | Where-Object {$_.Name -eq "vmk0"}).IP
                'DevId'             = '(NOT FOUND)'
                'SoftwareVersion'   = '(NOT FOUND)'
                'HardwarePlatform'  = '(NOT FOUND)'
                'SystemName'        = '(NOT FOUND)'
                'SystemOID'         = '(NOT FOUND)'
            }                                            
        }
        finally {
            New-Object -TypeName PSCustomObject -Property $properties
        }
    }
}

#region we assume that there is a connection to a vcenter"
if ($null -eq $global:DefaultVIServer) {
    Throw "Not connected to a VMWare Server"
}
#endregion

#region Setup
$tmppath = [System.IO.Path]::GetTempPath()
$SendFrom = "$ENV:COMPUTERNAME@opentext.com"
$Subject = "{0}-{1}" -f ($MyInvocation.MyCommand.Name -replace '.ps1',''),$global:DefaultVIServer
$Attachement = [IO.Path]::Combine("$tmppath","$Subject.json")
remove-item -Path $Attachement -Force -ErrorAction SilentlyContinue
#endregion

#region Data Collected to a file
#add the custom datacollection here and format the data as required
Get-VMHostCustom | ConvertTo-Json | Out-File -FilePath $Attachement
#endregion

#region Email the file uising the vcenter SMTP Server
$vCenterSettings = Get-View -Id 'OptionManager-VpxSettings'
$MailSmtpServer = ($vCenterSettings.Setting | Where-Object { $_.Key -eq "mail.smtp.server"}).Value
Send-MailMessage -SmtpServer $MailSmtpServer -From $SendFrom -To $SendTo -Subject $Subject -Attachments $Attachement
#endregoin