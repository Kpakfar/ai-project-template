---
name: tdd
description: >-
  Run a task through the full TDD pipeline: explore → failing tests →
  implementation → refactor → code review. Use when the user provides a
  feature request, bug fix, or any non-trivial coding task.

  <example>
  user: "Add a /retrieve endpoint that returns the top 5 chunks for a query."
  assistant: [invokes /tdd, runs full pipeline in main context, hands off to @code-reviewer at the end]
  </example>
---

# TDD Workflow

Runs Red → Green → Refactor → Review in the current conversation. The full context stays here — only the final review step delegates to a subagent.

---

## Before anything: task setup

1. Copy `docs/current-task/task-template.md` over `docs/current-task/task.md`.
2. Fill in: title, description, acceptance criteria, links to relevant docs.

---

## Phase 1: Explore

Read in parallel before touching code:

- `docs/requirements.md` — what we're building and why
- `docs/structure.txt` — where files belong
- `docs/gotchas.md` — what has bitten us before
- Existing tests in the affected area — match conventions

Identify the files relevant to the task. Do not write code yet.

---

## Phase 2: Spec (Red)

Write failing tests that define "done." For complex test suites, delegate to `@test-spec-writer` and wait for it to finish.

**Testing rules (non-negotiable):**

| Layer | Style |
|---|---|
| Pure functions | Unit tests in `tests/` mirroring `src/` |
| FastAPI routes | `TestClient` integration tests, real DB, transaction rollback per test |
| User flows / E2E | Small number; use stable IDs, ignore implementation internals |
| LLM/RAG features | Eval-style tests in `tests/evals/` — check properties, not exact outputs |

- No mocks for code you own. Mocks only for external APIs (OpenAI, etc.) — prefer recorded responses.
- Test names describe behavior: `test_retrieve_returns_top_5_chunks_ordered_by_score`.
- Run the new tests and confirm they fail for the right reason (feature missing, not a typo).

Append `## Spec` to `task.md`: tests added, criteria covered.

---

## Phase 3: Implement (Green)

Write the minimal code to make the tests pass. For large or complex implementations, delegate to `@implementer` and wait.

**Standards:**

- Python 3.12+. `list[int]` not `List[int]`. `from __future__ import annotations` at the top of every module.
- Every function fully typed.
- Async for all I/O (HTTP, DB, LLM calls).
- Config via `pydantic-settings`. No hardcoded keys, URLs, or model names.
- `logging`, not `print`. Specific exceptions, not bare `Exception`.
- New dependencies go in `pyproject.toml` → `uv sync`. Never `pip install`.

Run `uv run pytest tests/path/to/new_tests.py -v`. Confirm green.

---

## Phase 4: Refactor

Improve structure without changing behavior. Pure functions where they fit. Remove dead code. Tests must still pass after every change.

---

## Phase 5: Review

Hand off to `@code-reviewer`. Tell it:
- What was deliberately changed (so it doesn't flag intentional changes as regressions)
- Which tests were added

The pipeline is complete when `@code-reviewer` returns `APPROVE` or `APPROVE_WITH_NITS` **and** `uv run qa` passes.

---

## Phase 6: Clean up

- Remove debug prints and scratch files
- Update `docs/structure.txt` if the layout changed
- Update `docs/gotchas.md` if something non-obvious was learned
- Update `docs/documentation.md` if a new library was introduced
- Archive `task.md` (commit message or `docs/_log/`) and reset from template

---

## Escape hatches

**Task under ~1h:** skip delegation (run spec and implement inline). Still hand off to `@code-reviewer` at the end.

**Trivial change** (typo, doc edit, single-line config): skip this skill entirely. Make the change, run `uv run qa`, commit.

**Blocked:** if tests can't be written or requirements are unclear, stop and ask the user. Document the block in `task.md`. Do not guess.
