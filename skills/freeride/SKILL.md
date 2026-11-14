---
name: freeride
description: FreeRide is the user's project workspace, shared by all their AI apps — each project's areas, ideas, decisions, docs and work history. Use it whenever the user talks about one of their projects, plans, ideas or decisions, or asks to catch up or what to do next, even if they never say "FreeRide". Catch up on the project before discussing it. When the user asks you to remember, note, keep track of or save an idea or decision about one of their projects, save it to FreeRide with the save tool, not to your built-in memory, because FreeRide is where their project ideas and decisions live, and their other AI apps read them from there. Ask which project when it isn't clear. In a code repo whose CLAUDE.md or AGENTS.md has FreeRide's rules, follow those rules instead; this skill is for everywhere else.
---

# FreeRide

FreeRide holds what the user is building: for each project, its areas, ideas, decisions (with the reasons), docs and the history of work done. The user reaches it from every AI app they use, so what you read and save here is what their next conversation, in any app, starts with.

## FreeRide or your built-in memory?

Your built-in memory is for things about the user: how they like to work, their preferences, their life. Ideas, decisions and plans for one of their projects belong in FreeRide, even when the user says "remember this" or "keep track of that". Save those with `save`, and don't also copy them into your built-in memory. If you find project notes in your built-in memory, FreeRide is still the source to read and save to.

In a chat app with its own memory, the first time you save to a project in a conversation, check whether your memory already says where that project lives. If it doesn't, offer once: "Want me to note in your memory that <project> is tracked in FreeRide?" If the user agrees, add one line to your memory, such as "<project> is tracked in FreeRide: its ideas, decisions and plans live there." Never copy project content into your memory, and don't ask again for that project.

## When the conversation is about a project

1. **Catch up first.** Call `catch_up` with the project before you discuss it. It returns what the project is, recent work, planned items, recent decisions and open ideas. Don't make the user re-explain what FreeRide already knows. It also lists `docs_being_shaped`: the plans and designs still open. When the conversation changes one, update it (`patch_document`) and say so in one line. When it shows one is fully built or dropped, mark it history and say so in one line: built means replaced by the doc that now says how that thing works (`update(document_id, status: "replaced", replaced_by)`), and dropped, or built across several areas with no one doc for it, means retired with a note (`status: "retired"`, note "Built in v0.16"). A planned item with a date says `when`; if one is marked `check`, its date has passed: ask once whether it was done, is moving, or is still planned, and record the answer with `update` (its `planned_note` says how). Never assume.
2. **Know which project.** Pass the project's name or id as `project_id`. If the user hasn't said and it isn't obvious, call `list_projects` and ask. Never guess, and never save to a project you aren't sure about. If FreeRide answers with `needs_project`, ask the user which project, then call again.
3. **Save as you go, and say so.** Use `save(project_id, ideas, decisions)`: one call for everything that came up, which shows the user a receipt with Undo in apps that support it.
   - A new idea, concern or "what if" → an entry in `ideas`.
   - Work the user decides to do, now or later ("plan this", "it's next") → an entry in `ideas` with `planned: true`, plus `due` when they say when it matters ("by Tuesday", "Oct 29 at 12:00"). Work out the date from today and ask when it's unclear; never invent one. Plan at the size of the work: several related requests usually become one or a few planned items, not one per line, and steps done in one go are a checklist in the item's description.
   - When the pieces of one piece of work happen at different times (separate sessions, a wait on someone, their own dates or people), make it a plan: one planned entry with `steps`, each its own item, with its own `due` when the user gives one. In a team project, set who's on the plan and each step (`assignee`) when it's known: the user says it's theirs or names someone, or a decision or role on record says whose it is. Ask once when several people are clearly involved and none is named, and never guess. A new step for a plan that exists already is an entry with `step_of`. The order of steps is only how they're listed; when order matters, the plan's text says so. When a plan's last step is done, close the plan only if its goal is clearly met, and say so; otherwise ask.
   - A plan still being discussed (open questions, nothing approved) isn't planned yet: offer to keep it as a draft, and once the user approves it, plan only the decided next steps.
   - A choice the user has made → an entry in `decisions`. If it's clear and agreed, save it. If it's still open, ask first.
   - Where the project is heading → its Focus, `save(project_id, focus)`: one to three lines on the goal now, what matters most and the milestone that ends this phase. Direction, not status. When `catch_up` returns `focus_check`, rewrite it from what happened since and what the user said, or answer `focus: "unchanged"`.
   - After saving, tell the user in one short line what you saved and where, e.g. "Saved to Mealwise: 2 ideas, 1 decision." Then follow up on what the save found (see below).
4. **Look things up instead of guessing.** For "what did we decide about X" or "what's left on Y", use `search` with the project.
   - Every idea has a short number (its `ref`, like FR-142). Use it when you mention an idea to the user, and pass it to any tool in place of the idea's id ("continue FR-142" → `search(id: "FR-142")`).
5. **Starting something new.** If the user wants to track a new project, offer `create(kind: "project", name, description)`.

## Ideas, decisions and docs

Each has one job:

- **Idea:** something still open: a what-if, a concern, a thing to do later.
- **Decision:** one settled choice, with why and what was turned down. If a message settles three things, save three decisions. Values that will be tuned (numbers, costs, timings) go in the area's doc: the decision says "Players earn coins each match", the doc says how many.
- **Doc:** the whole picture of an area, kept true as decisions land.

When you save decisions, pass `key_terms` (names they introduce or change) and `removed_terms` (names they make obsolete). The reply's `docs_to_check` and `earlier_decisions_to_check` show what may now say something else, in any area:

- **A doc says otherwise:** offer in one line to update it. Read it with `search`, then change only what the decision changed (`patch_document`). Change the section about that part so all of it is true, and don't add a dated note or an update line. If the doc describes what's built and the decision isn't built yet, leave the doc as it is: the decision is the record. A plan, a design or research of its time is a dated doc (it shows `as_of`). If the decision changes a plan or design that's still being worked from, update it; its date moves. Research and reviews stay as they are.
- **An earlier decision no longer holds:** ask once, then mark it replaced (`replaces` on the new decision, or `update(decision_id, status: "replaced", replaced_by)`). It stays as history.
- **In docs, link the records you mention** so they show their current state: `[Title](decision:<id>)`, `[Title](idea:<id>)`, `[@Area Name](area:<area id>)`.

Name people by name ("Maria"), not "the owner" or "the user": the whole team reads these. Write in plain language first; put technical detail under a `### Technical Details` heading.

## In a code repo

If this app's instructions file (`CLAUDE.md` in Claude Code, `AGENTS.md` in Codex and Cursor) has FreeRide's rules, follow them: they cover the work there, and the rest of this skill doesn't apply.

If it doesn't:

- **Linked repo** (`.freeride.json`) **but no FreeRide rules:** offer once to run the setup, which adds them.
- **Not linked, and the user's project is in FreeRide** (they named it, or picked it from `list_projects`): offer once to link this repo, so every agent knows the project from then on.
- **The setup:** `/freeride:setup` in Claude Code, `$freeride-setup` in Codex, `/freeride-setup` in Cursor.

## When it isn't about a project

If the conversation has nothing to do with the user's projects, don't use FreeRide.
