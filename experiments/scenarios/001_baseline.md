# 001 — Baseline

## Purpose

Establish normal restart behavior with no protected workload.

## Setup

- Fresh or clean Windows VM snapshot.
- Record Windows version/build.
- Record Windows Update configuration.
- Ensure no workload-protection intervention is active.

## Procedure

1. Capture initial Windows Update state.
2. Capture restart-required state.
3. Capture scheduled restart state if present.
4. Capture Active Hours.
5. Capture applicable deadline/grace-period information.
6. Observe the resulting Windows behavior.

## Expected evidence

This establishes the control condition for later workload-protection experiments.
