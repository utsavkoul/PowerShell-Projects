function Get-AuthenticationActivity{
<#
param(
 [Parameter(Mandatory = $true)]
[string]$ComputerName,
 [Parameter(Mandatory = $true)]
[datetime]$StartTime,
 [Parameter(Mandatory = $true)]
[datetime]$EndTime
)
#>

$Events = Import-Csv -Path 'C:\Users\Acer\Downloads\Dummy_Authentication_Failure_Logs.csv'
$Events
<#
$EventList = [System.Collections.ArrayList]@()
$Eventinfo = [System.Collections.ArrayList]@()#>
<# Invoke-Command -ComputerName $ComputerName  -ArgumentList $StartTime,$EndTime -ScriptBlock{
param(
 [Parameter(Mandatory = $true)]
[datetime]$RemoteStartTime,
 [Parameter(Mandatory = $true)]
[datetime]$RemoteEndTime
)
#>
# $event = Get-WinEvent -FilterHashtable @{ LogName = "Security"; Id = 4625; StartTime="$RemoteStartTime"; EndTime="$RemoteEndTime" }
foreach ($e in $Events){
<#
$xml = [xml]$e.ToXml()
$system = $xml.Event.System
$eventdata = $xml.Event.EventData.data 
#>
<#
[PSCustomObject]@{

Time = $e.Time
EventID = $e.EventID
Computer = $e.Computer
SubjectUser = $e.SubjectUser
SubjectSID = $e.SubjectSID
UserName = $e.Name
SubjectDomain = $e.where({$PSItem.Name -eq 'SubjectDomainName'}).'#text'

SubjectLogonId = $e.where({$PSItem.Name -eq 'SubjectLogonId'}).'#text'
TargetUserSID = $e.where({$PSItem.Name -eq 'TargetUserSid'}).'#text'

TargetDomain = $e.where({$PSItem.name -eq 'TargetDomainName'}).'#text'
TargetLogonID = $e.where({$PSItem.Name -eq 'TargetLogonId'}).'#text'

LogonType = $e.where({$PSItem.Name -eq 'LogonType'}).'#text'
SourceIP = $e.Where({$PSItem.Name -eq 'IpAddress'}).'#text'
SourcePort = $e.Where({$PSItem.Name -eq 'IpPort'}).'#text'
AuthenticationPackage = $e.Where({$PSItem.name -eq 'AuthenticationPackageName'}).'#text'
WorkstationName = $e.Where({$PSItem.Name -eq 'WorkstationName'}).'#text'
ProcessId = $e.Where({$PSItem.Name -eq 'ProcessId'}).'#text'
ProcessName = $e.Where({$PSItem.Name -eq 'ProcessName'}).'#text'
}
#>




$SourceIP = $Events | Group-Object SourceIP 
$SourceIP | Select-Object -ExpandProperty Group 



}

}

Get-AuthenticationActivity
<#

foreach ($s in $EventList){

$EventInfo.Add([PSCustomObject]@{
UserName = $s.UserName
SourceIP = $s.SourceIP
Computer = $s.Computer

Message = ''
Severity = ''
})


$SourceIP = $Eventinfo | Group-Object SourceIP



$EventList | Group-By UserName | Sort-Object -Property Count -Descending 


}
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
