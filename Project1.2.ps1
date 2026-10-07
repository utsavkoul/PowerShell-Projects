<#function Get-AuthenticationActivity{

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
#>

$Events = Import-Csv -Path "C:\Users\Acer\Downloads\Dummy_Project1_Authentication_Logs.csv"

# $events = Get-WinEvent -FilterHashtable @{LogName = "Security"; Id = 4624}
$Info = [System.Collections.ArrayList]@({})
<#
foreach ($e in $events){

$xml = [xml]$e.ToXml()
$system = $xml.Event.System
$eventdata = $xml.Event.EventData.data 

$Info.Add([PSCustomObject]@{

Time = $system.TimeCreated
EventID = $system.EventID

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
})
}
#><#
$Events
foreach ($e in $Events){
$Info.Add([PSCustomObject]@{
    TimeCreated = $e.Time
    Computer = $e.Computer
    SubjectUserSID = $e.SubjectSID
    SubjectUserName = $e.SubjectUser
    TargetUserName = $e.TargetUser
    LogonType = $e.LogonType
    IpAddress = $e.SourceIP
    AuthenticationPackage = $e.AuthenticationPackage
    EventID = $e.EventID

})}
#>

# $Info | Group-Object TargetUser | ForEach-Object { $PSItem | Select-Object @{Name='Count'; Expression={$PSItem.Count}},@{Name='TargetUser'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object TargetUser -Unique}}, @{Name='LogonType'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object LogonType -Unique}}, @{Name='SourceIP'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object SourceIP -Unique}}, @{Name='AuthenticationPackage'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object AuthenticationPackage -Unique}} } | Format-Table  

$Events| Group-Object TargetUser | ForEach-Object {$PSItem | Select-Object @{Name='Count'; Expression={$PSItem.Count}},@{Name='TargetUser'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object TargetUser -Unique}}, @{Name='LogonType'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object LogonType -Unique}}, @{Name='SourceIP'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object SourceIP -Unique}}, @{Name='AuthenticationPackage'; Expression={$PSItem | Select-Object -ExpandProperty Group | Select-Object AuthenticationPackage -Unique}} } | Format-Table



# $Info | Select-Object @{Name='TimeCreated'; Expression={$PSItem.TimeCreated}}, @{Name='Computer'; Expression={$PSItem.Computer}}, @{Name='SubjectUserSID'; Expression={$PSItem.SubjectUserSID}}, @{Name='SubjectUserName'; Expression={$PSItem.SubjectUserName}}, @{Name='TargetUserName'; Expression={$PSItem.TargetUserName}}, @{Name='LogonType'; Expression={$PSItem.LogonType}}, @{Name='IpAddress'; Expression={$PSItem.IpAddress}}, @{Name='AuthenticationPakage'; Expression={$PSItem.AuthenticationPackage}}, @{Name='EventID'; Expression={$PSItem.EventID}} | Sort-Object -Unique | Format-Table -AutoSize






# Get-AuthenticationActivity -ComputerName "10.149.203.67" -StartTime (Get-Date).AddHours(-24) -EndTime (Get-Date)