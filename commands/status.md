---
description: Claude Code only. Check how FreeRide is set up in this repo (read only); not for chat
---

Check FreeRide's setup in this repo and report it in a short, plain list. **Don't change anything.**

1. **Linked project:** read `.freeride.json`. If it has a project id, call `catch_up` with it and report the project's name. If there's no file, say the repo isn't linked to the plugin.
2. **FreeRide connections Claude Code can see.** There should be exactly one per repo:
   - the plugin (`plugin:freeride:freeride`);
   - an older connection in this repo's `.mcp.json` (a server pointing at `mcp.freeride.dev`). It only counts if it's still switched on: not listed in `disabledMcpjsonServers` in `.claude/settings.local.json` or `.claude/settings.json`;
   - a `claude.ai freeride` connector (check with `claude mcp list`). It doesn't count if it's blocked: listed in `deniedMcpServers` in `~/.claude/settings.json`.
3. **Rules:** the FreeRide block once in `CLAUDE.md` or `.claude/CLAUDE.md` (not both) and once in `AGENTS.md`, matching `${CLAUDE_PLUGIN_ROOT}/templates/claude-md-block.md`? Missing in `AGENTS.md` = Codex and Cursor lack the rules; twice = read twice.
4. **Old hooks:** are FreeRide's old hook scripts still *registered* in `.claude/settings.json` or `.claude/settings.local.json`? Registered old hooks double the nudges. Leftover script files that aren't registered are harmless.

End with one line of advice. For example: "All good." / "Run /freeride:setup to link this repo." / "Run /freeride:setup to switch to the plugin and remove the duplicate connection." / "FreeRide appears twice because of your claude.ai connection; /freeride:setup can block that copy in Claude Code (chat keeps it)."
