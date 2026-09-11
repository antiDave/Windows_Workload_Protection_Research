# Experiment Command Packs

Read-only PowerShell collectors for Windows Workload Protection
Research. They do not change Windows Update settings, initiate
restart/shutdown, terminate processes, or modify files outside the
selected results directory.

## Run

``` powershell
.\experiments\commands\windows-11\25H2\collect.ps1
```

Results are written under
`experiments/results/windows-11-<release>/<computer>/<UTC timestamp>/`.
The collector verifies the detected Windows release and records the
exact build.

## Contributor requirements

Record the exact Windows build, physical/VM status, scenario, workload
(if any), update state, restart requirement, relevant update events, and
policy state. Do not contribute secrets, credentials, private keys,
personal documents, or unrelated event-log data.
