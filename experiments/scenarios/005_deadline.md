# 005 — Deadline

## Purpose

Determine the boundary at which Windows Update policy overrides ordinary workload-protection behavior.

## Research question

Can a protected workload defer a restart through the applicable Windows Update deadline and grace period?

## Procedure

1. Establish a controlled workload.
2. Record Windows Update policy.
3. Record deadline and grace-period state.
4. Enable documented workload protection.
5. Observe behavior as the deadline approaches.
6. Observe behavior at the deadline.
7. Observe behavior during/after the grace period where applicable.
8. Record the final restart outcome.

## Safety

Use a disposable VM. Do not conduct this experiment on a production workstation containing valuable workloads or data.

## Interpretation

The desired result is not necessarily "restart blocked." The result should identify which authority controlled the outcome.
