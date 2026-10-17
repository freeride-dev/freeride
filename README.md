# FreeRide

You build at AI speed. Your project keeps up.

FreeRide is the project workspace built into your AI tools. Each project keeps one living record of everything you build and why. Your agents keep it up to date as they work and check it before they start, so every session begins caught up.

It works in Claude Code, Claude chat and Cowork, Codex, the ChatGPT desktop app and Cursor, all on the same projects. Share a project and your team works from the same picture. Your projects live at [freeride.dev](https://freeride.dev).

Free for individuals. Teams: [freeride.dev/pricing](https://freeride.dev/pricing). Docs: [freeride.dev/docs](https://freeride.dev/docs).

## Install

**Claude Code**

```
/plugin marketplace add freeride-dev/freeride
/plugin install freeride@freeride
```

**Claude chat and Cowork:** on claude.ai, go to **Customize → Plugins → Add → Add marketplace**, enter `freeride-dev/freeride` and install **FreeRide**. Then connect it in the plugin's **Connectors** tab.

**Codex** (also covers Work mode in the ChatGPT desktop app)

```
codex plugin marketplace add freeride-dev/freeride
```

Then install **FreeRide** from Plugins in the Codex app, or `/plugins` in the CLI.

**Cursor**

```
git clone https://github.com/freeride-dev/freeride ~/.cursor/plugins/local/freeride
```

Restart Cursor. The plugin updates itself.

## Sign in

The first time FreeRide connects, a browser window opens. Sign in with Google or email and approve. If it doesn't open:

- **Claude Code:** run `/mcp`
- **Claude chat and Cowork:** use the plugin's **Connectors** tab on claude.ai
- **Codex:** run `codex mcp login freeride`
- **Cursor:** select **Authenticate** on FreeRide in **Customize**

## Set up a repo

Once per repo, in any coding app: `/freeride:setup` in Claude Code, `$freeride-setup` in Codex, `/freeride-setup` in Cursor. Or ask your agent to set up FreeRide.

Setup links the repo to a project and adds FreeRide's rules to `CLAUDE.md` and `AGENTS.md`. It shows every change first. Commit the result and your teammates are set up too.

Chat and Cowork need no setup. Just name the project.

## What's inside

- A connection to the FreeRide server
- Skills that tell your agent when and how to use FreeRide
- Hooks for coding agents: session-start context and short reminders to log work, never forced
- Commands in Claude Code: `/freeride:setup` and `/freeride:status`

## License

MIT
