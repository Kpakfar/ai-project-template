---
name: init-project
description: Bootstrap a new project with three focused subagents, a quality-gate hook, Context7 MCP, CI workflow, PR template, pre-commit config, dev container, and structured documentation. Stack-agnostic at its core: language and tooling choices live in this skill's interview, not in the template files. Use this skill whenever a project is uninitialized (no docs/structure.txt or .claude/agents/), when the user says "init", "bootstrap", "set up this project", "/init-project", or describes wanting to start a new AI engineering project. Interviews the user about scope and stack, then generates AGENTS.md, .claude/agents/, .mcp.json, docs/, .github/, .devcontainer/, scripts/, and a manifest tailored to the chosen language. Pairs with the upstream `tdd` skill from mattpocock/skills, which is installed during bootstrap.
---

# init-project

This skill bootstraps a new project with a structured, agent-driven workflow. The template's contents are stack-agnostic; all language and tooling choices are made through this skill's interview, then substituted into placeholders at generation time.

## When this skill runs

- The current directory is empty or contains only a bootstrap `AGENTS.md`.
- The user says: "bootstrap", "init", "set up the project", "/init-project", or similar.
- The user describes wanting to start a new project.

## What this skill produces

A fully structured project with:

- `AGENTS.md` and `CLAUDE.md` (symlinked): the constitution, stack-agnostic core
- `.claude/agents/`: three focused subagents (test-spec-writer, implementer, code-reviewer)
- `.claude/hooks/quality-gate.sh`: deterministic QA hook triggered by code-reviewer
- `.mcp.json`: Context7 MCP server for live library docs
- `.github/workflows/qa.yml`: CI running the quality-gate command on every push and pull request
- `.github/pull_request_template.md`: short PR checklist
- `.pre-commit-config.yaml`: local pre-commit hooks (language-specific portion populated from your profile)
- `docs/`: living documentation (structure, requirements, language-standards, gotchas, backlog, current-task)
- `.devcontainer/`: portable development environment (if chosen)
- `scripts/`: bundled quality-gate runner for the chosen language
- `{{MANIFEST_FILE}}`: dependency + tool config + bundled scripts entry
- A working venv / node_modules / equivalent via the chosen package manager (skipped if dev container is chosen; deps install inside the container instead)

The TDD methodology is provided by the upstream `tdd` skill from `mattpocock/skills`, installed during this skill's Phase 1. The 3 subagents pair with it: main context drives, subagents are escape hatches for complex phases.

---

## Workflow

### Phase 0: Confirm intent

Before doing anything, confirm with the user:

> "I'm going to bootstrap this project. I'll ask you a few questions about scope and stack, then generate the full structure. Continue?"

Wait for explicit confirmation.

### Phase 1: Install supporting skills (REQUIRED)

The `tdd` skill from `mattpocock/skills` is **required**, not optional. The 3 subagents pair with it.

If `mattpocock/skills` are not yet installed (check `.claude/skills/` for `tdd`, `grill-me`, etc.):

```bash
npx skills@latest add mattpocock/skills
```

Required skills (must be installed): `tdd`, `grill-me`, `to-prd`, `caveman`, `write-a-skill`, `handoff`.

After the user picks them in the skills picker, verify `tdd` is present before proceeding. If the user refuses or skips, stop and explain why bootstrap cannot continue without `tdd`.

### Phase 2: Interview

Ask these questions one at a time (or in tight groups of 2-3 if obviously related). Use the `grill-me` skill if available; otherwise mirror its style: probe assumptions, surface trade-offs.

Save answers to a temporary file `docs/_init-answers.md` as you go (this will be deleted after generation).

#### Q1. Project name and one-sentence goal
- What's the project called?
- In one sentence, what does it do and for whom?

Probe: who is the *primary* user? If they list multiple, narrow to one for the MVP.

#### Q2. The core problem
- What problem is this solving that existing tools don't solve well?
- Why now?

#### Q3. Language

```
  1) Python       (uv, ruff, mypy, pytest) [fully supported]
  2) TypeScript   (pnpm/npm, eslint, tsc, vitest) [profile TODO]
  3) Rust         (cargo, clippy, rustfmt) [profile TODO]
  4) Go           (go mod, golangci-lint, go test) [profile TODO]
  5) Other        (manual setup)
```

For now, only Python has a complete language profile (see `<language-profiles>` section below). For other languages, generate the stack-agnostic core and leave TODO markers in `docs/language-standards.md` and `.github/workflows/qa.yml` for the user to fill in.

#### Q4. Frontend

- Will this project have a frontend in this sprint?
  - **yes-spa**: full SPA (React, Next, Vue, etc.)
  - **yes-minimal**: Streamlit, Gradio, plain HTML
  - **no**: API-only or notebook-only

