#!/bin/bash
# PostToolUse hook (Bash): nudges the agent to call complete_work after a
# successful build or test command when there are untracked edits.
#
# This fires at the natural "work verified" milestone — the agent just confirmed
# its code works and is about to summarize. Perfect moment for tracking.
#
# Only fires if:
# 1. The Bash command was a build/test/compile (matched by keyword)
# 2. The command succeeded (exit code 0)
# 3. There are untracked Edit/Write calls since the last complete_work/start_session
# 4. This nudge hasn't already fired since the last tracking call

INPUT=$(cat)
TOOL_INPUT_COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_response.exitCode // .tool_response.exit_code // empty')
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Only care about build/test/compile commands
if ! echo "$TOOL_INPUT_COMMAND" | grep -qiE '\b(build|test|compile|check|lint)\b|^tsc|^make\b|^cargo (build|test|check)|^go (build|test)|^pytest|^jest|^vitest|^rspec|^gradle|^mvn|^flutter (build|test)|^swift (build|test)'; then
  exit 0
fi

# Only care about successful commands. If exitCode is missing from the hook
# input (Claude Code may not provide it), assume success.
if [ -n "$EXIT_CODE" ] && [ "$EXIT_CODE" != "0" ]; then
  exit 0
fi

# Need transcript to check for untracked edits
if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  exit 0
fi

RECENT=$(tail -500 "$TRANSCRIPT")

# Find the last FreeRide tracking call
LAST_TRACKED_LINE=$(echo "$RECENT" | grep -nE '"name":"mcp__[^"]*__(complete_work|start_session)"|"toolName":"(complete_work|start_session)"' | tail -1 | cut -d: -f1)

# Find the last time this nudge fired
LAST_NUDGE_LINE=$(echo "$RECENT" | grep -nF 'Build succeeded with untracked work' | tail -1 | cut -d: -f1)

# Use whichever is more recent as scan start
SCAN_FROM=0
if [ -n "$LAST_TRACKED_LINE" ] && [ -n "$LAST_NUDGE_LINE" ]; then
  if [ "$LAST_NUDGE_LINE" -gt "$LAST_TRACKED_LINE" ]; then
    SCAN_FROM=$LAST_NUDGE_LINE
  else
    SCAN_FROM=$LAST_TRACKED_LINE
  fi
elif [ -n "$LAST_TRACKED_LINE" ]; then
  SCAN_FROM=$LAST_TRACKED_LINE
elif [ -n "$LAST_NUDGE_LINE" ]; then
  SCAN_FROM=$LAST_NUDGE_LINE
fi

if [ "$SCAN_FROM" -gt 0 ]; then
  RECENT=$(echo "$RECENT" | tail -n +"$((SCAN_FROM + 1))")
fi

# Check if there are any untracked Edit/Write calls
EDIT_COUNT=$(echo "$RECENT" | grep -cE '"type":"tool_use".*"name":"(Edit|Write|StrReplace)"' || true)

if [ "$EDIT_COUNT" -gt 0 ]; then
  HAS_COMPLETE=$(echo "$RECENT" | grep -cE '"name":"mcp__[^"]*__complete_work"|"toolName":"complete_work"' || true)
  if [ "$HAS_COMPLETE" -eq 0 ]; then
    cat <<'HOOK_OUTPUT'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Build succeeded with untracked work. You verified your changes work — this is the natural moment to log them. Call complete_work(feature_id, summary) to record what you built."
  }
}
HOOK_OUTPUT
    exit 0
  fi
fi

exit 0
