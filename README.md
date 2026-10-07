# FreeRide

Your AI tools start every session knowing your project, and keep it up to date as they work.

FreeRide keeps one record per project: the features you're building, the decisions you made and why, your ideas, docs, and a history of the work. It lives in the cloud, so every AI app you use reads and writes the same project.

Your coding agent opens each session already caught up and logs its own work. In chat, ask for a catch-up or save an idea, and it's there in your next coding session.

Share a project with your team and everyone's agents work from the same picture. A web dashboard at [freeride.dev](https://freeride.dev) shows where everything stands.

This repo is the FreeRide plugin for Claude (Claude Code, Claude chat, Cowork), Codex and Cursor. Docs: [freeride.dev/docs](https://freeride.dev/docs).

## Install

**Claude Code**

```
/plugin marketplace add freeride-dev/freeride
/plugin install freeride@freeride
```

**Claude chat and Cowork:** on claude.ai, go to **Customize → Plugins → Add → Add marketplace**, enter `freeride-dev/freeride` and install **FreeRide**. Then open the plugin's **Connectors** tab and connect FreeRide.

**Codex**

```
codex plugin marketplace add freeride-dev/freeride
```

Then install **FreeRide** from Plugins in the Codex app (or `/plugins` in the CLI).

**Cursor:** open **Customize** in the sidebar, find **FreeRide** and select **Install**. If it isn't listed yet, install it by hand:

```
git clone https://github.com/freeride-dev/freeride ~/freeride-plugin
mkdir -p ~/.cursor/plugins/local
cp -R ~/freeride-plugin ~/.cursor/plugins/local/freeride
```

Restart Cursor. Copy the folder; Cursor ignores a symlink here.

## Sign in

The first time FreeRide connects, a browser window opens. Sign in with Google or email and approve.

- **Claude Code:** if you're not asked, run `/mcp` and pick the FreeRide server.
- **claude.ai:** the plugin's **Connectors** tab. If the Claude Desktop app is connected, connect FreeRide there too (**Settings → Connectors**).
- **Codex:** when asked, or `codex mcp login freeride`.
- **Cursor:** **Authenticate** next to the freeride server on the plugin's page.

## Link a repo

In Claude Code: `/freeride:setup`. In Codex or Cursor, ask: *"Set up FreeRide for this repo."*

Setup writes `.freeride.json` (the project's id, no secrets) and adds FreeRide's rules to `CLAUDE.md` and `AGENTS.md`, so the repo works in every agent. It shows every change and asks once. Commit the files; teammates are then linked too.

Chat needs no linking: name the project ("catch me up on Mealwise").

## What's inside

- **Connection** to the FreeRide server (`https://mcp.freeride.dev/mcp`).
- **Skills:** `freeride` (when and how to use FreeRide, in any app) and `freeride-setup` (repo setup for Codex and Cursor).
- **Hooks** for coding agents: rules at session start when a repo lacks them, and short nudges to log work. They never force a tool call.
- **Commands** (Claude Code): `/freeride:setup` and `/freeride:status`.

## License

MIT
