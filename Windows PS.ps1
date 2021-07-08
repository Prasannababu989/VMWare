New-Item -Path 'C:\temp\PowerShell Test' -ItemType Directory
New-Item -Path 'C:\temp\Powershell Test\TestFile1.doc' -ItemType File
Copy-Item -Path 'C:\temp\Powershell Test' 'C:\temp\Powershell Practice'
Copy-Item -Path 'C:\temp\PowerShell Test\TestFile1.doc' 'C:\temp\Powershell Practice\PracticeFile.doc'
Remove-Item -Path 'C:\temp\PowerShell Test'
Remove-Item -Path 'C:\temp\PowerShell Test' -Recurse
Move-Item 'C:\temp\Learn' 'C:\Learn'
Rename-Item 'C:\Learn' 'C:\Learn PowerShell'
Move-Item 'C:\Learn PowerShell' 'C:\temp'
Rename-Item 'C:\temp\Learn PowerShell\PracticeFile.doc' 'C:\temp\Learn PowerShell\PowerShell.doc'
New-Item -Path 'C:\temp\Learn PowerShell\PS.txt' -ItemType File
Get-Content 'C:\temp\Learn PowerShell\PS.txt'
(Get-Content 'C:\temp\Learn PowerShell\PS.txt').length
Test-Path C:\temp\PowerShell
Test-Path C:\temp\PowerShellTest
Test-Path C:\temp\PowerShell\PS.txt
Test-Path 'C:\temp\Learn PowerShell\PS.txt'
Get-Date
New-Item -Path C:\temp\PowerShell\test.txt
Set-Content C:\temp\PowerShell\test.txt 'Welcome2021'
Get-Content C:\temp\PowerShell\test.txt
New-Item 'C:\temp\PowerShell\test.xml' -ItemType File
Set-Content C:\temp\PowerShell\test.xml '<title>Welcome to XML</title>'
Get-Content C:\temp\PowerShell\test.xml
New-Item 'C:\temp\PowerShell\test.csv' -ItemType File
Set-Content C:\temp\PowerShell\test.csv 'Welcome to CSV'
Get-Content C:\temp\PowerShell\test.csv
New-Item -Path C:\temp\PowerShell\test.html -ItemType File
Set-Content C:\temp\PowerShell\test.html '<html>Welcome to HTML</html>'
Get-Content C:\temp\PowerShell\test.html
Clear-Content C:\temp\PowerShell\test.html
Add-Content C:\temp\PowerShell\test.html 'Welcome 2021'


Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
Get-ControlPanelItem "windows Defender Firewall"|select Name,Description
Get-ComputerInfo
Get-help

#Loop

For($str='' ;$str.length -le 20;$str=$str+'ab'){
    $str
}

For($i=1;$i -le 5;$i++){
    For($j=1;$j -le $i; $j++){
        Write-Host "*$" -NoNewline
    }
    Write-Host ""
}

$i=1
While ($true){
    $i
    $i++
    if ($i -gt 20) {
        Break
    }
}










