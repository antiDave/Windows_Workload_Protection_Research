# Windows Restart Model — Working Research Model

This document is a hypothesis to be validated experimentally.

## Relevant mechanisms

Windows provides several mechanisms relevant to restart handling:

- Active Hours
- Windows Update policies
- Windows Update Agent update/reboot state
- application shutdown-blocking APIs
- Restart Manager
- restart-required state
- scheduled restart behavior
- deadlines and grace periods

These mechanisms should not be treated as equivalent.

## Conceptual model

```text
Protected workload
        |
        v
Application shutdown protection
        |
        v
Windows shutdown infrastructure
        |
        v
Restart Manager
        |
        v
Windows Update
        |
        v
Servicing / restart policy
        |
        v
Deadline or forced-restart condition
```

This is a research hypothesis, not a guaranteed implementation path for every Windows restart.

## Reboot behavior

Where available, record Windows Update Agent reboot behavior:

- `NeverReboots`
- `CanRequestReboot`
- `AlwaysRequiresReboot`

These values describe update behavior. They do not alone determine the exact time at which Windows will restart.

## Policy precedence

The project must separately investigate:

1. application shutdown blocks;
2. ordinary restart requests;
3. Windows Update scheduled restarts;
4. Active Hours;
5. deadlines;
6. grace periods; and
7. forced servicing conditions.

A scheduled restart occurring at the time specified by Windows Update should be recorded as **Windows Update policy taking precedence** if the evidence supports that conclusion.

## Evidence standard

Do not claim that a mechanism "blocks Windows Update" based solely on a delayed restart. Establish what Windows requested, what the application requested, what policy was active, what actually happened, and, where possible, why it happened.
