[CmdletBinding()]
param(
    [string]
    $WebUrl = "https://opentextcorporation.sharepoint.com/teams/ComputeAssetInventory",
    
    [string]
    $SitePath = "Shared Documents\General\EMail Messages",
    
    [string]
    $Destination = "C:\\Temp",

    [string]
    $Type = '*.json',

    [switch]
    $Remove
)

$Cred = Get-StoredCredential -Target 'CollectionUserAccount'
$null = Connect-PnPOnline -Url $WebUrl -Credentials $Cred

$Folder = Get-PnPFolder -Url $SitePath

if (-not (Test-Path -Path $Destination)) {
    $null = New-Item $Destination -Type Directory
}

foreach ($File in $Folder.Files) {

    if ( $File.Name -like $Type) {
        Get-PnPFile -ServerRelativeUrl $file.ServerRelativeUrl -Path $Destination -FileName $File.Name -AsFile
    }

    if ($Remove) {
        Remove-PnPFile -ServerRelativeUrl $file.ServerRelativeUrl -Force
    }
}

$null = Disconnect-PnPOnline
