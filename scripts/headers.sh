#!/bin/sh
# Claude Code runs this when it connects to the FreeRide server, with the
# repo folder as $1. It prints the headers to send: the plugin version and,
# when the repo is linked, its project (read from .freeride.json).
# It prints only these two headers. Sign-in is handled by Claude Code itself.
# Plain sh + sed so it needs nothing installed.

root=$(dirname "$0")/..
version=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$root/.claude-plugin/plugin.json" | head -n 1)

project=""
if [ -n "$1" ] && [ -f "$1/.freeride.json" ]; then
  project=$(sed -n 's/.*"project"[[:space:]]*:[[:space:]]*"\([0-9a-fA-F-]\{36\}\)".*/\1/p' "$1/.freeride.json" | head -n 1)
fi

if [ -n "$project" ]; then
  printf '{"X-FreeRide-Version":"plugin-%s","X-FreeRide-Project":"%s"}\n' "$version" "$project"
else
  printf '{"X-FreeRide-Version":"plugin-%s"}\n' "$version"
fi
