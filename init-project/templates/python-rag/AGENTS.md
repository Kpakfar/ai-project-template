<development-process>
- Dev container: {{USES_DEVCONTAINER}}. If yes, all commands run inside the container: do not install anything globally on the host.
- Always start by reading `docs/structure.txt` and `docs/requirements.md` in parallel to orient yourself.
- Always consult `docs/documentation.md` for links to library docs. Prefer Context7 (see below) for live API lookups.
- If you encounter unfamiliar libraries, APIs, or patterns, research online before guessing. Fetch the actual documentation.
- Work in this directory/repo only. Never touch files outside this repo unless explicitly instructed.
- It is your responsibility to manage the environment and install any new dependencies as needed. The package-manager and install commands for this project are recorded in `docs/language-standards.md`.
- The bundled quality-gate command is `{{QA_COMMAND}}` (runs lint + format + types + tests in order). It is wired into the QA hook and the CI workflow. Do not bypass it.
</development-process>

<architecture-discipline>
These rules are language- and stack-agnostic. Apply them on every file you write or modify.

- **Two-layer split by default.** A `backend/` (or equivalent) layer for domain logic and I/O, and a `frontend/` (or `app`, `ui/`) layer for user interface. Add a third layer (orchestrator, flow, controller) only when a task literally cannot be expressed without one. No speculative middle layers before there is a concrete reason for them.

- **One concept per file.** Each backend module owns a single concept (llm client, prompt loader, retriever, ingestion pipeline, tools, safety check, config, and so on). Target ~100 lines per file. Hard cap 200. Split before exceeding, not after.

- **Prompts as plain text files.** Store every system prompt as a `.md` (or `.txt`) file under a `prompts/` directory. Load them with short helpers. Substitute variables with plain string `.replace("{{placeholder}}", value)` (or the language's equivalent). Do NOT build template-engine-style, ORM-style, or class-based prompt builders. The loader module should be small.

- **Prompt variants are files, not classes.** If you need multiple versions of the same prompt (zero-shot, few-shot, chain-of-thought, persona A, persona B), save them as separate files and switch by filename via a config or session-state value. No strategy pattern, no registry, no factory.

- **Typed structured outputs only where it matters.** Use the language's structured-output validation (Pydantic, Zod, TypedDict + runtime check, etc.) to validate LLM responses, define tool inputs/outputs, and capture domain models. Do NOT wrap UI state or every dict that crosses a function boundary.

- **Session/UI state stays plain.** Initialize state with the framework's idiomatic pattern. Keep state initialization in one block at the top of the UI module. Do not introduce a state-wrapper class unless real behaviour lives on it.

- **No premature abstraction.** Three similar lines are better than a class with a strategy pattern. The bar for adding an abstraction is "two real callers, not one hypothetical one."

- **Functions over classes.** Prefer plain functions taking simple types and returning them. Reach for a class only when state genuinely lives on the object across method calls.

- **Concrete over generic.** A function that does one specific thing well is better than a function that takes a config dict and dispatches. If you find yourself writing `if mode == "X": ... elif mode == "Y": ...`, consider whether you actually want two separate functions.

The test for any new module: a competent peer reading it for the first time should understand it in under one minute.
</architecture-discipline>

<global-documents>
- `docs/structure.txt` : project map (folders, what each is for). Update when layout changes.
- `docs/requirements.md` : what we're building, for whom, why. Domain model and stack.
- `docs/language-standards.md` : language- and tooling-specific conventions (types, imports, async, error handling, dependency management). Filled in by `/init-project` from the answers in setup.
- `docs/documentation.md` : direct links to library docs the agent should consult. Use Context7 first.
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
This project ships with **Context7 MCP** wired up via `.mcp.json`. Context7 provides up-to-date, version-specific library documentation across languages.

**When to use it (always)**: any time you write or modify code that touches a third-party library. Training-data memory will be off in subtle ways, especially for fast-moving libraries.

**How to use it**:
- Before writing the code, query Context7 for the relevant API of the **pinned version** in your manifest file ({{MANIFEST_FILE}}), not the latest available.
- For frontend frameworks: look up the specific component or hook you intend to use.
- For LLM SDKs and orchestrators: verify chat/completion calls, structured-output shape, streaming, tool use; these APIs change frequently.
- For validation/serialization libraries: verify the current version's API; minor versions can be unstable.

**Rule**: do not write code from training-data memory for these libraries. If Context7 returns nothing useful for a query, say so in your summary and propose a fallback (a smaller, safer call signature, or `WebFetch` of the upstream docs).
</library-docs>

<tools>
- Use the project's package-manager exclusively (recorded in `docs/language-standards.md`). Never bypass it.
- Use the project's lint/format/type/test toolchain (recorded in `docs/language-standards.md`). The `{{QA_COMMAND}}` script chains all of them.
- When a tool could help, use it. Prefer Context7 for library API lookups, `WebFetch` for other web docs. Use MCP tools when relevant.
</tools>

<quality-gate>
Before declaring any task complete, run:

```
{{QA_COMMAND}}
```

This runs lint, format, type-check, and tests in order. All must pass.

If `{{QA_COMMAND}}` fails, iterate on the failing step. Don't skip steps. Don't comment out failing tests to make it pass.

The `code-reviewer` subagent runs the quality gate during the review phase. A `Stop` hook (auto-converted to `SubagentStop`) re-runs it after the review and blocks the subagent from completing (exit code 2) if it fails, so APPROVE cannot ship a red build.

CI also runs the same `{{QA_COMMAND}}` on every push and every pull request (see `.github/workflows/qa.yml`). A red CI = a blocked merge.
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
- `@code-reviewer` : runs the quality gate. Has a `Stop` hook (auto-converted to `SubagentStop`) that re-runs the gate and blocks completion on failure.

**Picking a model per call**: each subagent file has a default `model:` in its frontmatter. You can **override per invocation** by passing `model: sonnet | opus | haiku` in the `Agent` tool call. Use this to match cost to complexity: `haiku` for trivial reviews, `sonnet` for normal work, `opus` for security-sensitive or architecturally tricky code. Override only when the situation justifies it; the defaults are tuned for typical work.

For trivial tasks (typo fix, doc edit, single-line config): skip subagents entirely. Make the change directly, run `{{QA_COMMAND}}`, commit.
</agent-roster>

<exceptional-cases>
**Trivial tasks** (typos, doc edits, single-line fixes): skip subagents. Make the change directly, run the quality gate, commit.

**Exploratory spikes** (research, prototyping to learn): work in a separate `experiments/` folder. No TDD required. Document findings in `docs/proposals-ideas.md`.

**Blocked tasks**: if a task gets stuck (test can't be written, requirements unclear, dependency missing), STOP and ask the user. Do not guess. Document the block in `docs/current-task/task.md`.
</exceptional-cases>

<!--
Project: {{PROJECT_NAME}}
Goal: {{PROJECT_GOAL}}
Primary user: {{PRIMARY_USER}}
Language: {{LANGUAGE}}
Frontend: {{HAS_FRONTEND}}
AI features: {{AI_FEATURES}}
Bootstrapped: {{DATE}}
-->
