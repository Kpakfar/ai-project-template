---
name: init-project
description: Bootstrap a new AI engineering project with the /tdd-pipeline coordination skill, three focused subagents, dev container, and structured documentation. Use this skill whenever a project is uninitialized (no docs/structure.txt or .claude/agents/), when the user says "init", "bootstrap", "set up this project", "/init-project", or describes wanting to start a new project. Interviews the user about stack and scope, then generates AGENTS.md, .claude/skills/tdd-pipeline/, .claude/agents/, docs/, .devcontainer/, and a qa script tailored to the chosen template.
---

# init-project

This skill bootstraps a new project with a structured, agent-driven workflow.

## When this skill runs

- The current directory is empty or contains only a bootstrap `AGENTS.md`.
- The user says: "bootstrap", "init", "set up the project", "/init-project", or similar.
- The user describes wanting to start a new AI engineering project.

## What this skill produces

A fully structured project with:

- `AGENTS.md` and `CLAUDE.md` (symlinked) - the constitution
- `.claude/skills/tdd-pipeline/` - the `/tdd-pipeline` skill: full TDD pipeline in the main context
- `.claude/agents/` - three focused subagents (test-spec-writer, implementer, code-reviewer)
- `.claude/hooks/quality-gate.sh` - deterministic QA hook triggered by code-reviewer
- `docs/` - living documentation (structure, requirements, gotchas, backlog, current-task)
- `.devcontainer/` - portable development environment (if chosen)
- `scripts/qa.sh` - bundled quality checks for the chosen stack
- Stack-specific starter files (pyproject.toml, etc.)

---

## Workflow

### Phase 0: Confirm intent

Before doing anything, confirm with the user:

> "I'm going to bootstrap this project. I'll ask you ~6 questions about scope and stack, then generate the full structure. Continue?"

Wait for explicit confirmation.

### Phase 1: Install supporting skills

If `mattpocock/skills` are not yet installed (check `.claude/skills/` for `grill-me`, `tdd`, etc.):

```bash
npx skills@latest add mattpocock/skills
```

Recommend the user pick at minimum: `grill-me`, `tdd`, `to-prd`, `caveman`, `write-a-skill`, `handoff`. The upstream `tdd` skill is a generic Red→Green→Refactor companion; it does **not** collide with the project-local `/tdd-pipeline` skill (different name).

Skip this step if skills are already present.

### Phase 2: Interview (use grill-me style)

Ask these questions one at a time (or in tight groups of 2-3 if obviously related). Use the `grill-me` skill if available; otherwise mirror its style: probe assumptions, surface trade-offs.

Save answers to a temporary file `docs/_init-answers.md` as you go (this will be deleted after generation).

#### Q1. Project name and one-sentence goal
- What's the project called?
- In one sentence, what does it do and for whom?

Probe: who is the *primary* user? If they list multiple, narrow to one for the MVP. (The workshop pattern: pick one user, one flow, one outcome.)

#### Q2. The core problem
- What problem is this solving that existing tools don't solve well?
- Why now?

This goes into `requirements.md` as the "Why" section.

#### Q3. Stack
Present a menu:

```
  1) python-rag       FastAPI + Postgres + pgvector + OpenAI/Anthropic SDKs (RAG/agents)
  2) python-api       FastAPI + Postgres (plain API, no AI features)
  3) typescript-fullstack  Next.js + tRPC + Drizzle + Postgres
  4) generic          Language-agnostic, you'll fill in commands manually
```

If user is uncertain, recommend based on their answers to Q1-Q2. Don't accept "I don't know" - push for a choice. Bad choices can be changed later; no choice means no progress.

#### Q4. Frontend?
- Will this project have a frontend in this sprint?
  - Yes, full SPA (React/Next/etc.)
  - Yes, minimal (Streamlit, Gradio, plain HTML)
  - No, API-only or notebook-only

#### Q5. Dev container?
- Do you want to run this project in a dev container? (yes / no)
- If yes, what's the base image? Default: matches the stack chosen.

Share these trade-offs so the user can decide:
- **Yes:** isolated environment, reproducible across machines, matches production, and confines what an agent with broad permissions can touch on the host filesystem.
- **No:** simpler setup, no Docker required, easier if you're on a constrained machine or just prototyping.

#### Q6. AI-specific features (for python-rag and python-api with AI)
- Will this project use:
  - RAG (retrieval-augmented generation)? Vector DB choice: pgvector / Chroma / Pinecone
  - LLM agents (multi-step reasoning)?
  - Evals (LLM output testing)?
  - Streaming responses?

Record answers for the requirements.md and to scaffold relevant test categories.

### Phase 3: Confirm the plan

Before generating files, summarize back:

