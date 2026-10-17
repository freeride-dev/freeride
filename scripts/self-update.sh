#!/bin/sh
# Keeps a git-cloned install of the plugin current. Cursor installs FreeRide
# from GitHub into ~/.cursor/plugins/local/freeride, and nothing else would
# ever update that folder. Runs at session start, at most once a day, in the
# background, and prints nothing. Only fast-forwards: a folder with local
# changes, or that isn't a git clone, is left alone.

root=$(cd "$(dirname "$0")/.." && pwd)
[ -d "$root/.git" ] || exit 0

stamp="$HOME/.freeride/last-update-check"
now=$(date +%s)
last=$(cat "$stamp" 2>/dev/null || echo 0)
[ $((now - last)) -lt 86400 ] 2>/dev/null && exit 0
mkdir -p "$HOME/.freeride" 2>/dev/null && echo "$now" > "$stamp" 2>/dev/null

(git -C "$root" pull --ff-only --quiet >/dev/null 2>&1 &)
exit 0
