# Windows Workload Protection Research

## Overview

**Windows Workload Protection Research** is an open-source research and
experimentation project investigating how Windows handles restart
requests when long-running computational workloads are active.

The motivating problem is simple:

> A Windows Update restart should not unnecessarily destroy a
> computation that has been running for hours or days.

Examples include:

-   Long-running Python jobs
-   Scientific simulations
-   Quantum-computing workloads
-   Large data-processing jobs
-   Machine-learning training
-   Rendering
-   Compilation
-   Other user-defined workloads that cannot be safely interrupted

The project is **not initially intended to be a Windows Update
blocker**. Its first objective is to establish, empirically and
reproducibly, how Windows determines when a restart can be deferred,
what mechanisms can delay it, and which Windows Update conditions
ultimately override application-level protection.

## Project Name

**Windows Workload Protection Research**

A future user-facing application may use a shorter product name if the
research establishes a reliable and supported protection mechanism.

## Motivation

Windows already contains several mechanisms relevant to restart
protection, including:

-   Active Hours
-   Windows Update restart policies
-   Shutdown-blocking APIs
-   Restart Manager
-   Windows Update Agent APIs
-   Restart-required state
-   Update reboot behavior
-   Update deadlines and grace periods

However, these mechanisms do not provide an obvious, general-purpose
policy of the form:

> "Do not restart this computer while this specified workload is
> running."

The project will investigate whether such behavior can be implemented
reliably using documented Windows facilities, and where the boundaries
of those facilities lie.

## Core Research Question

> **How much authority can a user-space Windows application legitimately
> exercise over an operating-system restart while a protected workload
> is running?**

Secondary questions include:

1.  How does Windows identify a restart as required?
2.  Which types of updates require or can request a restart?
3.  Does the update's `RebootBehavior` affect how application-level
    restart protection behaves?
4.  How do Active Hours interact with workload protection?
5.  How do Windows Update deadlines and grace periods interact with
    workload protection?
6.  What role does Restart Manager play?
7.  What happens when Windows reaches a configured restart time?
8.  What happens when a restart is required by a more forceful servicing
    condition?
9.  Can a protected workload be allowed to complete without indefinitely
    defeating security updates?
10. What APIs and policies would Microsoft need to expose to make
    workload-aware restart protection a first-class Windows feature?

## Important Distinction: Protection vs. Windows Update Policy

The project must distinguish between **protecting a workload** and
**overriding Windows Update policy**.

For example, suppose Windows Update installs an update at noon and
Windows is configured to restart at 2:00 AM.

If the protected process is still running at 2:00 AM, the expected
behavior under the current Windows Update policy may be that Windows
proceeds with the restart.

That should not be described as the application "failing to protect" the
process.

Instead, the application should report:

> **Restart permitted by Windows Update policy.**

The research therefore needs to determine which restart conditions the
application can influence and which conditions Windows considers
authoritative.

## Proposed Update Behavior Classification

The project should record the Windows Update Agent's reboot behavior
where available:

### `NeverReboots`

The update does not require a restart.

Expected workload-protection relevance:

> No restart conflict.

### `CanRequestReboot`

The update may require a restart.

Expected workload-protection relevance:

> The application may be able to defer or block a restart depending on
> the Windows restart state and applicable policies.

### `AlwaysRequiresReboot`

The update always requires a restart.

Expected workload-protection relevance:

> Workload protection may defer the restart while Windows permits
> deferral, but Windows Update policy, deadlines, scheduled restart
> behavior, or other servicing rules may ultimately take precedence.

The exact behavior must be established experimentally rather than
assumed.

## Proposed Research Model

The initial experiment matrix should distinguish **update state** from
**workload state**.

### Update State

Potential states include:

-   No restart required
-   Restart required
-   Restart requested
-   Restart scheduled
-   Restart approaching
-   Deadline approaching
-   Deadline reached
-   Grace period active
-   Forced restart condition

### Workload State

Potential states include:

-   No protected process
-   Protected process running
-   Protected process has an active shutdown block
-   Protected process has completed
-   Protected process has exceeded its configured maximum protection
    period

