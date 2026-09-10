# 003 — Update Pending

## Purpose

Determine how a protected workload behaves when Windows reports that an update requires a restart.

## Procedure

1. Establish a known workload.
2. Capture workload state.
3. Capture Windows Update state.
4. Record update identity and reboot behavior.
5. Determine whether Windows reports a restart as required.
6. Enable the documented protection mechanism under test.
7. Observe restart-related events.
8. Record whether the restart is deferred, occurs, or remains indeterminate.

## Important distinction

`AlwaysRequiresReboot` means the update requires a restart. It does not by itself establish when Windows will perform that restart.

Scheduled restart policy and other applicable constraints must be recorded separately.
