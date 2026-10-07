#!/bin/sh
# SessionStart: makes sure the agent has FreeRide's rules, without forcing any
# tool call. The CLAUDE.md block is the main channel; this
# is the backup for repos that don't have it. Whatever this prints is added to
# the agent's context.

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
root=$(dirname "$0")/..

# Which agent runs this: Cursor sets CURSOR_PROJECT_DIR (and CLAUDE_PROJECT_DIR),
# Codex sets PLUGIN_ROOT but not CLAUDE_PROJECT_DIR, Claude Code the rest.
# Codex and Cursor read AGENTS.md; Claude Code reads CLAUDE.md.
has_block() {
  if [ -n "$CURSOR_PROJECT_DIR" ] || { [ -z "$CLAUDE_PROJECT_DIR" ] && [ -n "$PLUGIN_ROOT" ]; }; then
    grep -qs "freeride-start" "$dir/AGENTS.md"
  else
    grep -qs "freeride-start" "$dir/CLAUDE.md" "$dir/.claude/CLAUDE.md"
  fi
}

# An old `freeride init` connection that's still switched on. /freeride:setup
# switches it off with disabledMcpjsonServers instead of editing .mcp.json.
old_connection() {
  [ -f "$dir/.mcp.json" ] && grep -q "mcp.freeride.dev" "$dir/.mcp.json" || return 1
  ! cat "$dir/.claude/settings.local.json" "$dir/.claude/settings.json" 2>/dev/null | tr -d '\n' | grep -qE '"disabledMcpjsonServers"[^]]*"freeride"'
}

if [ ! -f "$dir/.freeride.json" ]; then
  if old_connection; then
    echo "FreeRide: this repo has its own FreeRide connection (.mcp.json) and the FreeRide plugin is installed too, so FreeRide's tools appear twice. Use the repo's own FreeRide tools (the ones whose names don't start with mcp__plugin_freeride) — they know this repo's project. Running the FreeRide setup (/freeride:setup in Claude Code) switches the repo to the plugin and removes the duplicate."
  fi
  # Not a FreeRide repo: say nothing.
  exit 0
fi

if old_connection; then
  echo "FreeRide: this repo's old FreeRide connection (.mcp.json) is still switched on next to the plugin, so FreeRide's tools appear twice. Prefer the plugin's tools (mcp__plugin_freeride_freeride__*). Running the FreeRide setup (/freeride:setup in Claude Code) finishes the switch."
fi

project=$(sed -n 's/.*"project"[[:space:]]*:[[:space:]]*"\([0-9a-fA-F-]\{36\}\)".*/\1/p' "$dir/.freeride.json" | head -n 1)
echo "This repo is linked to FreeRide project $project. Pass this id as project_id to start_session (and to other FreeRide tools if FreeRide asks which project)."

if ! has_block; then
  sed -e '/freeride-start/d' -e '/freeride-end/d' "$root/templates/claude-md-block.md"
  echo "(These FreeRide rules come from the FreeRide plugin because this repo's CLAUDE.md or AGENTS.md doesn't have them. The FreeRide setup can add them: /freeride:setup in Claude Code; in Codex or Cursor, ask the agent to set up FreeRide for this repo.)"
fi
exit 0
