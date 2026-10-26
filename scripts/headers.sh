#!/bin/sh
# Claude Code runs this when it connects to the FreeRide server, with the
# repo folder as $1. It prints the headers to send: the plugin version; when
# the repo is linked, its project (read from .freeride.json); and when the repo
# has FreeRide's rules block, its state (rules-state.sh), so the server can
# refresh a block that's out of date. Sign-in is handled by Claude Code itself.
# Plain sh + sed so it needs nothing installed.

root=$(dirname "$0")/..
version=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$root/.claude-plugin/plugin.json" | head -n 1)

project=""
if [ -n "$1" ] && [ -f "$1/.freeride.json" ]; then
  project=$(sed -n 's/.*"project"[[:space:]]*:[[:space:]]*"\([0-9a-fA-F-]\{36\}\)".*/\1/p' "$1/.freeride.json" | head -n 1)
fi

rules=""
[ -n "$1" ] && rules=$(sh "$root/scripts/rules-state.sh" "$1" 2>/dev/null)

headers=$(printf '"X-FreeRide-Version":"plugin-%s"' "$version")
[ -n "$project" ] && headers=$(printf '%s,"X-FreeRide-Project":"%s"' "$headers" "$project")
[ -n "$rules" ] && headers=$(printf '%s,"X-FreeRide-Rules":"%s"' "$headers" "$rules")
printf '{%s}\n' "$headers"
