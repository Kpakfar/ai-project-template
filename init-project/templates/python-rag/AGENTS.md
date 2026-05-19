<development-process>
- Dev container: {{USES_DEVCONTAINER}}. If yes, all commands run inside the container: do not install anything globally on the host.
- Always start by reading `docs/structure.txt` and `docs/requirements.md` in parallel to orient yourself.
- Always consult `docs/documentation.md` for links to library docs. Prefer Context7 (see below) for live API lookups.
- If you encounter unfamiliar libraries, APIs, or patterns, research online before guessing. Fetch the actual documentation.
- Work in this directory/repo only. Never touch files outside this repo unless explicitly instructed.
- It is your responsibility to manage the environment and install any new dependencies as needed (add to `pyproject.toml`, run `uv sync`).
- Bundled scripts live under `[project.scripts]` in `pyproject.toml`. The one that ships with this template is `uv run qa` (lint + format + types + tests). Add more scripts there and they become `uv run <name>`.
</development-process>

<global-documents>
- `docs/structure.txt` : project map (folders, what each is for). Update when layout changes.
- `docs/requirements.md` : what we're building, for whom, why. Domain model and stack.
- `docs/documentation.md` : direct links to library docs the agent should consult.
- `docs/backlog.md` : scoped, queued tasks. Reviewed continuously.
- `docs/proposals-ideas.md` : out-of-scope or future ideas. Reviewed every ~2 weeks.
- `docs/gotchas.md` : known pitfalls, anti-patterns, lessons learned. Living document. Update after every task that surfaces something worth keeping.
</global-documents>

<task-specific-documents>
- `docs/current-task/task.md` : coordination document for the active task. Shared memory between agents.
- `docs/current-task/task-template.md` : template to reset `task.md` when starting a new task.

When starting a new task, copy `task-template.md` over `task.md` and fill it in. When the task is done, archive the contents (move to a project log or commit message) before resetting.
</task-specific-documents>

<library-docs>
This project ships with **Context7 MCP** wired up via `.mcp.json`. Context7 provides up-to-date, version-specific library documentation.

**When to use it (always)**: any time you write or modify code that touches a third-party library. Training-data memory will be off in subtle ways, especially for fast-moving libraries (LangChain, Pydantic v2, OpenAI SDK, Streamlit, FastAPI).

**How to use it**:
- Before writing the code, query Context7 for the relevant API of the **pinned version** in `pyproject.toml`, not the latest available.
- For Streamlit: look up `st.chat_message`, `st.chat_input`, `st.session_state`, `st.file_uploader`, `st.plotly_chart`.
- For LangChain: verify `EnsembleRetriever`, `BM25Retriever`, `RecursiveCharacterTextSplitter`, LCEL chain composition.
- For Pydantic v2: verify field validators, `model_validate`, config classes; the v2 API is unstable across minor versions.
- For the OpenAI SDK: verify `chat.completions.create`, `chat.completions.parse`, and `extra_body` for OpenRouter passthrough.

**Rule**: do not write code from training-data memory for these libraries. If Context7 returns nothing useful for a query, say so in your summary and propose a fallback (e.g., a smaller, safer call signature, or a WebFetch of the upstream docs).
</library-docs>

<tools>
- Use `uv` for all Python dependency and script management. Never `pip install` directly.
- Use `ruff` for linting and formatting (configured in `pyproject.toml`).
- Use `mypy` (or `pyright` if configured) for type checking.
- Use `pytest` for tests. Tests live in `tests/` mirroring `src/` structure.
- For evals on LLM outputs, use `pytest` with custom fixtures (see `tests/evals/`) or a dedicated eval framework if configured.
- When a tool could help, use it. Prefer Context7 for library API lookups, `WebFetch` for other web docs. Use MCP tools when relevant.
</tools>

<quality-gate>
Before declaring any task complete, run:

```bash
uv run qa
```

This runs (in order): `ruff check --fix`, `ruff format`, `mypy`, `pytest`. All must pass.

If `qa` fails, iterate on the failing step. Don't skip steps. Don't comment out failing tests to make `qa` pass.

The `code-reviewer` subagent runs `qa` during the review phase. A `Stop` hook (auto-converted to `SubagentStop`) re-runs `qa` after the review and blocks the subagent from completing (exit code 2) if QA fails, so APPROVE cannot ship a red build.
</quality-gate>

<self-improvement>
This project is designed to improve itself over time. When you finish a task:

1. If you learned a non-obvious pitfall, anti-pattern, or convention: update `docs/gotchas.md`.
2. If you changed the project layout (added a folder, moved a module): update `docs/structure.txt`.
3. If you encountered an out-of-scope improvement worth doing later: append to `docs/proposals-ideas.md`.
4. If a generic lesson emerged that would apply to OTHER projects too: flag it for the user to consider backporting to `~/ai-project-template/`.

Do not skip these. The system gets better only if these living docs stay current.
</self-improvement>

<agent-roster>
The main-context driver (you, in Claude Code) is the orchestrator. The upstream `tdd` skill provides the methodology; the 3 subagents are escape hatches for phases that benefit from isolation.

**Skill (upstream, from mattpocock/skills):**
- `tdd` : Red -> Green -> Refactor methodology. Invoke in main context when writing tests and making them pass.

**Subagents** (use when a phase is complex enough to warrant an isolated context):
- `@test-spec-writer` : writes failing tests for a given requirement.
- `@implementer` : makes failing tests pass, then refactors.
- `@code-reviewer` : runs the QA gate (`uv run qa`). Has a `Stop` hook (auto-converted to `SubagentStop`) that re-runs QA and blocks completion on failure.

**Picking a model per call**: each subagent file has a default `model:` in its frontmatter (currently `sonnet` for all three). You can **override per invocation** by passing `model: sonnet | opus | haiku` in the `Agent` tool call. Use this to match cost to complexity: `haiku` for trivial reviews, `sonnet` for normal work, `opus` for security-sensitive or architecturally tricky code. Override only when the situation justifies it; the defaults are tuned for typical work.

For trivial tasks (typo fix, doc edit, single-line config): skip subagents entirely. Make the change directly, run `uv run qa`, commit.
</agent-roster>

<exceptional-cases>
**Trivial tasks** (typos, doc edits, single-line fixes): skip subagents. Make the change directly, run `qa`, commit.

**Exploratory spikes** (research, prototyping to learn): work in a separate `experiments/` folder. No TDD required. Document findings in `docs/proposals-ideas.md`.

**Blocked tasks**: if a task gets stuck (test can't be written, requirements unclear, dependency missing), STOP and ask the user. Do not guess. Document the block in `docs/current-task/task.md`.
</exceptional-cases>

<!--
Project: {{PROJECT_NAME}}
Goal: {{PROJECT_GOAL}}
Primary user: {{PRIMARY_USER}}
Stack: {{STACK}} ({{AI_FEATURES}})
Bootstrapped: {{DATE}}
-->