### Example Matrix

  -----------------------------------------------------------------------
  Update state            Workload state          Result to measure
  ----------------------- ----------------------- -----------------------
  No restart required     Any                     No restart conflict

  Restart required        No workload             Normal Windows behavior

  Restart required        Workload running        Whether restart can be
                                                  deferred

  Restart scheduled       Workload running        Whether scheduled
                                                  restart overrides
                                                  protection

  Deadline approaching    Workload running        Whether protection
                                                  remains effective

  Deadline reached        Workload running        Whether Windows
                                                  overrides protection

  Forced restart          Workload running        Whether
  condition                                       application-level
                                                  protection can still
                                                  intervene
  -----------------------------------------------------------------------

## First Principle

**Observe before intervening.**

The initial versions of the project should not attempt to disable
Windows Update or circumvent Windows servicing.

The first implementation should collect evidence.

A research agent should be able to report information such as:

``` text
Windows Workload Protection Research

Protected process:
    python.exe
PID:
    18472
Runtime:
    41h 17m

Windows Update:
    Restart required: YES
    Update ID: XXXXX
    Reboot behavior: AlwaysRequiresReboot

Restart policy:
    Active Hours: YES
    Scheduled restart: 02:00
    Deadline: 2026-09-12
    Grace period: 2 days

Protection state:
    OBSERVE ONLY

System restart state:
    PENDING
```

## Proposed Architecture

The project can eventually consist of several components.

### 1. Workload Monitor

Responsible for:

-   Process detection
-   Process identification
-   Process-tree tracking
-   Runtime tracking
-   Command-line inspection
-   Executable-path identification
-   Optional workload matching rules

A simple configuration might allow:

``` text
Protect:
    python.exe
```

A more precise configuration could specify:

``` text
Executable:
    python.exe

Arguments contain:
    run_qasm.py

Working directory:
    C:\inetpub\predictor
```

This prevents every unrelated Python process from automatically becoming
a protected workload.

### 2. Windows Update Monitor

Responsible for collecting:

-   Update identity
-   Update type
-   Installation state
-   Restart-required state
-   Reboot behavior
-   Scheduled restart information
-   Applicable deadline information
-   Applicable grace-period information
-   Relevant Windows Update events

### 3. Restart-State Monitor

Responsible for determining:

-   Whether Windows has requested a restart
-   Whether a restart is scheduled
-   Whether an application has registered a shutdown block
-   Whether Windows is preparing to terminate applications
-   Whether the system has actually restarted

### 4. Event Recorder

Every significant state transition should be logged with timestamps.

Example:

``` text
2026-09-10 09:14:03
python.exe PID 18472 detected

2026-09-10 09:14:04
Protection state = ACTIVE

2026-09-10 10:03:17
Windows Update reports restart required

2026-09-10 10:03:18
RebootBehavior = AlwaysRequiresReboot

2026-09-10 10:03:19
Scheduled restart = 02:00

2026-09-11 02:00:00
Restart initiated by Windows
```

This creates a reproducible record rather than relying on anecdotal
observations.

## Protection Levels

Once the observational layer is established, protection can be
introduced incrementally.

### Level 0 --- Observe

No intervention.

The application records Windows behavior.

### Level 1 --- Notify

The application alerts the user when:

-   An update requires a restart
-   A restart is scheduled
-   A protected workload is active
-   A deadline is approaching
-   Windows is about to restart

### Level 2 --- Cooperative Protection

The application uses documented Windows mechanisms, where appropriate,
to communicate that an active workload should not be interrupted.

This may include Windows shutdown-blocking facilities.

### Level 3 --- Policy Coordination

Where supported, the application coordinates workload state with
applicable Windows Update policies.

### Level 4 --- Research Boundary

The application documents cases in which Windows Update or servicing
policy overrides application-level protection.

The purpose of this level is **measurement and documentation, not
circumvention**.

## Critical Research Question: Authority

One of the principal goals of the project is to establish the effective
authority hierarchy.

A simplified model to test is:

