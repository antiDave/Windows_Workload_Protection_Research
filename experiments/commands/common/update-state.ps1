param([Parameter(Mandatory=$true)][string]$OutputFile)
$ErrorActionPreference='Continue'
$updates=@();$err=$null
try{$s=New-Object -ComObject Microsoft.Update.Session;$q=$s.CreateUpdateSearcher().Search('IsInstalled=0');foreach($u in $q.Updates){$updates+=[ordered]@{title=$u.Title;kb_article_ids=@($u.KBArticleIDs);update_id=$u.Identity.UpdateID;revision_number=$u.Identity.RevisionNumber;is_downloaded=$u.IsDownloaded;is_installed=$u.IsInstalled;reboot_required=$u.RebootRequired;reboot_behavior=if($u.PSObject.Properties['InstallationRebootBehavior']){$u.InstallationRebootBehavior}else{$null}}}}catch{$err=$_.Exception.Message}
$svc=$null;try{$x=Get-Service wuauserv;$c=Get-CimInstance Win32_Service -Filter "Name='wuauserv'";$svc=[ordered]@{name=$x.Name;status=[string]$x.Status;start_type=$c.StartMode}}catch{$svc=[ordered]@{error=$_.Exception.Message}}
$markers=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired','HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')|ForEach-Object{[ordered]@{path=$_;exists=Test-Path $_}}
[ordered]@{collected_utc=(Get-Date).ToUniversalTime().ToString('o');wua_com_session_error=$err;pending_updates=$updates;pending_update_count=$updates.Count;windows_update_service=$svc;reboot_registry_markers=@($markers)}|ConvertTo-Json -Depth 10|Set-Content $OutputFile -Encoding UTF8