#### Q5. Backend framework (if applicable)

Depends on language choice. Example for Python: FastAPI / Streamlit-only / Flask / none. Example for TypeScript: Next.js / Express / Fastify / none.

#### Q6. AI features

- Will this project use:
  - RAG (retrieval-augmented generation)? Vector DB choice: pgvector / Chroma / Pinecone / Qdrant
  - LLM agents (multi-step reasoning)?
  - Evals (LLM output testing)?
  - Streaming responses?

Record answers for `requirements.md` and to scaffold relevant test categories.

#### Q7. LLM provider and embeddings model
- Provider: OpenAI / Anthropic / Google / Together / OpenRouter / local (Ollama / LM Studio) / multiple via a router
- Embeddings model: name (e.g. `text-embedding-3-small`, `bge-large-en-v1.5`)

#### Q8. Database / persistence (if applicable)
- None / SQLite / Postgres / DuckDB / KV store / file-based

#### Q9. Dev container?
- Do you want to run this project in a dev container? (yes / no)
- If yes, base image defaults to the language profile's recommendation.

Trade-offs:
- **Yes:** isolated environment, reproducible across machines, matches production, and confines what an agent with broad permissions can touch on the host filesystem.
- **No:** simpler setup, no Docker required, easier if you're on a constrained machine or just prototyping.

### Phase 3: Confirm the plan

Before generating files, summarize back:

> "Based on your answers, I'll generate:
> - Language: {language}
> - Frontend: {frontend or 'none'}
> - Backend framework: {framework or 'none'}
> - Dev container: {yes/no}
> - AI features: {list}
> - LLM provider: {provider}
> - Primary user: {user}
> - Core flow: {one-sentence flow}
>
> This will create approximately {N} files. Proceed?"

Wait for confirmation.

### Phase 4: Generate the scaffold

Read the template from `templates/python-rag/` (the directory name is historical; its contents are stack-agnostic). For each file in the template:

1. Read the template file
2. Substitute placeholders (see "Placeholder substitution" + the language profile below)
3. Write the file to the project root at the corresponding path
4. **Skip `.devcontainer/` entirely if `{{USES_DEVCONTAINER}}` is `no`**

Beyond the verbatim template files, generate language-specific artefacts from the language profile:

- The manifest file (`pyproject.toml` for Python, `package.json` for TS, `Cargo.toml` for Rust, `go.mod` for Go)
- The `scripts/qa.sh` (or equivalent) runner that chains the project's lint/format/type/test commands
- The `[project.scripts]` (or equivalent) entry that exposes `qa` as a callable
- The `LANGUAGE_PRECOMMIT_HOOKS` block in `.pre-commit-config.yaml`
- The `CI_SETUP_STEPS` block in `.github/workflows/qa.yml`
- The `.gitignore` language-specific additions

After all files are written:

1. Create the `CLAUDE.md` symlink: `ln -s AGENTS.md CLAUDE.md`
   - On Windows without WSL, instead create `CLAUDE.md` as a one-line pointer: `# See @AGENTS.md`
2. Make scripts executable: `chmod +x scripts/qa.sh .claude/hooks/quality-gate.sh`
3. Delete the temp file: `rm docs/_init-answers.md`

### Phase 4.5: Install dependencies

If `{{USES_DEVCONTAINER}}` is `no`:

1. Verify the chosen package manager is available (the bootstrap should have caught this for known languages; verify again here for safety).
2. Run `{{INSTALL_COMMAND}}` to install deps from the manifest file.
3. Smoke-test:
   - Python: `uv run python -c "import sys; print(f'Python {sys.version.split()[0]} venv ready')"`
   - TypeScript: `node -e "console.log('Node ' + process.version + ' ready')"`
   - Rust: `cargo --version`
   - Go: `go version`
4. If install fails, leave the scaffold in place (do not roll back). Report the failing dep and ask the user to fix the manifest then re-run install.

If `{{USES_DEVCONTAINER}}` is `yes`: **skip** this phase. Deps will install inside the container.

### Phase 5: Verify and report

Run a quick sanity check:

```bash
test -f AGENTS.md && \
test -L CLAUDE.md && \
test -d .claude/agents && \
test -f .mcp.json && \
test -f .github/workflows/qa.yml && \
test -f .github/pull_request_template.md && \
test -f .pre-commit-config.yaml && \
test -d docs && \
test -f docs/language-standards.md
```

Report what was generated, then hand off:

> "Bootstrap complete. Your project is ready. Next steps:
> 1. {{If dev container}}: Reopen in dev container, then run `{{INSTALL_COMMAND}}` inside. {{Else}}: Venv/deps are already installed; you can run `{{QA_COMMAND}}` to verify.
> 2. Initialize git: `git add . && git commit -m 'chore: bootstrap project'`. Push to enable CI.
> 3. Restart Claude Code so `.mcp.json` (Context7) registers.
> 4. Start your first task."

