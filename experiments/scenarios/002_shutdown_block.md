# 002 — Shutdown Block

## Purpose

Determine how Windows responds when a running workload explicitly uses documented shutdown-blocking facilities.

## Procedure

1. Start a long-running test process.
2. Register the documented shutdown block.
3. Request a normal system restart.
4. Record the shutdown/restart response.
5. Release the shutdown block.
6. Repeat the restart request.
7. Record the result.

## Research question

Does documented application-level shutdown protection defer an ordinary restart, and what information does Windows expose about the block?

## Boundary

This tests ordinary shutdown behavior. It does not establish behavior during mandatory Windows servicing.
