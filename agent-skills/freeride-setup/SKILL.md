---
name: freeride-setup
description: Codex and Cursor (not Claude Code, which has /freeride:setup). Link this repo to a FreeRide project, add FreeRide's rules to AGENTS.md and CLAUDE.md, and switch an older hand-made FreeRide setup to the plugin. Use when the user asks to set up, link or connect FreeRide for this repo, or to check how FreeRide is set up here.
---

# Set up FreeRide for this repo

**Show every change first and ask once. Never delete anything or touch what isn't FreeRide's.** If the user only asked how FreeRide is set up, do step 1, report briefly, and stop.

## 1. Look (read only)

- `.freeride.json`: linked, and to which project id?
- FreeRide blocks (`<!-- freeride-start -->` … `<!-- freeride-end -->`) in `AGENTS.md`, `CLAUDE.md`, `.claude/CLAUDE.md`: how many in each, and do they match the template (`templates/claude-md-block.md`, three folders up from this file)?
- Old hand-made setup: Codex `.codex/config.toml` `[mcp_servers.freeride]` and FreeRide nudges in `.codex/hooks.json`; Cursor `.cursor/mcp.json` `freeride` server and nudges in `.cursor/hooks.json`. An old entry may hold `SUPABASE_SERVICE_ROLE_KEY`: **never print its values**, only say it exists.
- Both the plugin's FreeRide tools and an old connection's tools present = FreeRide connected twice.

## 2. Project

`.freeride.json`'s project, else `list_projects` and ask (offer `create(kind: "project", name)`). Never guess.

## 3. Plan, then ask once

- **Link:** `.freeride.json` = `{ "project": "<id>" }`. Committed, it links teammates too.
- **Rules block** in two files, so the repo is ready in every agent (Codex and Cursor read `AGENTS.md`; Claude Code reads `CLAUDE.md`). Content: the template's text plus one line, inside the markers:
  `FreeRide project: <name> (id <id>). Pass the id as project_id to start_session.`
  Cursor can't send the project with each connection, so this line is how its agent knows it.
  - **`AGENTS.md`** at the repo root, created if missing.
  - **Claude file:** Claude Code loads both `CLAUDE.md` and `.claude/CLAUDE.md`, so only one may hold the block. Use the one that has it; if both do, keep `.claude/CLAUDE.md`'s and remove the other block. If neither has it, use whichever file exists (`CLAUDE.md` first); if neither exists, create `CLAUDE.md`.
  - **One block per file:** replace only what's between existing markers. If a file has several blocks, keep the first and remove the rest. If it has none, append one. Never change text outside the markers.
- **Old setup:** back up its files to `.codex/freeride-backup-<YYYY-MM-DD>/` (or `.cursor/…`) and add that backup folder pattern to `.gitignore` (backups can hold keys), then switch it off: Codex `enabled = false` under `[mcp_servers.freeride]`; Cursor remove only the `freeride` entry from `.cursor/mcp.json`; both remove only FreeRide's nudge entries from the hooks file.

Wait for a yes. Do only what's approved.

## 4. Apply and check

Afterwards: exactly one `<!-- freeride-start -->` in `AGENTS.md`, and exactly one across `CLAUDE.md` and `.claude/CLAUDE.md`. Running setup again must change nothing but the blocks' contents.

## 5. Next steps for the user

- Restart the agent in this repo so FreeRide picks up the link. First time, sign in when asked (Codex: `codex mcp login freeride`; Cursor: Authenticate on the FreeRide plugin page).
- Cursor only: use Agent mode (Ask mode blocks FreeRide's tools). If Cursor asks before every FreeRide call, they can allow FreeRide's tools to run without asking.
- Commit `.freeride.json`, `AGENTS.md` and the Claude file. The repo now works the same in Claude Code.
- Optional, for Claude chat or ChatGPT (they don't read AGENTS.md): offer this line for claude.ai Settings → Instructions for Claude (or ChatGPT's Custom instructions), in a code block:
  `For my projects, use FreeRide: catch up on the project before we discuss it, and save new ideas and decisions to FreeRide, not to your built-in memory.`
