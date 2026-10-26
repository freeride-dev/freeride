# Organising a project into areas

An area in FreeRide is a lasting place where work keeps happening and knowledge builds up. Agents log their work to it, and its docs, decisions and ideas are what `begin_work` hands the next agent. So organise for the work to come, not to file away what exists.

## The rules

1. **Organise by where future work and knowledge will gather**, not by code folders or by what happens to exist. Test: "Will someone say 'I'm working on X' in the coming months?"
2. **Start from the team's own groupings.** The strongest signal is how the team already groups its work: headings in feedback rounds, spec sections, ticket or item prefixes, board columns. Fall back to the code's structure only when there aren't any. If the team files the boss stage under "Arenas", it goes under Arenas, whatever the code folders say.
3. **Mix parents and standalone areas freely.**
   - **A parent** groups a real family people think of together: the systems of a game's run, the screens that share one economy, a list of clients, the stages of a pipeline, a set of marketing channels.
   - **A standalone area** is a distinct place with its own life, such as a future app-store release, sound and music, or the test suite.
   - **Don't force everything into a parent.** A parent with only two parts rarely earns its place unless more are clearly coming.
   - Parts can't have parts: one level only. A small project stays flat. There are no fixed numbers.
4. **Parents are containers.** Work goes to the parts, a parent needs at least two real parts, and the parent's implementation doc gives an overview of its area.
5. **Check every area's size, both ways:**
   - **Too fine** (a script, a menu, a small finished capability, a one-off page): make it a section in an area's implementation doc, with its files. Don't create "done" ideas for things that already exist.
   - **Too broad** (it would soak up most of the project's future work and ideas): split it along the line the team works along. One area taking half a project's work makes its context and idea list unusable.
6. **Pick the line the team actually works along:**
   - player-facing areas for a product or game;
   - one area per client for agency or multi-tenant work;
   - stages for a pipeline or system;
   - one per market or league for data work;
   - channels for marketing.

   Cross-cutting concerns (performance, security, testing) can be standalone areas when real work happens on them.
7. **Prefer lasting areas over time-boxed efforts.** A version, round or sprint isn't an area. Its plan goes into the overview's focus, a plan doc, and planned ideas inside the relevant areas. Make an effort an area only when it holds lasting knowledge of its own (a data migration, a long experiment).
8. **Include work that isn't code** when work really happens there: art and sound pipelines, release, operations, marketing, research.
9. **Names are the team's own**: short (one to four words), never code names, and the user's spelling of product terms.

## Stage

Set each area's stage from the code, not from how busy it is. Whether anyone is working on it now (Active or Quiet) FreeRide works out from its last work, which you set from the git history.

- **Live:** in real use, by the product's real users, or by the team for a process (a pipeline, marketing, testing). Work carries on without reopening it. In a launched product, most of the codebase is live.
- **Building:** being built for the first time. In a product that hasn't launched yet (builds go only to the team or playtesters), its product areas are building, even when a build is online.
- **Review:** built but not released or proven: finished behind a flag, waiting on sign-off, or done and waiting for the product's launch.
- **Planned:** committed but not in the code yet, even when it's specced or its assets are made.
- **Backlog:** a real future area nobody has committed to, such as a release channel the team mentions but hasn't started.
- **Archived:** ended, with knowledge worth keeping (a finished migration, a past campaign). Rare in a bootstrap.

A parent has no stage of its own: it shows its parts'.

**Last work.** For every area with history, pass `last_work_at`: the date of the last commit that touched its files or docs, from the history lane. Without it a new project reads Quiet everywhere, because no work has been logged in FreeRide yet.

## Priority

Areas don't take a priority: an area's attention comes from its open ideas. Give each idea its priority instead.

- **Critical:** the current focus.
- **High:** core to the product, or actively worked on.
- **Medium:** the rest that matters.
- **Low:** later or optional.

## Worked example: Elemies (a phone-browser game, agreed 2026-10-24)

| Area | Type |
|---|---|
| **Gameplay**: In-Game · Arenas & Levels · Characters · Tutorial | Parent, 4 parts |
| **Meta Game**: Lobby · Kingdom Maps · Collection · Shop · Rewards & Progression | Parent, 5 parts |
| Art Pipeline · Sound & Music · Engine & Performance · Testing & Release | Standalone |
| App Store Release | Standalone, backlog |

Stages: the game hasn't launched (v0.x builds go to the owner's playtests), so its product areas (Gameplay's and Meta Game's parts, Sound & Music, Engine & Performance) are building. Art Pipeline and Testing & Release are live: the team uses them every day. App Store Release is backlog. All of them read Active, because the whole game was built in the last ten days and `last_work_at` came from the git history.

How it got there:
- **A flat list of 11** risked one huge Gameplay area.
- **Four category parents** filled boxes that weren't families ("Tech & Release", "Art & Sound").
- **A six-way Gameplay split** (Run & Combat, Enemies & Bosses, Levels & Balance…) was the agent's logic. The team's feedback grouped requests as "In-game", "Kingdom Maps", "Lobby", "Collection", "Tutorial", "Arenas" and "Characters", so the map follows those.
- **Small things** (a deploy script, a hidden test menu, a playtest page) became sections of the Testing & Release doc, not areas.
