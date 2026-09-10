# Experiments

Experiments establish reproducible evidence about Windows restart behavior.

## Rules

1. Prefer disposable Windows virtual machines.
2. Record the exact Windows build.
3. Record update identity and category where available.
4. Record Windows Update policy state.
5. Record workload state.
6. Record every intervention.
7. Record timestamps for state transitions.
8. Never infer causality from a single observation.
9. Repeat important tests from a clean VM snapshot.
10. Distinguish observed behavior from hypotheses.

## Experiment lifecycle

```text
Define scenario
      ↓
Capture baseline
      ↓
Apply controlled condition
      ↓
Observe Windows
      ↓
Record result
      ↓
Repeat
      ↓
Compare
```

Results should conform to `schemas/experiment-result.json`.
