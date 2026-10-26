#!/bin/sh
# The state of FreeRide's rules block in a repo, for the X-FreeRide-Rules
# header: one entry per file that has the block, "<file>=<stamp>,<sum>",
# separated by spaces. Prints nothing when no file has a block.
#   <stamp>  the block's freeride-rules date, or "none" (blocks before 2026-10-26)
#   <sum>    a checksum of the block without the repo's own "FreeRide project:"
#            line, blank lines, trailing spaces or CRs, so the server can tell
#            an untouched official block from one someone edited
# The Codex connection runs the same steps inline (codex/mcp.json): keep the
# two in step (mcp-server/scripts/rules-refresh-test.mjs checks they agree).
# Plain sh + sed + cksum so it needs nothing installed.

dir="${1:-.}"
out=""
for f in CLAUDE.md .claude/CLAUDE.md AGENTS.md; do
  [ -f "$dir/$f" ] || continue
  body=$(tr -d '\r' < "$dir/$f" | sed -n '/<!-- freeride-start -->/,/<!-- freeride-end -->/p')
  [ -n "$body" ] || continue
  stamp=$(printf '%s\n' "$body" | sed -n 's/.*<!-- freeride-rules: \([0-9-]*\) -->.*/\1/p' | head -n 1)
  sum=$(printf '%s\n' "$body" | grep -v '^FreeRide project:' | sed 's/[[:space:]]*$//' | grep -v '^$' | cksum | cut -d' ' -f1)
  out="$out${out:+ }$f=${stamp:-none},$sum"
done
printf '%s' "$out"
