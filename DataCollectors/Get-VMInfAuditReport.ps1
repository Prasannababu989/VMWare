<#
    This script collects infrastructure details for all VMs in a given vCenter.
#>
[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $SendTo = 'Compute Assets - Shared Infrastructure Operations - Asset Reporting <9ef623b8.opentextcorporation.onmicrosoft.com@amer.teams.ms>',
    [switch]
    $OutObject,
    [String]
    $SmtpServer
    )

function Get-VMInfAuditReport
{
    function Get-FirstItem
    {
        [CmdletBinding()]
        param(
            [object]$Object
        )
        if($Object.count -gt 1)
        {return $Object[0]}
        else{return $Object[0]}
    }
    
    $vms = Get-VM
    $ReturnedObjects  = @()
    Foreach($vm in $vms)
    {
        Write-Verbose "Processing VM: $($vm.name)"
        $properties = [PSCustomObject][ordered]@{
                        'VM NAME'           = $vm.name
                        'VM IP Address'     = ($vm.ExtensionData.Summary.Guest.IPAddress) -join ', '
                        'VM Host'           = $vm.vmhost
                        'VM OS'             = $vm.ExtensionData.Config.GuestFullName
                        'VM CPU'            = $vm.NumCpu
                        'VM Memory GB'      = $vm.MemoryGB
                        'VM Business Unit'  = ''
                        'VM Support Group'  = ''
                        'ESXi Host Name'    = $vm.VMhost.Name
                        'ESXi Host IP'      = (Get-VMHOST  $vm.VMhost | Get-VMHostNetworkAdapter -VMKernel | Where-Object{$_.ManagementTrafficEnabled}).IP
                        'Host Cluster'      = $vm.VMhost | Get-Cluster | Select-Object -ExpandProperty Name
                        'Host vCenter'      = $vm.ExtensionData.Client.ServiceUrl.Split('/')[2]
                        'Host CPU Core'     = $vm.VMHost.NumCpu
                        'Host Memory GB'    = $vm.VMHost.MemoryTotalGB
                        'Hardware Model'    = "$($vm.VMHost.Manufacturer) / $($vm.VMHost.Model)"
                        'Software Version'  = "$($vm.VMHost.Version) / $($vm.VMHost.Build)"
                        }
        $ReturnedObjects +=  $properties
    }
    return $ReturnedObjects
}

If(!$OutObject)
{
    #Process and send the data to the destination
    $tmppath = [System.IO.Path]::GetTempPath()
    #region Setup
    $SendFrom = "$ENV:COMPUTERNAME-vminfraudit@opentext.com"
    $Subject = "{0}-{1}" -f "VMInfraAudit",$global:DefaultVIServer
    $Attachement = [IO.Path]::Combine("$tmppath","$Subject.csv")
    remove-item -Path $Attachement -Force -ErrorAction SilentlyContinue
    #endregion

    #region Data Collected to a file
    #add the custom datacollection here and format the data as required
    Write-Verbose "Export path: $Attachment"
    Get-VMInfAuditReport | Export-Csv -NoTypeInformation -Path $Attachement
    #endregion

    #region Email the file uising the vcenter SMTP Server
    if(-not $SmtpServer)
    {
        $vCenterSettings = Get-View -Id 'OptionManager-VpxSettings'
        $MailSmtpServer = ($vCenterSettings.Setting | Where-Object { $_.Key -eq "mail.smtp.server"}).Value
    }
    else {
        $mailsmtpserver = $SmtpServer
    }
    Write-Verbose "Sending Mail: SMTP = $mailsmtpserver Sending to: $sendto"
    
    Send-MailMessage -SmtpServer $MailSmtpServer -From $SendFrom -To $SendTo -Subject $Subject -Attachments $Attachement
    #endregoin

}
else
{
    #Output an object
    Get-VMInfAuditReport
}