#PowerShell Console Basics
ipconfig
dir
$PSVersionTable
$PSVersionTable | Get-Member
dir | get-Member
cls

#Basic Datatype
1 + 2
$a = 1+2
$a | get-Member
$a
$a +=1
$a
$a = "This is a string"
$a | get-member
$a.length
$a.substring(0,5)
$b = 'Tom'
$a = "My name is $b"
$a
$a = 'My name is $b'
$a
clear host

#Comparision Operators
12 -eq 37
12 -eq -12
$a = 12
$b - 37
$a -eq $b
$a -ne $b
$a -ne 12
$a -gt 5
$a -lt 5
$a -lt 12
$a -eq 12
$a = "a"
$b = "b"
$a -ne $b
$a -eq $b
$a -lt $b
"a" -eq "A"
"a" -ceq "a"
"Apple" -eq "A*"
"Apple" -like "A*"
"Apple" -like "P*"
"Apple" -like "*P*"
"Apple" -like "A??le"
"Ankle" -like "A??le"
"Admirable" -like "A??le"
"My Name is Tom" -match "Tom"
"My Name is Tom" -match "bob"
"My Name is Tom" -cmatch "TOM"


