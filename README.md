# ai-project-template

A project bootstrapper for engineering work. Drops a structured, TDD-driven, CI-gated workflow into any new project with one command. Stack-agnostic core; language and tooling choices live in the bootstrap interview, not in the template files.

## What this gives you

```
Empty folder
    │
    ▼
bash <(curl install.sh)  ──►  Open Claude Code  ──►  /init-project
   [checks: curl, npx, git]                              │
                                                         ▼
                              Interview (scope, language, tooling,
                                container, AI features, etc.)
                                                         │
                                                         ▼
                              Generated project:
                                AGENTS.md, 3 subagents,
                                docs/, qa script, hooks,
                                .mcp.json (Context7),
                                .github/workflows/qa.yml (CI),
                                pull_request_template.md,
                                .pre-commit-config.yaml,
                                language manifest + installed deps
```

The bootstrap **validates generic prerequisites** (curl, git, npx). The `/init-project` skill **picks the stack and provisions the project**.

After bootstrap, day-to-day work runs through the upstream `tdd` skill (from `mattpocock/skills`, installed during bootstrap) plus three subagents:

| | Name | Role |
|---|---|---|
| skill (upstream) | `tdd` | Red -> Green -> Refactor methodology, invoked in main context |
| subagent | `@test-spec-writer` | Writes failing tests for complex specs |
| subagent | `@implementer` | Makes tests pass for large implementations |
| subagent | `@code-reviewer` | Runs the quality-gate. Has a `Stop` hook that runs the gate after the review and blocks completion (exit code 2) if it fails |

The main-context driver (you, in Claude Code) orchestrates the pipeline. Subagents are called only when a phase is complex enough to warrant isolation. The main agent can override each subagent's model per call (`haiku`, `sonnet`, `opus`) to match cost to complexity.

The same quality-gate command runs locally (via the `Stop` hook) and remotely (via GitHub Actions on push and pull request). A red CI = a blocked merge.

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

`/init-project` interviews you about scope and stack, then generates the full scaffold including CI, PR template, pre-commit config, and a working environment for the chosen language.

## What's in this repo

```
ai-project-template/
├── bootstrap/                     # Seed kit, dropped into new projects by install.sh
│   ├── AGENTS.md                  # the bootstrap-mode AGENTS.md (lands as ./AGENTS.md)
│   └── install.sh                 # validates env, drops AGENTS.md, installs the skill
├── init-project/                  # /init-project skill, interviews + generates scaffold
│   ├── SKILL.md                   # interview, placeholder substitution, language profiles
│   └── templates/
│       └── python-rag/            # The stack-agnostic core template (name is historical)
│                                  # Contents use {{PLACEHOLDERS}} that SKILL.md substitutes
│                                  # from interview answers + the chosen language profile.
└── docs/
    └── how-to-use.md
```

## Design principles

1. **Stack-agnostic core.** Every file in `templates/python-rag/` is written in language-neutral terms with `{{PLACEHOLDERS}}` for language-specific commands and tools. Stack choices live in the interview, not the template.
2. **Language profiles in the skill.** `init-project/SKILL.md` has a `<language-profiles>` section with the full set of placeholder values per language. Python is fully supported today; TypeScript, Rust, and Go are placeholder slots.
3. **Upstream skill, local subagents.** The `tdd` skill comes from `mattpocock/skills`. The template provides 3 focused subagents that pair with it. Main context orchestrates; subagents are escape hatches for complex phases.
4. **`AGENTS.md` as the constitution.** Single source of truth, symlinked to `CLAUDE.md` for Claude Code compatibility. Includes a hard `<architecture-discipline>` rule set: two-layer split, one concept per file (~100 lines, hard cap 200), prompts as files, no premature abstraction.
5. **Quality gate everywhere.** The same `{{QA_COMMAND}}` runs locally (code-reviewer `Stop` hook), pre-commit (optional), and CI (`.github/workflows/qa.yml`).
6. **Context7 baked in.** `.mcp.json` ships with Context7 MCP wired up. Agents query Context7 for live, version-specific library docs rather than relying on training memory.
7. **Per-call model override.** Each subagent has a default model, but the main agent can override per invocation. Match cost to complexity.
8. **Dev container optional.** The init skill explains the trade-offs and asks; no default forced on you.
9. **No global installs.** Everything project-local. Dependencies in the language's manifest file. Scripts in `scripts/` or `[project.scripts]` equivalent.
10. **Living docs.** `structure.txt`, `gotchas.md`, and `language-standards.md` stay current; agents update them as they work.
11. **TDD as the default loop.** Red -> Green -> Refactor -> Review, gated by `{{QA_COMMAND}}`.
12. **Pragmatic escape hatch.** Tasks under ~1h skip subagent delegation. Trivial changes skip TDD entirely.
13. **Self-improving.** `code-reviewer` logs lessons to `gotchas.md`. Generic lessons get backported to this template.

## Adding a new language profile

Edit `init-project/SKILL.md`, find the `<language-profiles>` section, add a new YAML block alongside the Python one with the same shape (language_version, package_manager, manifest_file, install_command, qa_command, ci_setup_steps, precommit_hooks, library_docs_urls, notes). Once added, `/init-project` will offer it as a choice.

## License

MIT. Use it, change it.
