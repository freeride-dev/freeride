#!/bin/bash
# PreToolUse hook (Edit/Write): nudges the agent that FreeRide is connected
# before code changes begin. Fires once per work stretch — before the first
# Edit/Write since the last complete_work/start_session.
#
# This fires BEFORE the edit, so the current edit isn't in the transcript yet.
# If any prior Edit/Write exists since the last tracking call, this isn't the
# first edit — stay silent.

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Need transcript to check
if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  exit 0
fi

# Read a larger window to find FreeRide tools across turns
RECENT=$(tail -500 "$TRANSCRIPT")

# Find the last FreeRide tracking call (complete_work or start_session).
LAST_TRACKED_LINE=$(echo "$RECENT" | grep -nE '"name":"mcp__[^"]*__(complete_work|start_session)"' | tail -1 | cut -d: -f1)
if [ -n "$LAST_TRACKED_LINE" ]; then
  RECENT=$(echo "$RECENT" | tail -n +"$((LAST_TRACKED_LINE + 1))")
fi

# If the agent called begin_work since the last tracking point, it's already engaged.
if echo "$RECENT" | grep -qE '"name":"mcp__[^"]*__begin_work"'; then
  exit 0
fi

# If there are already Edit/Write calls since the last tracking point,
# this isn't the first edit — stay silent.
if echo "$RECENT" | grep -qE '"type":"tool_use".*"name":"(Edit|Write)"'; then
  exit 0
fi

# First Edit/Write since last tracking call, no FreeRide engagement — nudge.
cat <<'HOOK_OUTPUT'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "FreeRide is connected. What you track now is the context the next session starts with. For substantial feature work, begin_work(feature_id) loads the context you need before coding. For smaller changes, complete_work(feature_id, summary) after you're done is enough. You decide which fits."
  }
}
HOOK_OUTPUT
exit 0