---

## Placeholder substitution

Templates use `{{PLACEHOLDER}}` syntax. Substitute these before writing.

### Universal placeholders (asked or derived)

| Placeholder | Source |
|---|---|
| `{{PROJECT_NAME}}` | Q1 |
| `{{PROJECT_GOAL}}` | Q1 |
| `{{PRIMARY_USER}}` | Q1 |
| `{{CORE_PROBLEM}}` | Q2 |
| `{{LANGUAGE}}` | Q3 |
| `{{HAS_FRONTEND}}` | Q4 |
| `{{BACKEND_FRAMEWORK}}` | Q5 |
| `{{AI_FEATURES}}` | Q6 (comma-separated) |
| `{{VECTOR_DB}}` | Q6 |
| `{{LLM_PROVIDER}}` | Q7 |
| `{{EMBEDDINGS_MODEL}}` | Q7 |
| `{{DATABASE}}` | Q8 |
| `{{USES_DEVCONTAINER}}` | Q9 (`yes`/`no`) |
| `{{DATE}}` | today, ISO format |

### Language-derived placeholders (from the profile)

| Placeholder | Filled from language profile |
|---|---|
| `{{LANGUAGE_VERSION}}` | profile.language_version |
| `{{PACKAGE_MANAGER}}` | profile.package_manager |
| `{{MANIFEST_FILE}}` | profile.manifest_file |
| `{{INSTALL_COMMAND}}` | profile.install_command |
| `{{ADD_DEP_COMMAND}}` | profile.add_dep_command |
| `{{QA_COMMAND}}` | profile.qa_command |
| `{{TEST_RUNNER}}` | profile.test_runner |
| `{{TEST_COMMAND}}` | profile.test_command |
| `{{LINT_TOOL}}` | profile.lint_tool |
| `{{LINT_COMMAND}}` | profile.lint_command |
| `{{FORMAT_TOOL}}` | profile.format_tool |
| `{{FORMAT_COMMAND}}` | profile.format_command |
| `{{TYPE_TOOL}}` | profile.type_tool |
| `{{TYPE_COMMAND}}` | profile.type_command |
| `{{LANG_EXT}}` | profile.file_extension (e.g. `py`, `ts`) |
| `{{PRECOMMIT_INSTALL_COMMAND}}` | profile.precommit_install_command |
| `{{CI_SETUP_STEPS}}` | profile.ci_setup_steps (multi-line YAML block) |
| `{{LANGUAGE_PRECOMMIT_HOOKS}}` | profile.precommit_hooks (multi-line YAML block) |
| `{{LIBRARY_DOCS_URLS}}` | profile.library_docs_urls (markdown list) |
| `{{TYPE_ANNOTATION_NOTES}}` | profile.notes.type_annotations |
| `{{IMPORT_NOTES}}` | profile.notes.imports |
| `{{ASYNC_NOTES}}` | profile.notes.async |
| `{{ERROR_NOTES}}` | profile.notes.errors |
| `{{CONFIG_NOTES}}` | profile.notes.config |
| `{{LOGGING_NOTES}}` | profile.notes.logging |
| `{{TEST_LAYOUT_NOTES}}` | profile.notes.test_layout |
| `{{PRECOMMIT_HOOKS_NOTES}}` | profile.notes.precommit_hooks |

---

## Language profiles

### Python (fully supported)

