param(
    [Parameter(Mandatory=$true)]
    [string]$ProcessName
)

$Processes = Get-CimInstance Win32_Process 
$SpecificProcess = $Processes | Where-Object {$PSItem.name -like $ProcessName -or $PSItem.ExecutablePath -match $ProcessName}
# $Processes | ForEach-Object{ $Main = $PSItem; $Main | Add-Member -MemberType NoteProperty -Name 'ParentProcess' -Value 'Get-CimInstance Win32_Process | Where-Object {$PSItem.ProcessId -eq $Main.ParentProcessId | Select-Object Name}' }

$SpecificProcess | ForEach-Object {$PSMain = $PSItem; $PSMain | Select-Object @{Name='ProcessID'; Expression={$PSMain.ProcessId}}, @{Name='ProcessName'; Expression={$PSMain.ProcessName}}, @{Name='ParentProcessID'; Expression={$PSMain.ParentProcessId}},@{Name='CreationTime'; Expression={$PSMain.CreationTime}}, @{Name='User'; Expression={$PSMain | Invoke-CimMethod -MethodName 'GetOwner' | Select-Object User}}, @{Name='ParentProcess'; Expression={$Processes | Where-Object {$PSItem.ProcessId -eq $PSMain.ParentProcessId} | Select-Object Name}}, @{Name='CommandLine'; Expression={$PSMain.CommandLine}}, @{Name='ExecutablePath'; Expression={$PSMain.ExecutablePath}}} | Format-Table -AutoSize

while ($ChildProcess) {
    $ProcessID = ''
    $Process = $Processes | Where-Object {$PSItem.ProcessId -eq $ProcessID} | Select-Object @{Name='ProcessId'; Expression={$PSItem.ProcessId}}, @{Name='ProcessName'; Expression={$PSItem.ProcessName}}, @{Name='ParentProcessID'; Expression={$PSItem.ParentProcessId}}, @{Name='ParentProcessID'; Expression={$PSItem}}
    $ChildProcess = $Process | Where-Object {$PSItem.ProcessId -eq $ProcessID} | Select-Object ProcessId -OutVariable $ParentProcessID | Select-Object @{Name='ProcessId'; Expression={$PSItem.ProcessId}}, @{Name='ProcessName'; Expression={$PSItem.ProcessName}}, @{Name='ParentProcessID'; Expression={$PSItem.ParentProcessId}}, @{Name='ParentProcessID'; Expression={$PSItem}}
    $ParentProcess = $Process | Where-Object {$PSItem.ProcessId -like $ParentProcessID} | Write-Host "$PSItem.Name"
    
}
