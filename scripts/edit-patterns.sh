#!/bin/sh
# What counts as "the agent changed files", shared by the tracking hooks.
# Sourced, not run: . "$(dirname "$0")/edit-patterns.sh"
#
# Edits come from the edit tools, and also from shell commands that write
# files (sed -i, a redirect into a source file, tee, a script that opens a
# file for writing, git apply). Agents use both; counting only the edit tools
# missed most of the edits in a session made through the shell (2026-10-22).

# Transcript lines for the edit tools (Claude Code, Cursor's StrReplace, Codex's apply_patch).
EDIT_TOOL_RE='"type":"tool_use".*"name":"(Edit|Write|MultiEdit|StrReplace|apply_patch)"'

# A shell command that writes files. Redirects only count into source-like
# files, so `> /dev/null`, `2>&1` and build logs don't.
WRITE_CMD_RE='sed -i|perl -[a-z]*i|tee |cat >|[^0-9&>]>>? ?[A-Za-z0-9_./~-]+\.(ts|tsx|js|jsx|mjs|cjs|css|scss|md|mdx|json|py|sh|sql|go|rs|rb|swift|kt|java|html|yml|yaml|toml)([^A-Za-z0-9]|$)|open\([^)]*w[+]?[\\]?["'"'"']|write_text\(|writeFile|git apply'

# Transcript lines for shell commands that write files, whatever the shell tool is called.
WRITE_LINE_RE="\"command\".*($WRITE_CMD_RE)"

# Number of edits in the transcript text given as $1.
count_edits() {
  printf '%s\n' "$1" | grep -cE "$EDIT_TOOL_RE|$WRITE_LINE_RE" || true
}

# True if the shell command given as $1 writes files.
is_write_command() {
  printf '%s' "$1" | grep -qE "$WRITE_CMD_RE"
}