``` text
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

This diagram is a **research hypothesis**, not an assertion that every
restart follows this exact path.

The project should replace assumptions with observed behavior.

## Experimental Strategy

Testing should occur primarily in disposable Windows virtual machines.

This allows controlled experimentation without risking the host system
or an important workload.

Experiments should record:

-   Windows version and build
-   Windows edition
-   Update identity
-   Update category
-   Update reboot behavior
-   Windows Update policy
-   Active Hours
-   Scheduled restart configuration
-   Deadline and grace-period configuration
-   Protected process
-   Protection mechanism
-   Exact timestamps
-   Resulting system behavior

Where possible, the experiment should be reproducible from a clean VM
snapshot.

## Update Categories of Interest

The project should eventually test multiple update classes, including:

-   Quality updates
-   Cumulative updates
-   Feature updates
-   Out-of-band updates
-   Preview updates
-   Driver updates
-   Servicing-stack-related updates
-   Security-related updates

The project should not assume that all updates have equivalent restart
behavior.

## What This Project Is Not

This project is not intended to:

-   Permanently disable Windows Update
-   Circumvent Windows security servicing
-   Exploit Windows Update vulnerabilities
-   Guarantee that a machine can never restart
-   Encourage users to leave critical security updates indefinitely
    unapplied

The objective is to understand and, where legitimately supported,
improve the handling of long-running workloads.

## Potential End State

If the research demonstrates that Windows already provides sufficient
mechanisms, the project could evolve into a practical Windows
application:

> **Protect my workload until it finishes, while respecting Windows'
> legitimate restart and servicing policies.**

A user might configure:

``` text
Protected workload:
    python.exe

Optional command match:
    run_qasm.py

Protection:
    While workload is running

Maximum protection:
    72 hours

When workload completes:
    Allow pending restart

When Windows policy requires restart:
    Notify user
```

The application would provide visibility into why a restart is being
deferred rather than silently interfering with Windows Update.

## Potential Microsoft Feature Request

If the research establishes a genuine gap in the Windows API, the
project can provide an empirical basis for requesting a native Windows
feature.

A possible native model would be:

``` text
RegisterProtectedWorkload()

Workload:
    User-defined process/job

Protection:
    Until workload exits

Maximum protection:
    User-defined bounded interval

Security override:
    Windows-controlled

Notification:
    Required before forced restart
```

The important distinction would be that Windows itself retains final
authority over critical servicing while providing a supported mechanism
for applications to declare legitimate, long-running workloads.

## Open-Source Goals

The project should prioritize:

1.  Reproducibility
2.  Documented Windows APIs
3.  Transparent experiments
4.  Machine-readable logs
5.  Version-specific results
6.  No undocumented exploits
7.  Clear separation between observation and intervention
8.  Evidence-based conclusions

The resulting dataset may be as valuable as the application itself.

## Initial Milestone Plan

### v0.1 --- Observation

-   Process monitor
-   Windows Update state monitor
-   Restart-state monitor
-   Event logging
-   Windows version/build capture
-   Basic command-line configuration
-   No restart intervention

### v0.2 --- Controlled Protection

-   Implement documented shutdown protection
-   Add protection-state logging
-   Add restart-request detection
-   Test ordinary shutdown and restart scenarios

### v0.3 --- Windows Update Correlation

-   Correlate updates with restart requests
-   Record reboot behavior
-   Record scheduled restart state
-   Record deadlines and grace periods where available

### v0.4 --- Experimental Harness

-   Automated VM test scenarios
-   Snapshot/restore support
-   Repeatable test definitions
-   Structured result files
-   Cross-build comparison

### v0.5 --- Research Dataset

-   Standardized experiment format
-   Aggregate results
-   Windows build comparison
-   Update-category comparison
-   Documented authority boundaries

### v1.0 --- Evidence-Based Protection

Only after the preceding research should the project decide whether a
general-purpose workload-protection application is technically and
operationally justified.

## Guiding Principle

> **Do not fight Windows Update blindly. Measure what Windows does,
> identify where authority changes, and build protection only where
> Windows provides a legitimate mechanism to do so.**

The initial objective is not to prove that Windows can be stopped.

The objective is to determine **exactly when Windows permits a
long-running workload to finish, exactly when it does not, and why.**
