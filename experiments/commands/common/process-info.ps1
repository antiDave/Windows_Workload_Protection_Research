param([Parameter(Mandatory=$true)][string]$OutputFile,[string]$ProcessName)
$ErrorActionPreference='Stop'
$p=Get-CimInstance Win32_Process
if($ProcessName){$n=[IO.Path]::GetFileNameWithoutExtension($ProcessName);$p=$p|Where-Object{$_.Name -ieq "$n.exe" -or $_.Name -ieq $n}}
$items=@($p|ForEach-Object{[ordered]@{name=$_.Name;pid=[int]$_.ProcessId;parent_pid=[int]$_.ParentProcessId;command_line=$_.CommandLine;executable_path=$_.ExecutablePath;creation_date=if($_.CreationDate){$_.CreationDate.ToString('o')}else{$null}}})
[ordered]@{collected_utc=(Get-Date).ToUniversalTime().ToString('o');filter=$ProcessName;process_count=$items.Count;processes=$items}|ConvertTo-Json -Depth 8|Set-Content $OutputFile -Encoding UTF8
