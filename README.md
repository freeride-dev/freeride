# FreeRide

You build at AI speed. Your project keeps up.

FreeRide is the project workspace built into your AI tools. Each project keeps one living record of everything you build and why. Your agents keep it up to date as they work and check it before they start, so every session begins caught up.

It works in Claude Code, Claude chat and Cowork, Codex, the ChatGPT desktop app and Cursor, all on the same projects. Share a project and your team works from the same picture. Your projects live at [freeride.dev](https://freeride.dev).

Free for individuals. Teams: [freeride.dev/pricing](https://freeride.dev/pricing). Docs: [freeride.dev/docs](https://freeride.dev/docs).

## Install

FreeRide is in review for Claude's, OpenAI's and Cursor's plugin directories. Until it's listed, add it from this repository.

**Claude Code**

```
/plugin marketplace add freeride-dev/freeride
/plugin install freeride@freeride
```

For updates, turn on auto-update once: **/plugin → Marketplaces → freeride → Enable auto-update**.

**Claude chat and Cowork** (paid Claude plans)

1. On claude.ai or in the Claude app, open **Customize → Plugins → Add → Add marketplace → Add from a repository**.
2. Paste `https://github.com/freeride-dev/freeride` and select **Sync**. No need to connect GitHub.
3. Add **FreeRide**. Then click it to open it, go to its **Connectors** tab and select **Connect**.

For updates: **Add → Manage marketplaces**, open **freeride**'s menu and turn on **Sync automatically**. On the free plan, add `https://mcp.freeride.dev/mcp` as a custom connector instead (**Customize → Connectors → Add → Add custom connector**).

**Codex** (the app, the CLI and the ChatGPT desktop app's Work mode)

```
curl -fsSL https://freeride.dev/install/codex.sh | sh
```

It finds Codex (the apps keep their own copy), installs the plugin and signs you in. Restart Codex afterwards. With the Codex CLI you can run the steps yourself:

```
codex plugin marketplace add freeride-dev/freeride
codex plugin add freeride@freeride
codex mcp login freeride
```

**Cursor**

```
git clone https://github.com/freeride-dev/freeride ~/.cursor/plugins/local/freeride
```

Restart Cursor. The plugin updates itself.

## Sign in

The first time FreeRide connects, a browser window opens. Sign in with Google or email and approve. If it doesn't open:

- **Claude Code:** run `/mcp`
- **Claude chat and Cowork:** use the plugin's **Connectors** tab on claude.ai
- **Codex:** run the install command again, or `codex mcp login freeride`
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