> "Based on your answers, I'll generate:
> - Stack: {stack}
> - Frontend: {frontend or 'none'}
> - Dev container: {yes/no}
> - AI features: {list}
> - Primary user: {user}
> - Core flow: {one-sentence flow}
>
> This will create approximately {N} files. Proceed?"

Wait for confirmation.

### Phase 4: Generate the scaffold

Read the chosen template from `templates/{stack}/` (see structure below). For each file in the template:

1. Read the template file
2. Substitute placeholders (see "Placeholder substitution" below)
3. Write the file to the project root at the corresponding path
4. If the template path is `templates/python-rag/AGENTS.md`, write to `./AGENTS.md`
5. **Skip `.devcontainer/` entirely if `{{USES_DEVCONTAINER}}` is `no`**

After all files are written:

1. Create the `CLAUDE.md` symlink: `ln -s AGENTS.md CLAUDE.md`
   - On Windows without WSL, instead create `CLAUDE.md` as a one-line pointer: `# See @AGENTS.md`
2. Make scripts executable: `chmod +x scripts/qa.sh .claude/hooks/quality-gate.sh`
3. Delete the temp file: `rm docs/_init-answers.md`

### Phase 5: Verify and report

Run a quick sanity check:

```bash
# Verify required files exist
test -f AGENTS.md && \
test -L CLAUDE.md && \
test -d .claude/agents && \
test -d docs && \
test -f scripts/qa.sh
```

If dev container was chosen, recommend the user reopen the project in the container:

> VS Code: Cmd/Ctrl+Shift+P → "Dev Containers: Reopen in Container"

Report what was generated, then hand off:

> "Bootstrap complete. Your project is ready. Next steps:
> 1. Reopen in dev container (if applicable)
> 2. Initialize git: `git add . && git commit -m 'chore: bootstrap project'`
> 3. Start your first task: tell me what you want to build, and I'll route it through `/tdd-pipeline`."

---

## Placeholder substitution

Templates use `{{PLACEHOLDER}}` syntax. Substitute these before writing:

| Placeholder | Replace with |
|---|---|
| `{{PROJECT_NAME}}` | Q1 answer |
| `{{PROJECT_GOAL}}` | Q1 one-sentence goal |
| `{{PRIMARY_USER}}` | Q1 primary user |
| `{{CORE_PROBLEM}}` | Q2 answer |
| `{{STACK}}` | Q3 stack id (e.g. `python-rag`) |
| `{{HAS_FRONTEND}}` | Q4 (`yes-spa` / `yes-minimal` / `no`) |
| `{{USES_DEVCONTAINER}}` | Q5 (`yes` / `no`) |
| `{{VECTOR_DB}}` | Q6 vector DB choice if RAG |
| `{{AI_FEATURES}}` | Q6 comma-separated list |
| `{{DATE}}` | Today's date in ISO format |

---

## Templates directory

This skill ships with templates at `templates/{stack}/`. Each template mirrors the final project structure.

Available templates (see directory listing in this skill's parent):

- `python-rag/` - complete, ready to use
- `python-api/` - stub
- `typescript-fullstack/` - stub
- `generic/` - stub

If user picks a stub template, generate the AGENTS.md and agents/ directory from python-rag, but mark the QA commands and dependencies as TODO for the user to fill in.

---

## Failure modes and how to handle them

**The user can't decide on a stack.**
Default to `python-rag` if they mention AI/RAG/agents/embeddings. Default to `typescript-fullstack` if they mention React/Next/web app with no AI focus. Don't let analysis paralysis block progress.

**The user wants to skip the interview.**
OK, but require minimum answers: project name, stack, dev container yes/no. Skip everything else and generate with sensible defaults. Leave TODO markers in `requirements.md` for them to fill in later.

**The user wants to bootstrap into a non-empty directory.**
Refuse unless they explicitly confirm overwriting. Show what would be overwritten first.

**Skill installation fails (no npm/node).**
Skip Phase 1. The skills are recommended but not required. The `/tdd-pipeline` skill plus the three subagents work without them.

---

## After bootstrap: how the system works

Once bootstrap completes, the project enters normal mode. The agent should:

1. Read `AGENTS.md` on every new conversation
2. Read `docs/structure.txt` and `docs/requirements.md` first when starting work
3. Use `docs/current-task/task.md` as shared memory across agents during a task
4. Run `/tdd-pipeline` for non-trivial tasks; it delegates to the three subagents where useful
5. Update `docs/gotchas.md` when a task surfaces a lesson worth keeping
6. Update `docs/structure.txt` when project layout changes

This skill is no longer needed after bootstrap. It can be deleted from `.claude/skills/` if the user wants to keep the project minimal.
