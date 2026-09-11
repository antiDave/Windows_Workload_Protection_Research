param([Parameter(Mandatory=$true)][string]$OutputFile)
$ErrorActionPreference='Stop'
$os=Get-CimInstance Win32_OperatingSystem
$cs=Get-CimInstance Win32_ComputerSystem
$cpu=Get-CimInstance Win32_Processor|Select-Object -First 1
[ordered]@{collected_utc=(Get-Date).ToUniversalTime().ToString('o');computer_name=$env:COMPUTERNAME;os=[ordered]@{caption=$os.Caption;version=$os.Version;build=$os.BuildNumber;architecture=$os.OSArchitecture;last_boot=if($os.LastBootUpTime){$os.LastBootUpTime.ToString('o')}else{$null}};computer=[ordered]@{manufacturer=$cs.Manufacturer;model=$cs.Model;system_type=$cs.SystemType;total_memory_bytes=$cs.TotalPhysicalMemory;domain=$cs.Domain;part_of_domain=$cs.PartOfDomain};processor=[ordered]@{name=$cpu.Name;manufacturer=$cpu.Manufacturer;physical_cores=$cpu.NumberOfCores;logical_processors=$cpu.NumberOfLogicalProcessors}}|ConvertTo-Json -Depth 6|Set-Content $OutputFile -Encoding UTF8
