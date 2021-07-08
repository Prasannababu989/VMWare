<#
    .SYNOPSIS

     Connects to a vcenter and calls the DataCollects.

    .DESCRIPTION
    Script to manage running the scripts that collect a simple ESXi inventory by connecting to a vcenter server using CredentialManager stored credentials

    .PARAMETER  Server
    VMware vcenter name to run the collector scripts

    .PARAMETER  Path
    default path for script

    .OUTPUTS
     This function does not provide output.

     .EXAMPLE
    PS>.\comp-auto-vcenter-resport.ps1 'li3-vcs-p001.idldap.net'
    This will connect to the vCenter li3-vcs-p001.idldap.net and run all the scripts in the <PATH>\DataCollectors\*.ps1
#>

param (
	[Parameter(Mandatory=$true)]
    [string]
    $Server,
	[Parameter()]
	[string]
	$Path = $PSScriptRoot
)
#region Setup
$DataCollectorsPath = [IO.Path]::Combine($Path,'DataCollectors','*')
$ScriptPath = Get-ChildItem -Path $DataCollectorsPath -Include '*.ps1' -ErrorAction SilentlyContinue
if ($ScriptPath.count -eq 0) {
	Throw "Cannot find ps1 script in Path '$DataCollectorsPath'"
}
$null = Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
$Cred = Get-StoredCredential -Target 'CollectionUserAccount'
$null = Connect-viserver -Server $Server -Credential $Cred
#endregion

#region Run all the Data Collector scripts
foreach ($Script in $ScriptPath) {
  & $Script.FullName -Verbose
}
#endregion

$null = Disconnect-VIServer -Server $Server -Confirm:$False