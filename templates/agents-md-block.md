<!-- freeride-start -->
<!-- freeride-rules: 2026-11-13 -->
# FreeRide Workflow

This project uses FreeRide for work tracking. These rules apply whenever the FreeRide MCP server is connected.

## Session
- Call `start_session` once, at the start of each conversation, before anything else, and work from its reply. Later messages in the same conversation don't need it.
- If your context was compacted, call `start_session` again — the server resumes your session.

## Work Tracking
- `begin_work(area_id)` before your first Edit/Write in an area. Loads context you need.
- Working on a specific backlog item? Pass its id — `begin_work(area_id, backlog_item_id)` returns that item's full description. Read it and act on the real detail; never work from just the title you saw at start_session.
- `complete_work(area_id, summary)` after meaningful progress: new functionality, significant implementations, architectural changes, important refactors. Not for typo fixes or minor tweaks.
- These two calls are your primary obligation. Everything else in FreeRide is secondary to this.

## Ideas & Decisions
- Capture user ideas proactively via `create(kind: "backlog_item")`.
- Log meaningful decisions via `capture(kind: "decision")`.
<!-- freeride-end -->
