# Writing what the bootstrap creates

Write for a reader who has never seen the project: plain, short sentences in the team's words. Name people by name, never "the owner" or "the user". An implementation doc has two layers: plain language first, then technical detail under exactly one `### Technical Details`, at the end. Other docs take that heading only when they have code-level detail to set apart. Name files as code (`src/sim/run.ts`). Ground every claim in what you read. Where a repo doc and the code disagree, the code wins. Note the drift if it matters, but don't repeat the stale claim.

Area links: `[@Area name](area:<id>)` when the text matters to that area's work (a cross-area rule, a dependency): with the `@`, the doc also shows up in that area's `begin_work`. The overview's list of parts uses the plain form, `[Area name](area:<id>)`, so it doesn't show up in every area. The old `feature:<id>` still works but isn't for new docs. Docs can use GitHub callouts (`> [!NOTE]`), ```mermaid diagrams, and tables.

## The overview (one per project)

`save_document(type: "overview", area_id: null, title: "<project name>")`, under 5,000 characters:

```
> [!FOCUS]
> <one to three lines: where the project is heading now, what matters most on the way, and the milestone that ends this phase>

## What it is
## Who it's for
## Main parts          (one line each, linked: [Name](area:<id>); parents first, their parts indented)
## How it works        (the shape of the system, briefly)
## Rules               (only if the project has some: budgets, gates, must-nots)
## Where to find more  (the key docs by name, the repo, how to run it)
```

The overview says what the project *is*, never where it stands: no dates, versions or progress notes. FreeRide shows those live. The Focus is direction, not status: if it would need rewriting on every release, it's saying what shipped instead of where the project is going.

## An implementation doc per area

`save_document(area_id, type: "implementation", title: "<Area> — How it works")`. Aim for 1,500–6,000 characters. A parent's doc is shorter and gives an overview of its area, linking its parts.

```
<two or three sentences: what this area is, for the user or player>

## How it works
   The main flow, start to end, in plain words.
## <Part>   (one section per part of the thing, named for the part)
   What that part does, in user terms, and how. Small capabilities inside this
   area get a short section each here, rather than an area of their own.
## Rules and limits
   What it never does, and the numbers that matter. A table for rules and numbers.

### Technical Details
   Under the same part names: key files (a table: file, what it holds), the
   main types and functions, constants that matter, how it connects to other
   areas, and tests.
```

The doc says how the area works now, in the present tense. It has no dates, versions, "new", "now" or "not yet", and no account of what shipped when: the work log and the area's Story keep the history, the where-it-stands note keeps status, and open points are ideas (create them, don't list them in the doc). Later work edits the section about the part it changed, so name sections for parts, never for when something shipped.

## Other docs (from the doc plan)

| Doc | Where | Type |
|---|---|---|
| How the code is built (architecture) | project level | `architecture` |
| Rules and numbers (game design, pricing, limits) | the area that owns them | `guide` |
| How the team works (feedback → spec → build → check → release) | project level | `guide` |
| Plans for work not built yet (the next version's spec) | the area it's for, or project level if it spans several | `backlog` |
| How a flow goes for the person using it (screens, steps, states, the words on them) | the area that owns the flow | `ux_flow` |
| Where the product is going and why (principles, positioning, strategy) | project level | `vision` |
| Project history (only with real milestones) | project level | `guide`, dated |
| Pipelines, release steps, runbooks | the area that owns them, as sections or a `guide` | `guide` |

**Two kinds of doc.** A doc is kept current (it says how things are now, and later work edits it in place) or it's dated: a plan, a design before it's built, research, a review, a list someone gave. A dated doc says what was planned or found as of its date. It follows what's agreed: update it when that changes, and mark it replaced or retired once it's built or dropped. A plan (`backlog`) is saved dated, and so is a doc with a date in its title, except an implementation doc. For any other doc of a moment, pass `dated: true` (or its date, `dated: "2026-07-27"`).

**Repo docs coming in:**
- **A current doc** comes in nearly as it is, as the right type, on the right area, with a last line: `Source: <path> in the repo.` If it's a plan, a design or research of its time, save it dated (`dated: "<date>"`).
- **A plan or design that's already built** isn't brought in as a plan: open plans come up after every piece of work, so a built one is noise. What it built goes into the area docs, and the plan stays in the repo. Only if the team wants it kept in FreeRide, save it dated, then mark it history: `update(document_id, status: "replaced", replaced_by)` when one doc now says how that thing works, else `status: "retired"` with a note naming what built it ("Built in v0.16").
- **A partly stale doc** feeds a rewritten doc instead.
- **A huge layered spec** (versions stacked on versions) is summarised into the current truth, not copied.
- **One-off records** (a feedback round) stay in the repo. Their open points become ideas.

**Implementation docs describe what's built.** A plan for unbuilt work never goes in an implementation doc.

## Writing in parallel

Docs take most of the time. With parallel helpers, split the areas into three to five groups that belong together (a parent with its parts, the production areas, the engine plus the project-level docs) and give each group to one helper with this brief, filled in:

> You're writing FreeRide docs for <project>, as one writer in FreeRide's existing-project bootstrap. Read <path to this writing.md> first and follow it exactly.
> The repo is <path> and it is read-only: no edits, installs, runs, network, or git commands that change anything. Never print secrets. Ground every claim in code or commits you read. Where a repo doc and the code disagree, the code wins.
> Save with `save_document(project_id: "<id>", area_id, type, title)`. Don't create, update or delete anything else in FreeRide. If save_document warns, fix the doc and save again.
> What you need to know: <the facts from the reading lanes that matter for these docs: what the project is, its versions and process, which repo docs are stale and how>.
> Area ids, for links: <every area's name and id>.
> Your docs: <for each: area id, type, title, and what it covers, with the main files to read>.
> When done, report each doc's title, id and length, and every claim you couldn't verify.

Give every helper the whole list of area ids, so their docs can link across groups. Use what they report as unverified in your final report, and turn real loose ends they found into ideas.

## Decisions

Only choices the project states with a reason: in a doc, a commit message, a code comment, an ADR. One decision per choice, on the area it shapes:

```
capture(kind: "decision", project_id, area_id,
  title:        "<what was chosen, as a short sentence>",
  decision:     "<the choice, plainly>",
  context:      "<why, in the source's words where possible>\n\nSource: <file:line or commit hash>",
  alternatives: "<what was rejected, if the source says>")
```

Skip trivial choices (a lint setting, a variable name). Prefer the ones that would stop a newcomer or an agent from undoing something on purpose.

## Ideas

Few and good: real open points, plans and loose ends, not every TODO. One per item, on its area:

```
create(kind: "backlog_item", project_id, area_id,
  title:       "<the item, as the team would say it>",
  description: "<what and why, plainly>\n\nSource: <file:line, doc section or commit>",
  priority:    critical | high | medium | low)
```

- **Planned work.** Set `status: "planned"` only when the source puts it on the team's agenda (the next version's spec or list). Everything else stays open. A roadmap with several phases: plan only the next decided phase; later phases stay in the plan doc. Add `due` only when the source gives that planned work a date that's still ahead ("ships Nov 15"); never infer one from a version number or a sprint. One piece of planned work is one item, its steps a checklist in its description; when the source splits it into pieces with their own dates or people, make it a plan: one planned item with `steps` (create with steps), never a planned item per piece.
- **Already-built capabilities never become ideas.**
- **Item codes.** When the team numbers its items ("G-28"), keep the number in the title.