```yaml
language_version: "3.12+"
file_extension: "py"
package_manager: "uv"
manifest_file: "pyproject.toml"
install_command: "uv sync"
add_dep_command: "uv add"
qa_command: "uv run qa"
test_runner: "pytest"
test_command: "uv run pytest"
lint_tool: "ruff"
lint_command: "uv run ruff check . --fix"
format_tool: "ruff format"
format_command: "uv run ruff format ."
type_tool: "mypy"
type_command: "uv run mypy src/"
precommit_install_command: "uv run pre-commit install"

ci_setup_steps: |
  - name: Set up uv
    uses: astral-sh/setup-uv@v3
    with:
      enable-cache: true
  - name: Set up Python
    run: uv python install 3.12
  - name: Install deps
    run: uv sync

precommit_hooks: |
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.8.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

library_docs_urls: |
  ### Core stack
  - **uv**: https://docs.astral.sh/uv/
  - **ruff**: https://docs.astral.sh/ruff/
  - **mypy**: https://mypy.readthedocs.io/
  - **pytest**: https://docs.pytest.org/
  - **Pydantic v2**: https://docs.pydantic.dev/latest/
  - **pydantic-settings**: https://docs.pydantic.dev/latest/concepts/pydantic_settings/

  ### AI / RAG (use Context7 first)
  - **OpenAI SDK**: https://github.com/openai/openai-python
  - **Anthropic SDK**: https://github.com/anthropics/anthropic-sdk-python
  - **LangChain**: https://python.langchain.com/docs/introduction/
  - **Chroma**: https://docs.trychroma.com/
  - **pgvector**: https://github.com/pgvector/pgvector

  ### Frontend (if applicable)
  - **Streamlit**: https://docs.streamlit.io/
  - **Gradio**: https://www.gradio.app/docs

notes:
  type_annotations: |
    - Python 3.12+ syntax: `list[int]` not `List[int]`. `dict[str, X]` not `Dict[str, X]`.
    - Every function signature fully typed, including return types.
    - `from __future__ import annotations` at the top of every module.
  imports: |
    - Order: stdlib -> third-party -> local. Sorted by ruff (`I` rule set).
    - One module per import line for stdlib and third-party.
  async: |
    - All I/O (HTTP, DB, LLM) must be `async`.
    - Use `asyncio.TaskGroup` (Python 3.11+) for concurrent work.
  errors: |
    - Specific exception classes per domain. Never bare `Exception`.
    - Fail-closed on safety/security: if uncertain, refuse rather than proceed.
  config: |
    - `pydantic-settings` for all configuration.
    - Never hardcode API keys, URLs, or model names. Pull from env or settings.
  logging: |
    - `logging` module, not `print`.
    - Structured log lines (JSON if going to ingest, key=value otherwise).
  test_layout: |
    - `tests/` mirrors `src/` structure.
    - Use `pytest-asyncio` for async tests.
    - `factory-boy` or hand-rolled fixtures in `tests/fixtures/` for data.
    - `hypothesis` for property-based tests on pure functions.
  precommit_hooks: |
    - `ruff` (with `--fix`) and `ruff-format`.
    - The generic hooks (trailing-whitespace, yaml/toml/json validation, large-file guard) are always included.
```

### Other languages (TODO)

For TypeScript, Rust, Go, and "Other": generate the stack-agnostic core and leave TODO markers in:
- `docs/language-standards.md` (every section)
- `.github/workflows/qa.yml` (the `{{CI_SETUP_STEPS}}` block)
- `.pre-commit-config.yaml` (the `{{LANGUAGE_PRECOMMIT_HOOKS}}` block)
- `{{MANIFEST_FILE}}` is not generated; user creates it themselves
- `scripts/qa.sh` contains placeholders: `echo "TODO: lint"`, etc.

Tell the user clearly: "Only Python has a full profile. For {{LANGUAGE}}, I've left TODO markers in the noted files. Fill them in based on your toolchain choices."

---

## Failure modes and how to handle them

**The user can't decide on a language.**
Default to Python (the only fully-supported profile). Don't let analysis paralysis block progress.

**The user wants to skip the interview.**
OK, but require minimum answers: project name, language, dev container yes/no. Skip everything else and generate with sensible defaults. Leave TODO markers in `requirements.md` for them to fill in later.

**The user wants to bootstrap into a non-empty directory.**
Refuse unless they explicitly confirm overwriting. Show what would be overwritten first.

**Skill installation fails (no npm/node).**
This is a hard failure. The `tdd` skill is required. Stop and ask the user to install Node.js, then re-run.

**Package manager not available for chosen language.**
Stop with a clear install link for the chosen language's package manager (`uv`, `pnpm`, `cargo`, `go`).

**Context7 MCP fails to start after bootstrap.**
Check that `npx` is available. The Context7 server in `.mcp.json` uses `npx -y @upstash/context7-mcp@latest`. If npx is broken, document the failure in `docs/gotchas.md` and instruct the user to either fix npx or remove the Context7 entry from `.mcp.json`.

---

## After bootstrap: how the system works

Once bootstrap completes, the project enters normal mode. The agent should:

1. Read `AGENTS.md` on every new conversation
2. Read `docs/structure.txt`, `docs/requirements.md`, and `docs/language-standards.md` first when starting work
3. Use `docs/current-task/task.md` as shared memory across agents during a task
4. Use the upstream `tdd` skill (mattpocock/skills) for the Red to Green to Refactor methodology
5. Delegate to subagents (`@test-spec-writer`, `@implementer`, `@code-reviewer`) only for phases complex enough to warrant isolation
6. Override subagent models per call (`model: haiku | sonnet | opus` in the Agent invocation) to match cost to complexity
7. Query Context7 (via the `.mcp.json` MCP server) for library API details rather than relying on training memory
8. Update `docs/gotchas.md` when a task surfaces a lesson worth keeping
9. Update `docs/structure.txt` when project layout changes

This skill is no longer needed after bootstrap. It can be deleted from `.claude/skills/` if the user wants to keep the project minimal.
