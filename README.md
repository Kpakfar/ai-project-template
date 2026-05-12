# ai-project-template

A project bootstrapper for AI engineering work. Drops a structured, TDD-driven workflow into any new project with one command.

## What this gives you

```
Empty folder
    │
    ▼
bash <(curl install.sh)  ──►  Open Claude Code  ──►  /init-project
                                                           │
                                                           ▼
                                   Interview (stack, scope, container, etc.)
                                                           │
                                                           ▼
                                   Generated project: AGENTS.md, /tdd skill,
                                   subagents, docs/, qa script, hooks
```

After bootstrap, day-to-day work runs through one skill and three subagents:

| | Name | Role |
|---|---|---|
| skill | `/tdd` | Runs the full pipeline in the main context: explore → spec → implement → refactor → review |
| subagent | `@test-spec-writer` | Writes failing tests for complex specs |
| subagent | `@implementer` | Makes tests pass for large implementations |
| subagent | `@code-reviewer` | Runs the QA gate. Has a `Stop` hook that enforces `uv run qa` automatically |

The `/tdd` skill stays in the main conversation — context from exploration is alive during implementation. Subagents are called only when a phase is complex enough to warrant isolation.

## Quick start

```bash
# 1. Start a new project
mkdir my-project && cd my-project && git init

# 2. Pull in the bootstrap kit (installs AGENTS.md + the /init-project skill)
bash <(curl -fsSL https://raw.githubusercontent.com/Kpakfar/ai-project-template/main/bootstrap/install.sh)

# 3. Open Claude Code and run:
#    /init-project
```

The init skill interviews you (~6 questions), then generates the full scaffold.

## What's in this repo

```
ai-project-template/
├── bootstrap/                     # Seed kit — dropped into new projects by install.sh
│   ├── AGENTS.bootstrap.md
│   └── install.sh
├── init-project/                  # /init-project skill — interviews + generates scaffold
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

1. **Skill for coordination, subagents for specialisation.** The `/tdd` skill runs the pipeline in the main context. Subagents are called only for phases that need isolation or have hooks.
2. **`AGENTS.md` as the constitution.** Single source of truth, symlinked to `CLAUDE.md` for Claude Code compatibility.
3. **Dev container optional.** The init skill explains the trade-offs and asks — no default forced on you.
4. **No global installs.** Everything project-local. Dependencies in `pyproject.toml`, scripts in `scripts/`.
5. **Living docs over dead docs.** `structure.txt` and `gotchas.md` stay current — agents update them as they work.
6. **TDD as the default loop.** Red → Green → Refactor → Review, gated by `uv run qa`.
7. **Pragmatic escape hatch.** Tasks under ~1h skip delegation. Trivial changes skip `/tdd` entirely.
8. **Self-improving.** `code-reviewer` logs lessons to `gotchas.md`. Generic lessons get backported to this template.

## Extending the template

The `python-rag` template is the most complete. Other templates are stubs. To flesh one out:

1. Copy `python-rag/` as a base
2. Swap stack-specific files (`Dockerfile`, `scripts/qa.sh`, `docs/structure.txt`, `pyproject.toml.example`)
3. Adjust the subagent prompts where they reference Python-specific commands

## License

MIT. Use it, change it.
