# ai-project-template

A personal project bootstrapper for AI engineering work. Drops a structured, agent-driven workflow into any new project with one command.

## What this gives you

When you start a new project, this template installs a **4-agent workflow** that runs your code through a strict Test-Driven Development pipeline, plus a documentation system that keeps human and agent shared understanding in sync.

```
Empty folder
    │
    ▼
Drop in bootstrap kit  ──►  Open Claude Code  ──►  Say "/init-project"
                                                          │
                                                          ▼
                                  Interview (stack, scope, container, etc.)
                                                          │
                                                          ▼
                                  Generated project: AGENTS.md, .claude/agents/,
                                  docs/, .devcontainer/, qa script, hooks
```

After bootstrap, four agents take over day-to-day work:

| Agent | Role |
|---|---|
| `tdd-orchestrator` | Coordinates the workflow. Delegates, never writes code. |
| `test-spec-writer` | Turns requirements into failing tests. |
| `implementer` | Writes minimal code to pass tests. Refactors after green. |
| `code-reviewer` | Runs the QA gate (`qa` script). Pushes back on quality issues. |

## Quick start

```bash
# 1. Fork this repo on GitHub, then start a new project
mkdir my-project && cd my-project && git init

# 2. Pull in the bootstrap kit (installs AGENTS.md + the init-project skill)
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/ai-project-template/main/bootstrap/install.sh)

# 3. Open Claude Code and run:
#    /init-project
```

> Replace `YOUR_GITHUB_USERNAME` with your GitHub handle after forking.

The init skill will interview you, then generate the project-specific scaffold.

## What's in this repo

```
ai-project-template/
├── bootstrap/                     # The seed kit you drop into new projects
│   ├── AGENTS.bootstrap.md
│   └── install.sh
├── init-project/                  # The skill that does the heavy lifting
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

These are encoded throughout the template:

1. **Dev container by default.** Isolated environment, portable across machines, matches production.
2. **`AGENTS.md` as the constitution.** Single source of truth, symlinked to `CLAUDE.md` for compatibility.
3. **No global installs.** Everything project-local. Dependencies live in `pyproject.toml`, scripts in `scripts/`.
4. **Living docs over dead docs.** `structure.txt` and `gotchas.md` get updated by agents during work.
5. **TDD as the default loop.** Red → Green → Refactor → Review, gated by `qa` script.
6. **Pragmatic escape hatch.** Tasks under ~1h skip plan/review delegation. Don't over-engineer small changes.
7. **Self-improving.** Reviewer logs lessons to `gotchas.md`. Generic lessons get backported to this template manually.

## Extending the template

The `python-rag` template is the most complete. Other templates are stubs. When you need them, flesh them out by:

1. Copying the structure of `python-rag/`
2. Swapping stack-specific files (`.devcontainer/Dockerfile`, `scripts/qa.sh`, `docs/structure.txt`)
3. Adjusting the agent prompts where they mention specific commands

## License

MIT. Use it, fork it, change it.
