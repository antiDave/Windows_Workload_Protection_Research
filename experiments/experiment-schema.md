# Experiment Result Schema

Each experiment should answer four questions:

1. What Windows environment was tested?
2. What update and restart state existed?
3. What workload was active?
4. What did Windows actually do?

## Required evidence

Capture, where available:

- experiment identifier;
- timestamp;
- Windows version and build;
- update identity and category;
- reboot behavior;
- current reboot-required state;
- relevant restart policy;
- protected workload;
- intervention performed;
- observed restart outcome.

## Result interpretation

Distinguish:

- **requested** — an action was requested;
- **accepted** — Windows accepted the request;
- **deferred** — the restart did not occur at that point;
- **overridden** — a higher-level Windows policy caused the restart to proceed;
- **unknown** — evidence is insufficient to determine the reason.

Do not label a test "blocked" merely because a restart did not happen. The cause must be established as far as the evidence permits.

## Versioning

Prefer additive schema changes. Breaking changes require a schema-version increment and migration guidance.
