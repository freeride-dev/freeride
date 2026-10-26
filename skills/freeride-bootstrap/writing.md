# Writing what the bootstrap creates

Write for a reader who has never seen the project: plain, short sentences in the team's words. Every doc, guides and plans included, has two layers: plain language first, then technical detail under exactly `### Technical Details`. FreeRide warns when that heading is missing; fix the doc and save it again. Name files as code (`src/sim/run.ts`). Ground every claim in what you read. Where a repo doc and the code disagree, the code wins. Note the drift if it matters, but don't repeat the stale claim.

Area links: `[@Area name](area:<id>)` when the text matters to that area's work (a cross-area rule, a dependency): with the `@`, the doc also shows up in that area's `begin_work`. The overview's list of parts uses the plain form, `[Area name](area:<id>)`, so it doesn't show up in every area. The old `feature:<id>` still works but isn't for new docs. Docs can use GitHub callouts (`> [!NOTE]`), ```mermaid diagrams, and tables.

## The overview (one per project)

`save_document(type: "overview", feature_id: null, title: "<project name>")`, under 5,000 characters:

```
> [!FOCUS]
> <one or two lines: what the project is working toward now>

## What it is
## Who it's for
## Main parts          (one line each, linked: [Name](area:<id>); parents first, their parts indented)
## How it works        (the shape of the system, briefly)
## Rules               (only if the project has some: budgets, gates, must-nots)
## Where to find more  (the key docs by name, the repo, how to run it)
```

The overview says what the project *is*, never where it stands: no dates, versions or progress notes. FreeRide shows those live.

## An implementation doc per area

`save_document(feature_id, type: "implementation", title: "<Area> — How it works")`. Aim for 1,500–6,000 characters. A parent's doc is shorter and gives an overview of its area, linking its parts.

```
<two or three sentences: what this area is, for the user or player>

## What it does
   The behaviour, in user terms. Small capabilities inside this area get a
   short section each here, rather than an area of their own.
## How it works
   The mechanism, plainly. A table for rules and numbers.
## Where it came from
   When it started, how it grew (versions or milestones), recent activity, and
   who works on it. From git; dates are fine here.
## Open points
   Known gaps, drift between docs and code, and loose ends, each with its source.
   Point to the ideas created for them.

### Technical Details
   Key files (a table: file, what it holds), the main types and functions,
   constants that matter, how it connects to other areas, and tests.
```

## Other docs (from the doc plan)

| Doc | Where | Type |
|---|---|---|
| How the code is built (architecture) | project level | `architecture` |
| Rules and numbers (game design, pricing, limits) | the area that owns them | `guide` |
| How the team works (feedback → spec → build → check → release) | project level | `guide` |
| Plans for work not built yet (the next version's spec) | the area it's for, or project level if it spans several | `backlog` |
| Project history (only with real milestones) | project level | `guide` |
| Pipelines, release steps, runbooks | the area that owns them, as sections or a `guide` | `guide` |

**Repo docs coming in:**
- **A current doc** comes in nearly as it is, as the right type, on the right area, with a last line: `Source: <path> in the repo, checked against the code on <date>.`
- **A partly stale doc** feeds a rewritten doc instead.
- **A huge layered spec** (versions stacked on versions) is summarised into the current truth, not copied.
- **One-off records** (a feedback round) stay in the repo. Their open points become ideas.

**Implementation docs describe what's built.** A plan for unbuilt work never goes in an implementation doc.

## Writing in parallel

Docs take most of the time. With parallel helpers, split the areas into three to five groups that belong together (a parent with its parts, the production areas, the engine plus the project-level docs) and give each group to one helper with this brief, filled in:

> You're writing FreeRide docs for <project>, as one writer in FreeRide's existing-project bootstrap. Read <path to this writing.md> first and follow it exactly.
> The repo is <path> and it is read-only: no edits, installs, runs, network, or git commands that change anything. Never print secrets. Ground every claim in code or commits you read. Where a repo doc and the code disagree, the code wins.
> Save with `save_document(project_id: "<id>", feature_id, type, title)`. Don't create, update or delete anything else in FreeRide. If save_document warns, fix the doc and save again.
> What you need to know: <the facts from the reading lanes that matter for these docs: what the project is, its versions and process, which repo docs are stale and how>.
> Area ids, for links: <every area's name and id>.
> Your docs: <for each: area id, type, title, and what it covers, with the main files to read>.
> When done, report each doc's title, id and length, and every claim you couldn't verify.

Give every helper the whole list of area ids, so their docs can link across groups. Use what they report as unverified in your final report, and turn real loose ends they found into ideas.

## Decisions

Only choices the project states with a reason: in a doc, a commit message, a code comment, an ADR. One decision per choice, on the area it shapes:

```
capture(kind: "decision", project_id, feature_id,
  title:        "<what was chosen, as a short sentence>",
  decision:     "<the choice, plainly>",
  context:      "<why, in the source's words where possible>\n\nSource: <file:line or commit hash>",
  alternatives: "<what was rejected, if the source says>")
```

Skip trivial choices (a lint setting, a variable name). Prefer the ones that would stop a newcomer or an agent from undoing something on purpose.

## Ideas

Few and good: real open points, plans and loose ends, not every TODO. One per item, on its area:

```
create(kind: "backlog_item", project_id, feature_id,
  title:       "<the item, as the team would say it>",
  description: "<what and why, plainly>\n\nSource: <file:line, doc section or commit>",
  priority:    critical | high | medium | low)
```

- **Planned work.** Set `status: "planned"` only when the source puts it on the team's agenda (the next version's spec or list). Everything else stays open.
- **Already-built capabilities never become ideas.**
- **Item codes.** When the team numbers its items ("G-28"), keep the number in the title.
