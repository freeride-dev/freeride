---
name: freeride-bootstrap
description: Turn an existing codebase into a fully organised FreeRide project in one session (areas with parts, an overview with its focus, code-checked docs, decisions with their sources, and ideas), so the user, their team and every agent start from the whole picture instead of an empty project. Use when the user asks to set up, fill, organise or bootstrap a FreeRide project from an existing repo, or runs /freeride:bootstrap. When start_session reports an empty project (is_empty) and this repo holds a real, substantial codebase, offer it once; never run it without a yes. Not for a brand-new or nearly empty repo, where the project fills up as work happens.
---

# Bootstrap a FreeRide project from an existing codebase

You turn a codebase that FreeRide doesn't know yet into a project people can understand at a glance, and agents can work from. **Read everything first and write nothing. Stop once, to get the area map approved. Then build it all and report.**

Two readers use what you build:
- **People** want the picture: what this is, its parts, where each stands, what's next, and why things are the way they are. Someone who has never seen the project should understand it from the FreeRide dashboard in ten minutes.
- **Agents** start work on one part with `begin_work`, which hands them that area's docs, decisions and ideas. So knowledge goes on the area it belongs to, not into one big summary.

## Ground rules

- **The repo is read-only.** Never edit, commit, push, install or run the project. Never print secrets: if a key or token appears, name the file only. The one exception is linking the repo to its project in step 0, with the user's yes: FreeRide's setup writes `.freeride.json` and the FreeRide block in the agent instructions file, and nothing else.
- **Nothing false.** Every claim comes from a file you read, a commit, or the user's own words. When unsure, say so or leave it out. Wrong docs are worse than none.
- **The team's words, not yours.** Names, groupings and descriptions follow how the team already talks about the project.
- **One stop only.** No questions before or while you read. Make every call you can yourself, and put doubts in the final "check these first" list instead of interrupting.

## 0. Check it's the right job

1. **Which project?** Use the project the repo is linked to (`.freeride.json`), or the one the user named. If there's none, offer `create(kind: "project", name, description)`. Pass `project_id` on every FreeRide call.
2. **Link the repo and start a session.** If the repo has no `.freeride.json`, offer to link it, so every later session here knows the project: run FreeRide's setup (`/freeride:setup` in Claude Code, the `freeride-setup` skill in Codex and Cursor). Then make sure your FreeRide session is in this project: call `start_session(project_id)` unless one already is. A session started before the project existed belongs elsewhere, so start a new one. Without it, the bootstrap's own work log lands in the wrong place or nowhere.
3. **Is the copy current?** Someone may be working in this repo right now, and the local copy can be behind. Run `git fetch` (it only updates what the repo knows about its remote, never the files), then `git rev-list --left-right --count HEAD...@{u}` and `git status --short`.
   - **Behind the remote:** read the remote's version (`@{u}`), not the folder: `git ls-tree -r @{u}`, `git show @{u}:<path>`, `git log @{u}`. Tell every reading lane which version to read. Say so in your opening lines ("your copy is 3 commits behind GitHub; I'm reading GitHub's version").
   - **Uncommitted or unpushed changes:** someone's work in progress. Read it as in progress, never as shipped, and mention it.
   - **No remote, or fetch fails:** read the folder and say the copy may not be the latest.
