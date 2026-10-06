function Get-AuthenticationActivity{

$Events = Import-Csv -Path "C:\Users\hyped\OneDrive\Documents\Dummy_Authentication_Failure_Logs.csv"

# $event = Get-WinEvent -FilterHashtable @{ LogName = "Security"; Id = 4625; StartTime="$RemoteStartTime"; EndTime="$RemoteEndTime" }
# foreach ($e in $Events){


# [PSCustomObject]@{
#     Computer = $e.Computer
#     SourceIP = $e.SourceIP
#     UserName = $e.UserName
#     FailureCount = ''
#     UniqueUsers = ''
#     Detection = ''
#     Severity = ''
# }



 



# }

# $SourceIP = $Events | Group-Object SourceIP


# [PSCustomObject]@{
#     Computer = $Events.Computer
#     StartTime = $Events.Time
#     EndTime = $Events.Time
#     TotalFailures = ($Events | Select-Object *).Count
#     UniqueIPs = ($Events.SourceIP | Sort-object -Unique).Count
#     UniqueUsers = ($Events.UserName | Sort-Object -Unique).Count

# }


$Events | Group-Object TargetUser | Select-Object @{Name='Username'; Expression={$PSItem.Name}}, @{Name='FailureCount'; Expression={$PSItem.Count}}
$Events | Group-Object SourceIP | Select-Object @{Name='SourceIP'; Expression={$PSItem.Name}}, @{Name='Count'; Expression={$PSItem.Count}} | Format-Table



$Events | Group-Object SourceIP | ForEach-Object { $PSItem | Select-Object @{Name='SourceIP';Expression={$PSItem.Name}}, @{Name='FailureCount';Expression={$PSItem.Count}}, @{Name='UniqueUsers';Expression={($PSItem.Group | Select-Object -ExpandProperty TargetUser | Sort-Object -Unique).Count}} | ForEach-Object {
    $e = $_
    if ($e.FailureCount -lt 5) {
        $e | Add-Member -MemberType NoteProperty -Name 'Severity' -Value 'NORMAL'
    } elseif ($e.FailureCount -ge 5 -and $e.FailureCount -lt 10) {
        $e | Add-Member -MemberType NoteProperty -Name 'Severity' -Value 'LOW'
    } elseif ($e.FailureCount -ge 10 -and $e.FailureCount -lt 25) {
        $e | Add-Member -MemberType NoteProperty -Name 'Severity' -Value 'MEDIUM'
    } elseif ($e.FailureCount -ge 25) {
        $e | Add-Member -MemberType NoteProperty -Name 'Severity' -Value 'HIGH'
    }
    $e | Select-Object SourceIP, FailureCount, UniqueUsers, Severity

} 
}





$Events | Group-Object SourceIP | Where-Object {$PSItem.Count -gt 25 } | Select-Object @{Name='SourceIP'; Expression={$PSItem.SourceIP | Select-Object -Unique}}, @{Name='UserName'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object TargetUser | Select-Object  }}, @{Name='Failure Count'; Expression={$PSItem.Count}}, @{Name='Message'; Expression={'Potential BruteForce Attack'}} | Sort-Object -Unique | Format-Table

# $Events | Group-Object SourceIP |  Where-Object {($PSItem.TargetUser).Count -gt 3} | Select-Object @{Name='SourceIP'; Expression={$PSItem.SourceIP}}, @{Name='UserName'; Expression={$PSItem.TargetUser}}, @{Name='Message'; Expression={'Potential Password Spraying Attack'}} | Sort-Object -Unique
    
# $Events | Group-Object SourceIP | Select-Object Name | Out-File -FilePath '.\listofuniqueip.txt'


$IPS = Get-Content -Path '.\listofuniqueip.txt'
$SourceIP_TargetUser = $Events | Group-Object SourceIP, TargetUser 

$CountList = [hashtable]@{}
foreach ($IP in $IPS){
    
    $ContainsIP =  $SourceIP_TargetUser.Name | Where-Object {$PSItem -match "$IP"}
    if($ContainsIP){
        $CountList.Add("$IP", $ContainsIP.Count) 

    }
    
   
}
$CountList | Select-Object *  |  ForEach-Object {Write-Host "$PSItem.Keys"}
# $CountList | Select-Object @{Name='IP'; Expression={$PSItem.Keys}}, @{Name="Count"; Expression={$PSItem.Values}} |  Format-Table -OutVariable $CountList1
# $CountList1

}

Get-AuthenticationActivity
<#
if($e.Count -lt 5){
    $e.Severity = 'NORMAL'
    }
ifelse($e.Count -gt 5 -and $e.Count -lt 10){

    $e.Severity = 'LOW'
    }
ifelse($e.Count -gt 11 -and $e.Count -lt 25){
    $e.Severity = 'MEDIUM'
    }
ifelse($e.Count -gt 25){
    $e.Severity = 'HIGH'
    }
else(){

}


Get-AuthenticationActivity -ComputerName "10.149.203.67" -StartTime (Get-Date).AddHours(-24) -EndTime (Get-Date)
 
 #>
