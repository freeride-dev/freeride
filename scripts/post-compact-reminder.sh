#!/bin/bash
# PostCompact hook: after context compaction, remind the agent to re-call
# start_session — and, when the FreeRide session_id can be recovered from the
# (uncompacted) transcript on disk, tell the agent to pass it so the EXACT
# session resumes even if the server lost its in-memory state (cold start,
# restart, or long idle). Degrades to the plain reminder if the id can't be found.

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)

BASE_MSG="Context was compacted. Call start_session to reload your session orientation and project context. The server will resume your existing session automatically. If it returns open_work_bracket, you were mid-work on a feature — call begin_work to reload feature context before continuing."

SESSION_ID=""
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  # Recover the session_id from the most recent start_session response and take its
  # first (top-level) session_id — the session this conversation is bound to. We
  # anchor on the orientation payload's "workflow_rules" JSON KEY (matched as
  # workflow_rules.{1,2}: to bridge the escaped ": without needing backslashes),
  # NOT the bare word, so prose mentions of "workflow_rules" don't match. The
  # transcript file isn't truncated by compaction, so the id survives even when
  # it's gone from the agent's context. The .{0,8} skips the key/value separator.
  SESSION_ID=$(grep -E 'workflow_rules.{1,2}:' "$TRANSCRIPT" 2>/dev/null | tail -1 \
    | grep -oiE 'session_id.{0,8}[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' \
    | head -1 \
    | grep -oiE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')
fi

if [ -n "$SESSION_ID" ]; then
  EXTRA=" To resume THIS conversation's exact session even if the server lost its in-memory state, call start_session with session_id $SESSION_ID."
else
  EXTRA=""
fi

# Emit without depending on jq for output so the reminder always fires. BASE_MSG
# and EXTRA contain no JSON-special characters; SESSION_ID is a validated UUID.
printf '{"systemMessage": "%s%s"}\n' "$BASE_MSG" "$EXTRA"
exit 0
