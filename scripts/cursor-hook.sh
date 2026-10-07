#!/bin/sh
# Cursor adapter: runs one of the shared FreeRide hook scripts and hands its
# output to Cursor in the shape Cursor reads ({"additional_context": "..."}).
# The shared scripts print either plain text or Claude's hookSpecificOutput
# JSON; both become additional_context. Silent output stays silent.
# Usage: cursor-hook.sh <script> [args...]   (hook input arrives on stdin)

out=$("$(dirname "$0")/$@")
[ -n "$out" ] || exit 0
context=$(printf '%s' "$out" | jq -r '.hookSpecificOutput.additionalContext // empty' 2>/dev/null)
[ -n "$context" ] || context="$out"
jq -n --arg c "$context" '{additional_context: $c}'
