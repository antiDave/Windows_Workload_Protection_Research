# 004 — Scheduled Restart

## Purpose

Determine whether application-level workload protection changes the behavior of a restart scheduled by Windows Update.

## Scenario

For example:

```text
Update becomes restart-pending: 12:00
Windows scheduled restart: 02:00
Protected workload remains active through 02:00
```

## Research question

Does Windows honor workload protection at the scheduled restart time, or does the configured Windows Update restart policy take precedence?

## Procedure

1. Configure a controlled scheduled restart.
2. Start the protected workload.
3. Verify that the workload remains active.
4. Verify the scheduled restart state.
5. Observe the system at the scheduled time.
6. Record whether the restart is deferred or performed.

## Interpretation

If Windows restarts at the configured time, record:

> Restart permitted by Windows Update policy.

Do not classify this simply as a failure of process protection.
