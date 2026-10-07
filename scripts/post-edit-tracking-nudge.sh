#!/bin/bash
# PostToolUse hook (Edit/Write): nudges the agent to call complete_work after
# substantial code changes. Fires on every 3rd Edit/Write (3, 6, 9...) since
# the last complete_work/start_session using modulo arithmetic.
#
# This fires DURING the agent's turn (unlike Stop hooks which fire after),
# so the agent can actually act on it.
#
# NOTE: Hook additionalContext is injected as a system-reminder in the tool result,
# NOT as a searchable transcript entry. So we can't use nudge-text grep for
# re-nudge counting. Modulo arithmetic handles this cleanly.

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Need transcript to check
if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  exit 0
fi

# Read a larger window to span multiple turns
RECENT=$(tail -500 "$TRANSCRIPT")

# Find the last FreeRide tracking call (complete_work or start_session).
LAST_TRACKED_LINE=$(echo "$RECENT" | grep -nE '"name":"mcp__[^"]*__(complete_work|start_session)"|"toolName":"(complete_work|start_session)"' | tail -1 | cut -d: -f1)

# Trim to only content after the tracking call
if [ -n "$LAST_TRACKED_LINE" ]; then
  RECENT=$(echo "$RECENT" | tail -n +"$((LAST_TRACKED_LINE + 1))")
fi

# Count Edit/Write tool_use entries since last tracking call
EDIT_COUNT=$(echo "$RECENT" | grep -cE '"type":"tool_use".*"name":"(Edit|Write|StrReplace)"' || true)

# Check complete_work wasn't called since tracking point
HAS_COMPLETE=$(echo "$RECENT" | grep -cE '"name":"mcp__[^"]*__complete_work"|"toolName":"complete_work"' || true)
if [ "$HAS_COMPLETE" -gt 0 ]; then
  exit 0
fi

# Fire on every 3rd untracked edit (3, 6, 9...) using modulo
if [ "$EDIT_COUNT" -ge 3 ] && [ $((EDIT_COUNT % 3)) -eq 0 ]; then
  cat <<'HOOK_OUTPUT'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "You made multiple code changes without calling complete_work. Consider: do these changes represent meaningful progress that future sessions should understand? New features, significant implementations, architectural changes, or important refactors warrant complete_work(feature_id, summary). Small UI tweaks, typo fixes, or minor adjustments do not. If this was substantial work, log it now."
  }
}
HOOK_OUTPUT
  exit 0
fi

exit 0
