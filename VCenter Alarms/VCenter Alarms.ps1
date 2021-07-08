<# Set SendSNMP on given Alarms

    $alarmlist = import-csv "C:\Users\scash.adm\Desktop\alarms.csv" 
    foreach ($alarm in $alarmlist)
    {
        Write-Host "Line: " $alarm
        # CREATE NEW ALARM ACTIONS   
            # Ensure the above "Delete all previous Actions" is Commented out - else you will wipe/delete previously set Actions on the Same alarm 

            if ($alarm.CoreSystemsAction -eq "SendSNMP")
            {
                Write-Host "SendSNMP Action:" $alarm.alarmName, $alarm.CoreSystemsAction

                # Create a new SendSNMP Action on the Alarm
                    Get-AlarmDefinition -Name $alarm.AlarmName | New-AlarmAction -Snmp
                    Get-AlarmDefinition -Name $alarm.AlarmName | Get-AlarmAction -ActionType SendSNMP | New-AlarmActionTrigger -StartStatus Green -EndStatus Yellow
                    # This is the default New-AlarmActionTriger which gets created via the New-AlarmAction line above - if this stays in you get an Error - as the Action already exists
                    # Get-AlarmDefinition -Name $alarm.AlarmName | Get-AlarmAction -ActionType SendSNMP | New-AlarmActionTrigger -StartStatus Yellow -EndStatus Red
                    Get-AlarmDefinition -Name $alarm.AlarmName | Get-AlarmAction -ActionType SendSNMP | New-AlarmActionTrigger -StartStatus Red -EndStatus Yellow
                    Get-AlarmDefinition -Name $alarm.AlarmName | Get-AlarmAction -ActionType SendSNMP | New-AlarmActionTrigger -StartStatus Yellow -EndStatus Green
            }

    }

#>



<# Set SendEMAIL on Alarms
Clear-Host
     
    $alarmlist = import-csv "C:\Users\scash.adm\Desktop\alarms.csv" 
    foreach ($alarm in $alarmlist)
    {
        Write-Host "Line: " $alarm

        if ($alarm.CoreSystemsAction -eq "SendEmail")
        {
            Write-Host "SendEmail Action:" $alarm.alarmName, $alarm.CoreSystemsAction
        
            $vCenter=”am2-vcs-p005”
            $emailTo="Systems_DPZ_Admins@opentext.com"
            $SubjectAlarm=$alarm.AlarmName
               $FullSubject = "vCenter: $vCenter - Alarm: $SubjectAlarm" 

            # Creates the Yellow to Red - Warning to Critical Trigger Action
                   Get-AlarmDefinition -Name $alarm.AlarmName | New-AlarmAction -Email -To $emailTo -Subject $FullSubject
            # Creates the Green to Yellow - Normal to Warning Trigger Action
                   Get-AlarmDefinition -Name $alarm.AlarmName | Get-AlarmAction -ActionType SendEmail | New-AlarmActionTrigger -StartStatus Green -EndStatus Yellow
            # Creates the Red to Yellow - Critical to Warning Trigger Action
                   Get-AlarmDefinition -Name $alarm.AlarmName | Get-AlarmAction -ActionType SendEmail | New-AlarmActionTrigger -StartStatus Red -EndStatus Yellow
        }   
      }

#>
