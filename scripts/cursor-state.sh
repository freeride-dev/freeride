#!/bin/bash
# Cursor only: the two nudges Cursor has no matching event for.
#   - First edit: Cursor can't add context before an edit (preToolUse only
#     talks to the agent when it blocks), so the "FreeRide is connected" nudge
#     comes right after the first edit of a work stretch instead.
#   - After compaction: Cursor has preCompact but no postCompact, so preCompact
#     leaves a marker and the next tool call delivers the reminder.
# Cursor's transcript holds no tool results, so state lives in a small folder
# per conversation, fed by postToolUse on every tool.
# Usage: cursor-state.sh precompact|tool|first-edit   (hook input on stdin)

INPUT=$(cat)
conv=$(printf '%s' "$INPUT" | jq -r '.conversation_id // empty' 2>/dev/null | tr -cd 'A-Za-z0-9_-')
[ -n "$conv" ] || exit 0
# A per-user folder only this user can read or write (on Linux $TMPDIR is often
# unset, so this may sit in the shared /tmp).
base="${TMPDIR:-/tmp}/freeride-cursor-$(id -u)"
mkdir -p -m 700 "$base" 2>/dev/null || exit 0
[ -O "$base" ] && [ ! -L "$base" ] || exit 0
state="$base/$conv"
mkdir -p -m 700 "$state" 2>/dev/null || exit 0

case "$1" in
  precompact)
    touch "$state/compacted"
    ;;

  tool)
    # Which FreeRide tool ran, if any (tool_name, or the MCP tool's own name).
    name=$(printf '%s' "$INPUT" | jq -r '[.tool_name, .tool_input.toolName, .tool_input.tool_name] | map(select(type == "string")) | join(" ")' 2>/dev/null)
    case " $name" in
      *start_session*)
        id=$(printf '%s' "$INPUT" | jq -r '.tool_output // empty | tostring' 2>/dev/null \
          | grep -oiE 'session_id.{0,8}[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1 \
          | grep -oiE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')
        [ -n "$id" ] && printf '%s' "$id" > "$state/session_id"
        rm -f "$state/stretch" ;;
      *complete_work*) rm -f "$state/stretch" ;;
      *begin_work*) touch "$state/stretch" ;;
    esac
    if [ -f "$state/compacted" ]; then
      rm -f "$state/compacted"
      msg="Context was compacted. Call start_session to reload your session orientation and project context. The server will resume your existing session automatically. If it returns open_work_bracket, you were mid-work on a feature — call begin_work to reload feature context before continuing."
      [ -s "$state/session_id" ] && msg="$msg To resume THIS conversation's exact session even if the server lost its in-memory state, call start_session with session_id $(cat "$state/session_id")."
      printf '%s\n' "$msg"
    fi
    ;;

  first-edit)
    # Once per work stretch: the first edit since start_session/complete_work,
    # unless begin_work already ran.
    [ -f "$state/stretch" ] && exit 0
    touch "$state/stretch"
    echo "FreeRide is connected. What you track now is the context the next session starts with. For substantial feature work, begin_work(feature_id) loads the context you need before you go further. For smaller changes, complete_work(feature_id, summary) after you're done is enough. You decide which fits."
    ;;
esac
exit 0
