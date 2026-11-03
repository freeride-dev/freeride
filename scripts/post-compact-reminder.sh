#!/bin/sh
# After the context is compacted (SessionStart with source "compact"): remind
# the agent to call start_session again, with the id of the FreeRide session
# this conversation is on, so it continues that exact session even when the
# server lost its state meanwhile (a restart, a reconnect, a long idle).
#
# It runs on SessionStart because Claude Code adds what a SessionStart hook
# prints to the agent's context. A PostCompact hook's output never reaches the
# agent (Claude Code drops its systemMessage and logs its stdout), so this
# reminder, a PostCompact hook until plugin 0.1.24, was never seen.
#
# The session is the latest one the transcript shows this conversation on:
# start_session's answer (its top-level session_id), or complete_work's note
# when it started a session itself ("FreeRide started a new session (<id>)",
# mcp-server/src/state.ts). The transcript on disk keeps everything compaction
# drops. Both are matched as the server wrote them, escaped once inside the
# transcript's JSON, so the same text printed by a command (escaped twice)
# doesn't count. With no id found, it's the plain reminder.

input=$(cat)
transcript=$(printf '%s' "$input" | sed -n 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)

id=""
if [ -n "$transcript" ] && [ -f "$transcript" ] && command -v perl >/dev/null 2>&1; then
  # Perl, not grep: transcripts run to 200 MB with lines of megabytes, and
  # macOS grep takes seconds on them (the hook has 5). Perl reads one about
  # 0.2 s. A start_session answer opens with its session_id, before its
  # workflow_rules; the last line with either kind gives the id.
  id=$(perl -ne '
    my $n = index($_, q{FreeRide started a new session (});
    my $w = index($_, q{\"workflow_rules\":});
    next if $n < 0 && $w < 0;
    if ($n >= 0 && /session_note\\":\\"FreeRide started a new session \(([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})\)/) { $id = $1; next; }
    if ($w >= 0 && /\{\\"session_id\\":\\"([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})\\",/ && $-[0] < $w) { $id = $1; }
    END { print $id if defined $id }
  ' "$transcript" 2>/dev/null)
fi

if [ -n "$id" ]; then
  echo "Context was compacted. This conversation is on FreeRide session $id: call start_session with session_id $id to reload your orientation and continue it (this also works if the FreeRide server restarted or reconnected meanwhile). If it returns open_work_bracket, you were mid-work on an area: call begin_work to reload its context before continuing."
else
  echo "Context was compacted. Call start_session to reload your orientation and project context. If it returns open_work_bracket, you were mid-work on an area: call begin_work to reload its context before continuing."
fi
exit 0
