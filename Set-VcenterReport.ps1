<#PSScriptInfo

.VERSION 1.0

.GUID deca4522-edbf-4e0b-ae99-be6530cdf220

.AUTHOR jdavid@opentext.com

.COMPANYNAME opentext

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Setup Data Collector script as PSJob

#>
param(
    [string]
    [Parameter(Mandatory=$true)]
    $Path
)

#region Setup
If (Test-Path -Path $Path) {
    $Server = Get-Content -Path $Path
    $Date = Get-Date -Hour 0 -Minute 0 -Second 0
    $NextSunday = $Date.AddDays(7-$Date.DayOfWeek)
    $Option     = New-ScheduledJobOption -RunElevated
    $ScriptPath = "$PSScriptRoot\comp-auto-vcenter-report.ps1"
}
else {
    Throw "Path not found '$Path'"
}
#endregion

#region VIServer loop
foreach ($item in $Server) {

    $Trigger    = New-JobTrigger -Weekly -At $NextSunday -DaysOfWeek Sunday
    $Parameter = @{
        Trigger            = $Trigger
        ScheduledJobOption = $Option
        FilePath           = $ScriptPath
        ArgumentList       = @($item,$PSScriptRoot)
        Credential         = Get-StoredCredential -Target 'CollectionUserAccount'
        Name               = "$item"
    }

    $Job = Get-ScheduledJob -Name "$Item" -ErrorAction SilentlyContinue

    if ($null -ne $Job) {
        Write-Warning -Message "Job '$Item' Already exists"
    }
    else {
        Register-ScheduledJob @Parameter -verbose
    }

    $NextSunday = $NextSunday + "00:15"
}
#endregion