4. **Is the project empty?** Run `search(kind: "features", brief: true)` (it lists the project's areas). If it already has areas, say so. This version fills empty projects. Offer to add only what's missing, reusing the existing areas, and never create a duplicate.
5. **Is there a real codebase?** A fresh scaffold or a nearly empty repo isn't a bootstrap case. Say so and stop: the project will fill up as work happens.
6. **Tell the user what's coming** in two lines: you'll read the project (roughly how long, from its size), stop once to show them the map, then build it all.

## 1. Read the project (read-only)

Follow [reading.md](reading.md), reading the version step 0 chose. It covers five lanes: product and structure, existing docs checked against the code, git history, tools and operations, and plans and loose ends. If your app can run parallel helpers (subagents), give each lane to one, using the briefs there word for word. If it can't, read lane by lane. Keep each tool read small: some apps cap tool output.

Skip what isn't knowledge: images, audio, 3D models, fonts, generated code, vendored libraries, lockfiles, build output, `node_modules`. Keep a list of what you skipped or only sampled, and why.

## 2. Organise

Follow [organising.md](organising.md) to turn what you read into areas: when to make a parent with parts, when to leave an area standalone, when something is only a section of a doc, how to set stages, and which ideas get which priority. Start from the team's own groupings (headings in their feedback, specs, tickets or boards), then check the size of every area both ways.

## 3. The one stop: show the picture

Send one message, in this order. Nothing is written to FreeRide before the user answers.

1. **What the project really is**, in two or three plain lines, plus the stack. If the user's picture of it was off (they called it a mobile app and it's a website), correct that first.
2. **The area map** as a tree: parents with their parts, then standalone areas. For each: a one-line scope, its stage with the evidence (for example "live: in the store since v0.9, 30 commits in the last two weeks", or "building: v0.x, only playtested so far"), and the date of its last work.
3. **A suggested focus**: one or two lines on what the project is working toward now, from recent activity and plans.
4. **The doc plan**: which repo docs come into FreeRide (checked, nearly as they are), which feed new docs, which are stale, which stay in the repo only (READMEs and other files the repo itself needs), and the new docs you'll write.
5. **Every decision** you'll record, one line each, with its source (file and line, or commit).
6. **Every idea** you'll create, one line each, with its area, priority and source.
7. **What you didn't read** and why, and **outside sources** the repo points to but you couldn't reach: an issue tracker, a numbered list of requests that lives elsewhere, a design board. Say whether you reached them.
8. **Up to four optional questions** only a person can answer, such as whether the focus is right, what the team calls something, or whether something that looks active was dropped. Say that "looks good" or "go with your best guess" are full answers.

Accept the user's corrections to names, grouping, stages or lists, and apply them. If they say "best guess", go ahead and mark your guesses in the final report.

## 4. Build (after the yes)

Follow [writing.md](writing.md) for every doc, decision and idea. Build in this order, so the user can open the dashboard early and watch it fill in. Docs are the slow part: with parallel helpers, hand them out as writing.md describes, and save the decisions and ideas (steps 5 and 6) yourself while the helpers write.

1. **Areas.**
   - Create parents first, then their parts with `parent_id`, then standalone areas: `create(kind: "feature", name, description, icon, color, parent_id, last_work_at)` (the tool's kind for an area), with `last_work_at` from the history lane. Don't pass a priority: areas don't take one. Give each parent and standalone area its own colour, one that suits it where one does (violet for sound, amber for payments), with no repeats while colours last. Parts take their parent's.
   - An area that doesn't exist in the code yet gets `status: "planned"`.
   - An area being built for the first time: `update(feature_id, status: "building")` right away (`feature_id` is the area's id).
   - A shipped area becomes live (or review) in step 3, after its implementation doc exists: FreeRide only lets an area be marked live or review once it has one.
   - **Parents get no stage.** Skip them in every status update, here and in step 3: a parent shows its parts' roll-up.
2. **The overview**: `save_document(type: "overview", feature_id: null)`. Under 5,000 characters, opening with the focus block. See writing.md.
3. **One implementation doc per area**, parents included: `save_document(feature_id, type: "implementation")`. Then `update(feature_id, status: "live")` or `"review"` for the finished parts and standalone areas (never a parent). FreeRide's overview check will then list them as changed since the overview was written. The overview says what the project is, not where it stands, so when `complete_work` (step 7) returns that check, answer it in `confirm_docs` with `overview: {action: "still_accurate", note: "Written in this bootstrap; it describes the project, not stages."}`, alongside the `feature_id`, `action` and `details` confirm_docs always takes.
4. **The other docs** from the doc plan: architecture, rules and numbers, how the team works, plans for work not built yet, and a project history if the repo has real milestones.
5. **Decisions**: `capture(kind: "decision", feature_id, title, context, decision, alternatives)`, with the source named in the context.
6. **Ideas**: `create(kind: "backlog_item", feature_id, title, description, priority)`, plus `status: "planned"` for the ones on the team's agenda (see writing.md), with the source named in the description.
7. **Record the bootstrap**: one `complete_work` on the most central area, saying what was set up and from what. It's the first entry in the project's story. Answer the checks it returns with `confirm_docs`, as in step 3.

If a call fails, note it and carry on. Never invent a workaround that bypasses FreeRide's tools.

## 5. Report

Keep it short and in this order:
1. **What was created**: counts of areas, docs, decisions and ideas, and the map with final stages.
2. **Check these first**: your guesses, anything uncertain, and the areas or docs most likely to need a human eye.
3. **What wasn't read**, and the outside sources not reached.
4. **What FreeRide couldn't do yet**, if anything got in the way (for example, mapping files to areas).
5. **Where to look**: the project on the dashboard (freeride.dev), and that `begin_work` on any area now gives an agent that area's context.
