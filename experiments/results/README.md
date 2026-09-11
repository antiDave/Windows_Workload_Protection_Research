# Experiment Results

Recommended layout:

``` text
results/
└── windows-11-25H2/
    └── COMPUTER-NAME/
        └── 2026-09-10T18-42-11Z/
            system.json
            processes.json
            windows-update.json
            update-events.json
            policies.json
            collection.json
```

Do not commit raw personal data or unrelated event logs. A result should
identify the exact Windows build, environment, scenario, workload,
update state, restart requirement, relevant event evidence, policy
state, and observed outcome.
