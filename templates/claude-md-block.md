<!-- freeride-start -->
# FreeRide Workflow

This project uses FreeRide for work tracking. These rules apply whenever the FreeRide MCP server is connected.

## Session
- Call `start_session` before your first response. Every conversation, no exceptions.
- If you lose session context (after compaction), call `start_session` again — the server resumes your session.

## Work Tracking
- `begin_work(feature_id)` before your first Edit/Write on a feature. Loads context you need.
- Working on a specific backlog item? Pass its id — `begin_work(feature_id, backlog_item_id)` returns that item's full description. Read it and act on the real detail; never work from just the title you saw at start_session.
- `complete_work(feature_id, summary)` after meaningful progress: new features, significant implementations, architectural changes, important refactors. Not for typo fixes or minor tweaks.
- These two calls are your primary obligation. Everything else in FreeRide is secondary to this.

## Ideas & Decisions
- Capture user ideas proactively via `create(kind: "backlog_item")`.
- Log meaningful decisions via `capture(kind: "decision")`.
<!-- freeride-end -->
