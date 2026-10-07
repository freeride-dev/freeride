---
name: freeride
description: FreeRide is the user's project workspace, shared by all their AI apps — each project's features, ideas, decisions, docs and work history. Use it whenever the user talks about one of their projects, plans, ideas or decisions, or asks to catch up or what to do next, even if they never say "FreeRide". Catch up on the project before discussing it. When the user asks you to remember, note, keep track of or save an idea or decision about one of their projects, save it to FreeRide with the save tool, not to your built-in memory, because FreeRide is where their project ideas and decisions live, and their other AI apps read them from there. Ask which project when it isn't clear.
---

# FreeRide

FreeRide holds what the user is building: for each project, its features, ideas, decisions (with the reasons), docs and the history of work done. The user reaches it from every AI app they use, so what you read and save here is what their next conversation, in any app, starts with.

## FreeRide or your built-in memory?

Your built-in memory is for things about the user: how they like to work, their preferences, their life. Ideas, decisions and plans for one of their projects belong in FreeRide, even when the user says "remember this" or "keep track of that". Save those with `save`, and don't also copy them into your built-in memory. If you find project notes in your built-in memory, FreeRide is still the source to read and save to.

In a chat app with its own memory, the first time you save to a project in a conversation, check whether your memory already says where that project lives. If it doesn't, offer once: "Want me to note in your memory that <project> is tracked in FreeRide?" If the user agrees, add one line to your memory, such as "<project> is tracked in FreeRide: its ideas, decisions and plans live there." Never copy project content into your memory, and don't ask again for that project.

## When the conversation is about a project

1. **Catch up first.** Call `catch_up` with the project before you discuss it. It returns what the project is, recent work, planned items, recent decisions and open ideas. Don't make the user re-explain what FreeRide already knows.
2. **Know which project.** Pass the project's name or id as `project_id`. If the user hasn't said and it isn't obvious, call `list_projects` and ask. Never guess, and never save to a project you aren't sure about. If FreeRide answers with `needs_project`, ask the user which project, then call again.
3. **Save as you go, and say so.** Use `save(project_id, ideas, decisions)`: one call for everything that came up, which shows the user a receipt with Undo in apps that support it.
   - A new idea, concern or "what if" → an entry in `ideas`.
   - A choice the user has made → an entry in `decisions`. If it's clear and agreed, save it. If it's still open, ask first.
   - After saving, tell the user in one short line what you saved and where, e.g. "Saved to Mealwise: 2 ideas, 1 decision."
4. **Look things up instead of guessing.** For "what did we decide about X" or "what's left on Y", use `search` with the project.
5. **Starting something new.** If the user wants to track a new project, offer `create(kind: "project", name, description)`.

Write saved text in plain language first; put technical detail under a `### Technical Details` heading. To point at another feature, write `[@Feature Name](feature:<feature id>)`.

## When you're building in a repo linked to FreeRide

The repo's CLAUDE.md or AGENTS.md (or the FreeRide plugin, if the repo has no FreeRide block) gives the full workflow:

- `start_session` before your first response, every conversation.
- `begin_work(feature_id)` before substantial work on a feature.
- `complete_work(feature_id, summary)` after meaningful progress, then `confirm_docs`.
- `end_session` when the user is done.

Linked repo (`.freeride.json`) but no FreeRide block in this app's instructions file (`CLAUDE.md` in Claude Code, `AGENTS.md` in Codex and Cursor)? Offer once to run the setup, which adds it.

Working in a repo with no `.freeride.json` and the user's project turns out to be in FreeRide (they named it, or picked it from `list_projects`)? Offer once to link this repo, so every agent knows the project from then on. If they agree, run the setup.

To link a repo to a FreeRide project, or switch an older FreeRide setup to the plugin: in Claude Code the user runs `/freeride:setup`; in Codex and Cursor, use the `freeride-setup` skill.

## When it isn't about a project

If the conversation has nothing to do with the user's projects, don't use FreeRide.
