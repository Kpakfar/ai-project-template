# ai-project-template

A project bootstrapper for AI engineering work. Drops a structured, TDD-driven workflow into any new project with one command.

## What this gives you

```
Empty folder
    │
    ▼
bash <(curl install.sh)  ──►  Open Claude Code  ──►  /init-project
   [checks: uv, npx, git]                                  │
                                                           ▼
                                   Interview (stack, scope, container, etc.)
                                                           │
                                                           ▼
                                   Generated project: AGENTS.md, 3 subagents,
                                   docs/, qa script, hooks, .mcp.json (Context7)
                                                           │
                                                           ▼
                                   uv sync (deps installed, venv ready)
```

The bootstrap **validates the environment** (uv, npx, git all present). The `/init-project` skill **provisions the project** (scaffold + venv).

After bootstrap, day-to-day work runs through the upstream `tdd` skill (from `mattpocock/skills`, installed during bootstrap) plus three subagents:

| | Name | Role |
|---|---|---|
| skill (upstream) | `tdd` | Red → Green → Refactor methodology, invoked in main context |
| subagent | `@test-spec-writer` | Writes failing tests for complex specs |
| subagent | `@implementer` | Makes tests pass for large implementations |
| subagent | `@code-reviewer` | Runs the QA gate. Has a `Stop` hook that runs `uv run qa` after the review and blocks completion (exit code 2) if it fails |

The main-context driver (you, in Claude Code) orchestrates the pipeline. Subagents are called only when a phase is complex enough to warrant isolation. The main agent can override each subagent's model per call (`haiku`, `sonnet`, `opus`) to match cost to complexity.

## Quick start

```bash
# 1. Start a new project
mkdir my-project && cd my-project && git init

# 2. Pull in the bootstrap kit (installs AGENTS.md + the /init-project skill)
bash <(curl -fsSL https://raw.githubusercontent.com/Kpakfar/ai-project-template/main/bootstrap/install.sh)

# 3. Open Claude Code, then run:
#    npx skills@latest add mattpocock/skills   (pick at minimum: tdd, grill-me, to-prd, caveman, write-a-skill, handoff)
#    /init-project
```

The init skill interviews you (~6 questions), then generates the full scaffold including `.mcp.json` wired up to Context7 for live library docs lookup.

## What's in this repo

```
ai-project-template/
├── bootstrap/                     # Seed kit, dropped into new projects by install.sh
│   ├── AGENTS.md                  # the bootstrap-mode AGENTS.md (lands as ./AGENTS.md)
│   └── install.sh
├── init-project/                  # /init-project skill, interviews + generates scaffold
│   ├── SKILL.md
│   └── templates/
│       ├── python-rag/            # Primary template (FastAPI + pgvector RAG)
│       ├── python-api/            # (stub) plain FastAPI
│       ├── typescript-fullstack/  # (stub) Next.js + tRPC
│       └── generic/               # (stub) language-agnostic
└── docs/
    └── how-to-use.md
```

## Design principles

1. **Upstream skill, local subagents.** The `tdd` skill comes from `mattpocock/skills`. The template provides 3 focused subagents that pair with it. Main context orchestrates; subagents are escape hatches for complex phases.
2. **`AGENTS.md` as the constitution.** Single source of truth, symlinked to `CLAUDE.md` for Claude Code compatibility.
3. **Context7 baked in.** `.mcp.json` ships with Context7 MCP wired up. Agents query Context7 for live, version-specific library docs rather than relying on training memory.
4. **Per-call model override.** Each subagent has a default model, but the main agent can override per invocation (`haiku` for trivial, `opus` for tricky). Match cost to complexity.
5. **Dev container optional.** The init skill explains the trade-offs and asks: no default forced on you.
6. **No global installs.** Everything project-local. Dependencies in `pyproject.toml`, scripts in `scripts/`.
7. **Living docs over dead docs.** `structure.txt` and `gotchas.md` stay current: agents update them as they work.
8. **TDD as the default loop.** Red → Green → Refactor → Review, gated by `uv run qa`.
9. **Pragmatic escape hatch.** Tasks under ~1h skip subagent delegation. Trivial changes skip TDD entirely.
10. **Self-improving.** `code-reviewer` logs lessons to `gotchas.md`. Generic lessons get backported to this template.

## Extending the template

The `python-rag` template is the most complete. Other templates are stubs. To flesh one out:

1. Copy `python-rag/` as a base
2. Swap stack-specific files (`Dockerfile`, `scripts/qa.sh`, `docs/structure.txt`, `pyproject.toml.example`)
3. Adjust the subagent prompts where they reference Python-specific commands
4. Keep `.mcp.json` (Context7 is stack-agnostic) unless you have a reason not to

## License

MIT. Use it, change it.
