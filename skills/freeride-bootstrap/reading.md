# Reading the project

Five lanes. With parallel helpers (subagents), give each lane to one helper with the brief below, word for word, plus the repo path and the project's apparent kind. Without helpers, work through them in order. Each lane is read-only: no edits, no installs, no running the project, no network, and no git command that changes anything. Never print secrets: name the file instead.

Every lane reports **facts with their sources** (file and line, or commit hash), marks anything unclear as unclear, and lists what it skipped or only sampled.

## Lane 1: Product and structure

> Read the README, the manifests (package.json, pyproject, Cargo.toml, project settings and the like), the entry points, and every top-level source folder enough to describe it accurately, reading the biggest modules properly. Report:
> 1. What the project is, in two or three lines, in its users' terms (players, customers, operators).
> 2. The user-facing areas or capabilities the code actually has. For each: what it does for the user, the files that implement it, and how complete it is (complete, partial or stub), with the evidence.
> 3. The technical shape in one paragraph: how the main parts relate.
> 4. The words the code and docs use for things, the team's vocabulary.
> 5. Code comments that state a reason or a choice ("because…", "we chose…", "don't… since…"): up to 15, quoted with file:line.
> 6. TODO, FIXME and HACK comments that matter, with file:line.
> 7. Anything a newcomer must know, including dead code or two systems doing the same job.

## Lane 2: Existing docs, checked against the code

> Cover every doc: README files at any depth, docs/ or wiki folders, ADRs, specs, CHANGELOG, feedback or meeting notes, and any other .md, .mdx, .txt or .rst outside dependencies. For each, get its history with `git log --format='%ad %s' --date=short -- <path>`. Report:
> 1. Per doc: what it covers, when it last changed, its size, and whether it's still true. For the substantial ones, check 5–10 concrete claims (numbers, names, paths, rules, flows) against the code, and give a verdict (current, partly stale or stale) listing each drift as "doc says X, code does Y".
> 2. Lasting knowledge (design rules, architecture, specs, how-tos) versus one-off records (a feedback round, meeting notes). For each doc, whether it should come into FreeRide nearly as it is, feed a new doc, or stay in the repo only (for example a README the repo itself needs).
> 3. How the team groups its work: the headings of feedback rounds, spec sections, ticket or item prefixes. Quote the headings exactly.
> 4. Decisions with stated reasons ("we chose X because Y", "not X since Y", picked options), quoted with location.
> 5. Open items, plans and proposed defaults, each marked done, in progress or not started in the code, with the evidence.
> 6. References to sources outside the repo: issue numbers, item codes (like "G-28" or "JIRA-12"), linked boards or sheets, chat threads.

## Lane 3: History (git)

> Use only read-only git commands (log, show, shortlog, branch -r, tag, diff). Report:
> 1. The timeline: versions, releases, tags and phases, one line each, with what each delivered and any change of direction (an engine switch, a rewrite) and its stated reason.
> 2. Per area of the project: when it started, the date it was last touched, how much churn, and a stage call (live, building or planned) with the evidence. Something specced or with assets made but no code is planned. Something that exists but isn't in real use yet is building, including every product area of a product that hasn't launched (builds only for the team or playtesters). In real use by real users, or a process the team uses, is live, however busy it is. Say whether the product has launched, and the evidence.
> 3. What's happening now: the last days of work in detail, and what the newest plan or spec asks for versus what's already in the code. Suggest the project's current focus in one or two lines.
> 4. Who: the people and accounts, who works on which areas, and whether commits are written by agents for someone (co-author lines, "the user's…" voice).
> 5. Decisions with reasons stated in commit messages, quoted with hash.
> 6. Loose ends: reverted work, abandoned approaches, experiments, things kept for later, open branches.

## Lane 4: Tools and operations

> Read the tooling (scripts and tools folders, build and deploy configs, CI workflows, infrastructure files), the test setup, the asset folders (by structure and size, never their contents), and how things get from development to users. Don't run anything. Report:
> 1. Each tool or pipeline: what it does, its inputs and outputs, the outside services it uses, how mature it looks, and any cost or credit tracking.
> 2. Release: how the project reaches its users and testers, and what's automated versus manual.
> 3. Quality: what the tests cover, the gates before a commit or release, anything notable.
> 4. Assets and budgets: what kinds, how big, and any limits the code enforces.
> 5. Decisions with reasons in configs and tools, quoted with file:line.
> 6. Loose ends and risks: manual steps, half-finished tools, missing gates, anything secret-looking committed (path only).

## Lane 5: Plans and loose ends

Usually covered by lanes 2 to 4. Run it as its own lane when the repo has a tracker you can read (for example `gh issue list` and `gh pr list` with a GitHub CLI that's signed in), a roadmap file, or a board export.

> List open issues and pull requests, roadmap items and planned work, each with its source. Group them by the area they belong to. Mark which ones are already done in the code.

If a tracker exists but you can't reach it, say so in the report. Don't guess its contents.
