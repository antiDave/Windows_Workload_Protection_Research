param([Parameter(Mandatory=$true)][string]$OutputFile,[int]$Hours=72)
$ErrorActionPreference='Continue';$start=(Get-Date).AddHours(-1*[Math]::Abs($Hours));$logs=@()
try{$logs=Get-WinEvent -ListLog * -ErrorAction SilentlyContinue|Where-Object{$_.LogName -match '(?i)WindowsUpdate|UpdateOrchestrator|USO|System'}|Select-Object -ExpandProperty LogName}catch{}
$events=@();foreach($log in $logs|Sort-Object -Unique){try{foreach($e in Get-WinEvent -FilterHashtable @{LogName=$log;StartTime=$start} -ErrorAction Stop){$events+=[ordered]@{log_name=$e.LogName;provider=$e.ProviderName;id=$e.Id;level=$e.LevelDisplayName;time_created=if($e.TimeCreated){$e.TimeCreated.ToString('o')}else{$null};message=$e.Message}}}catch{}}
[ordered]@{collected_utc=(Get-Date).ToUniversalTime().ToString('o');start_time_local=$start.ToString('o');logs_examined=@($logs|Sort-Object -Unique);event_count=$events.Count;events=$events}|ConvertTo-Json -Depth 8|Set-Content $OutputFile -Encoding UTF8
