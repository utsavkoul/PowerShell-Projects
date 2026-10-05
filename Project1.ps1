function Get-AuthenticationActivity{

param(
 [Parameter(Mandatory = $true)]
[string]$ComputerName,
 [Parameter(Mandatory = $true)]
[datetime]$StartTime,
 [Parameter(Mandatory = $true)]
[datetime]$EndTime
)

Invoke-Command -ComputerName $ComputerName  -ArgumentList $StartTime,$EndTime -ScriptBlock{
param(
 [Parameter(Mandatory = $true)]
[datetime]$RemoteStartTime,
 [Parameter(Mandatory = $true)]
[datetime]$RemoteEndTime
)

$event = Get-WinEvent -FilterHashtable @{ LogName = "Security"; Id = 4624; StartTime="$RemoteStartTime"; EndTime="$RemoteEndTime" }
foreach ($e in $event){

$xml = [xml]$e.ToXml()
$system = $xml.Event.System
$eventdata = $xml.Event.EventData.data 

[PSCustomObject]@{

Time = $e.TimeCreated
EventID = $e.Id
UserName = $system.Name
SubjectSID = $eventdata.Where({$PSItem.Name -eq 'SubjectUserSid'}).'#text'
SubjectDomain = $eventdata.where({$PSItem.Name -eq 'SubjectDomainName'}).'#text'
SubjectUser = $eventdata.Where({$PSItem.Name -eq 'SubjectUserName'}).'#text'

SubjectLogonId = $eventdata.where({$PSItem.Name -eq 'SubjectLogonId'}).'#text'
TargetUserSID = $eventdata.where({$PSItem.Name -eq 'TargetUserSid'}).'#text'
TargetUser = $eventdata.where({$PSItem.NAme -eq 'TargetUserName'}).'#text'
TargetDomain = $eventdata.where({$PSItem.name -eq 'TargetDomainName'}).'#text'
TargetLogonID = $eventdata.where({$PSItem.Name -eq 'TargetLogonId'}).'#text'
Computer = $system.Computer
LogonType = $eventdata.where({$PSItem.Name -eq 'LogonType'}).'#text'
SourceIP = $eventdata.Where({$PSItem.Name -eq 'IpAddress'}).'#text'
SourcePort = $eventdata.Where({$PSItem.Name -eq 'IpPort'}).'#text'
AuthenticationPackage = $eventdata.Where({$PSItem.name -eq 'AuthenticationPackageName'}).'#text'
WorkstationName = $eventdata.Where({$PSItem.Name -eq 'WorkstationName'}).'#text'
ProcessId = $eventdata.Where({$PSItem.Name -eq 'ProcessId'}).'#text'
ProcessName = $eventdata.Where({$PSItem.Name -eq 'ProcessName'}).'#text'
}
}
}
}

Get-AuthenticationActivity -ComputerName "10.149.203.67" -StartTime (Get-Date).AddHours(-24) -EndTime (Get-Date)