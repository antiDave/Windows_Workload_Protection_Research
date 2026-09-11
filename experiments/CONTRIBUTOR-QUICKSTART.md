# Contributor Collection Quick Start

1.  Identify the exact Windows 11 release with `winver`.
2.  Run the matching version-specific collector.
3.  Keep the generated result directory together.
4.  Review the JSON before contributing it.
5.  Add the scenario identifier and experimental conditions to the
    result metadata.

Example:

``` powershell
.\experiments\commands\windows-11\25H2\collect.ps1
```

The collector is intentionally read-only. It establishes the observation
layer before intervention code is introduced.
