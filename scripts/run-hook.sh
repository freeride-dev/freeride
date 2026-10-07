#!/bin/sh
# Runs one of FreeRide's hooks, but only in repos the plugin is responsible for.
# The plugin is installed once and active in every repo, so:
#   - a repo not linked to FreeRide (no .freeride.json) gets nothing;
#   - a repo whose old `freeride init` hooks are still registered gets
#     nothing, because those copies already run (no double nudges).
# Usage: run-hook.sh <script-name> [args...]   (hook input arrives on stdin)

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -f "$dir/.freeride.json" ] || exit 0
# Old setup still active = its hooks are still registered in the repo's
# settings (the script files alone may be left behind after switching).
grep -qs "pre-edit-freeride-nudge.sh" "$dir/.claude/settings.json" "$dir/.claude/settings.local.json" && exit 0
# Same in Codex: a hand-made setup registers the nudges in .codex/hooks.json.
# (Codex sets PLUGIN_ROOT for plugin hooks; Claude Code sets CLAUDE_PROJECT_DIR.)
[ -z "$CLAUDE_PROJECT_DIR" ] && [ -n "$PLUGIN_ROOT" ] && grep -qs "pre-edit-freeride-nudge.sh" "$dir/.codex/hooks.json" && exit 0
# And in Cursor (CURSOR_PROJECT_DIR): a hand-made .cursor/hooks.json.
[ -n "$CURSOR_PROJECT_DIR" ] && grep -qs "pre-edit-freeride-nudge.sh" "$dir/.cursor/hooks.json" && exit 0

script=$1
shift
exec "$(dirname "$0")/$script" "$@"
