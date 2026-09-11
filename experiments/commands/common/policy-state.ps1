param([Parameter(Mandatory=$true)][string]$OutputFile)
$ErrorActionPreference='Continue';$paths=@('HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate','HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU','HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings');$reg=@()
foreach($path in $paths){if(Test-Path $path){try{$o=Get-ItemProperty $path;$v=[ordered]@{};foreach($p in $o.PSObject.Properties){if($p.Name -notmatch '^PS'){$v[$p.Name]=$p.Value}};$reg+=[ordered]@{path=$path;values=$v}}catch{$reg+=[ordered]@{path=$path;error=$_.Exception.Message}}}}
[ordered]@{collected_utc=(Get-Date).ToUniversalTime().ToString('o');registry_policy=$reg}|ConvertTo-Json -Depth 10|Set-Content $OutputFile -Encoding UTF8
