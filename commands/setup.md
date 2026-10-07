---
description: Claude Code only. Link this repo to a FreeRide project, add FreeRide's rules to CLAUDE.md and AGENTS.md, and switch an older FreeRide setup to the plugin
---

Set up FreeRide for this repo. **Show every change first and ask once. Never delete or change anything not approved, or anything that isn't FreeRide's.**

## 1. Look (read only)

- `.freeride.json`: which `project` id?
- `.mcp.json`: a server pointing at `mcp.freeride.dev` is an older setup (`npx freeride init`). Note its name and `?project=<id>`.
- FreeRide blocks (`<!-- freeride-start -->` … `<!-- freeride-end -->`) in `CLAUDE.md`, `.claude/CLAUDE.md`, `AGENTS.md`: how many in each, and do they match `${CLAUDE_PLUGIN_ROOT}/templates/claude-md-block.md`?
- Old hook scripts in `.claude/hooks/` (`post-compact-reminder.sh`, `pre-edit-freeride-nudge.sh`, `post-edit-tracking-nudge.sh`, `post-build-tracking-nudge.sh`) and the entries running them in `.claude/settings.json` / `.claude/settings.local.json`.
- Old files: `.claude/commands/freeride-on.md`, `freeride-off.md`, `.claude/.freeride-version`.
- `claude mcp list`: is there a `claude.ai freeride` connector?

## 2. Project

- `.freeride.json` has one → confirm its name with `catch_up`.
- Older setup has `?project=<id>` → use it, so existing work stays connected; confirm with `catch_up`.
- Neither → `list_projects` and ask. Offer `create(kind: "project", name, description)` if none fits.

## 3. Plan, then ask once

Only create files or edit in place; delete nothing (safe under auto mode).

- **Back up** every file you'll edit to `.claude/freeride-backup-<YYYY-MM-DD>/`, and add `.claude/freeride-backup-*/` to `.gitignore` (backups can hold keys).
- **Link:** `.freeride.json` = `{ "project": "<id>" }`. Committed, it links teammates too.
- **Rules block** in two files, so the repo is ready in every agent (Claude Code reads `CLAUDE.md`; Codex and Cursor read `AGENTS.md`). Content: the template's text plus one line, inside the markers:
  `FreeRide project: <name> (id <id>). Pass the id as project_id to start_session.`
  - **Claude file:** Claude Code loads both `CLAUDE.md` and `.claude/CLAUDE.md`, so only one may hold the block. Use the one that has it; if both do, keep `.claude/CLAUDE.md`'s and remove the other block. If neither has it, use whichever file exists (`CLAUDE.md` first); if neither exists, create `CLAUDE.md`.
  - **`AGENTS.md`** at the repo root, created if missing.
  - **One block per file:** replace only what's between existing markers. If a file has several blocks, keep the first and remove the rest. If it has none, append one. Never change text outside the markers.
- **Older setup only:**
  - Switch the old connection off: add its name (usually `freeride`) to `disabledMcpjsonServers` in `.claude/settings.local.json` (create it if needed; remove it from `enabledMcpjsonServers`). Leave `.mcp.json` as is.
  - Unregister the old hooks: remove only the entries running the four old scripts from `.claude/settings.json` / `.claude/settings.local.json`; drop hook events left empty. The scripts can stay.
  - Retire `.claude/commands/freeride-on.md` and `freeride-off.md` (if present): replace their contents with "FreeRide now runs through the FreeRide plugin. This command is retired; use /freeride:status instead."
  - Auto mode may block the hook and command edits. That's safe: the plugin's hooks stay silent while old hooks are registered. Finish the rest and tell the user those two need their approval. Never work around a block with shell commands.
  - Leftovers (old scripts, retired commands, `.claude/.freeride-version`, the `.mcp.json` entry) are harmless; delete only if asked. Tell the user to stop running `npx freeride update` here.
- **`claude.ai freeride` showed up:** that's their claude.ai connection, which Claude Code also loads, so FreeRide appears twice and that copy doesn't know the repo's project. Offer to add `{ "serverName": "claude.ai freeride" }` to `deniedMcpServers` in `~/.claude/settings.json` (keep everything else). It covers every repo; chat and other claude.ai connectors keep working. Not `/mcp` → Disable (one repo only) or `disableClaudeAiConnectors` (all connectors).

Wait for a yes. Do only what's approved.

## 4. Apply and check

Use Write and Edit, not shell commands. Keep JSON valid. Then check: exactly one `<!-- freeride-start -->` across `CLAUDE.md` and `.claude/CLAUDE.md`, exactly one in `AGENTS.md`; edited JSON parses; the old server is in `disabledMcpjsonServers`; old hook entries are gone; `claude.ai freeride` is in `deniedMcpServers` if approved. Touch `.gitignore` only to make sure `.freeride.json` isn't ignored. Running setup again must change nothing but the blocks' contents.

## 5. Next steps for the user

- What changed, in a short list.
- Commit `.freeride.json`, the Claude file, `AGENTS.md` and `.claude/settings.json`. The backup folder can go once they're happy.
- Restart Claude Code (or `/mcp` → reconnect `plugin:freeride:freeride`) so it picks up the link. Sign in if asked.
- If `claude.ai freeride` was blocked: undo by removing it from `deniedMcpServers`.
- Optional, for Claude chat or ChatGPT (they don't read CLAUDE.md): offer this line for claude.ai Settings → Instructions for Claude (or ChatGPT's Custom instructions), in a code block:
  `For my projects, use FreeRide: catch up on the project before we discuss it, and save new ideas and decisions to FreeRide, not to your built-in memory.`
