<development-process>
- You are working in a devcontainer. All commands run inside it. Do not install anything globally on the host.
- Always start by reading `docs/structure.txt` and `docs/requirements.md` in parallel to orient yourself.
- Always consult `docs/documentation.md` for links to library docs. Fetch them when in doubt.
- If you encounter unfamiliar libraries, APIs, or patterns, research online before guessing. Fetch the actual documentation.
- Work in this directory/repo only. Never touch files outside this repo unless explicitly instructed.
- It is your responsibility to manage the environment and install any new dependencies as needed (add to `pyproject.toml`, run `uv sync`).
- Run `uv run python -c "import json, tomllib; print(json.dumps(tomllib.load(open('pyproject.toml','rb')).get('tool',{}).get('scripts',{}), indent=2))"` to check available scripts. Common ones: `uv run qa`, `uv run test`, `uv run lint`.
</development-process>

<global-documents>
- `docs/structure.txt` - project map (folders, what each is for). Update when layout changes.
- `docs/requirements.md` - what we're building, for whom, why. Domain model and stack.
- `docs/documentation.md` - direct links to library docs the agent should consult.
- `docs/backlog.md` - scoped, queued tasks. Reviewed continuously.
- `docs/proposals-ideas.md` - out-of-scope or future ideas. Reviewed every ~2 weeks.
- `docs/gotchas.md` - known pitfalls, anti-patterns, lessons learned. Living document. Update after every task that surfaces something worth keeping.
</global-documents>

<task-specific-documents>
- `docs/current-task/task.md` - coordination document for the active task. Shared memory between agents.
- `docs/current-task/task-template.md` - template to reset `task.md` when starting a new task.

When starting a new task, copy `task-template.md` over `task.md` and fill it in. When the task is done, archive the contents (move to a project log or commit message) before resetting.
</task-specific-documents>

<tools>
- Use `uv` for all Python dependency and script management. Never `pip install` directly.
- Use `ruff` for linting and formatting (configured in `pyproject.toml`).
- Use `mypy` (or `pyright` if configured) for type checking.
- Use `pytest` for tests. Tests live in `tests/` mirroring `src/` structure.
- For evals on LLM outputs, use `pytest` with custom fixtures (see `tests/evals/`) or a dedicated eval framework if configured.
- When a tool could help, use it. Prefer `WebFetch` for documentation. Use MCP tools when relevant.
</tools>

<quality-gate>
Before declaring any task complete, run:

```bash
uv run qa
```

This runs (in order): `ruff check --fix`, `ruff format`, `mypy`, `pytest`. All must pass.

If `qa` fails, iterate on the failing step. Don't skip steps. Don't comment out failing tests to make `qa` pass.

The `code-reviewer` agent will run `qa` as part of Phase 7 review.
</quality-gate>

<self-improvement>
This project is designed to improve itself over time. When you finish a task:

1. If you learned a non-obvious pitfall, anti-pattern, or convention - update `docs/gotchas.md`.
2. If you changed the project layout (added a folder, moved a module) - update `docs/structure.txt`.
3. If you encountered an out-of-scope improvement worth doing later - append to `docs/proposals-ideas.md`.
4. If a generic lesson emerged that would apply to OTHER projects too - flag it for the user to consider backporting to `~/ai-project-template/`.

Do not skip these. The system gets better only if these living docs stay current.
</self-improvement>

<agent-roster>
This project uses four specialized agents, defined in `.claude/agents/`:

- `@tdd-orchestrator` - coordinates the workflow. Delegates to other agents. Never writes code itself.
- `@test-spec-writer` - turns requirements into failing tests.
- `@implementer` - writes minimal code to pass tests. Refactors after green.
- `@code-reviewer` - runs the QA gate. Pushes back on quality, security, or design issues.

For any non-trivial task (new feature, significant bug fix, refactor), the orchestrator handles delegation. For trivial tasks (typo fix, doc tweak), the main agent does the work directly.

The orchestrator's full pipeline: Study → Spec → Build → Review. See `.claude/agents/tdd-orchestrator.md` for details.
</agent-roster>

<exceptional-cases>
**Trivial tasks** (typos, doc edits, single-line fixes): skip the full TDD pipeline. Make the change directly, run `qa`, commit.

**Exploratory spikes** (research, prototyping to learn): work in a separate `experiments/` folder. No TDD required. Document findings in `docs/proposals-ideas.md`.

**Blocked tasks**: if the pipeline gets stuck (test can't be written, requirements unclear, dependency missing), STOP and ask the user. Do not guess. Document the block in `docs/current-task/task.md`.
</exceptional-cases>

<!--
Project: {{PROJECT_NAME}}
Goal: {{PROJECT_GOAL}}
Primary user: {{PRIMARY_USER}}
Stack: {{STACK}} ({{AI_FEATURES}})
Bootstrapped: {{DATE}}
-->
