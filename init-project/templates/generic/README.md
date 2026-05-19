# generic template (stub)

**Status:** placeholder.

This template will be language-agnostic. The 3-subagent setup + upstream `tdd` skill (mattpocock/skills) and docs structure are the same, but `scripts/qa.sh` and the dev container are left as TODOs for the user to fill in.

## To flesh out

Copy `../python-rag/` and:

- Remove all Python-specific files (`pyproject.toml.example`, etc.)
- Remove Python-specific dev container.
- Replace `scripts/qa.sh` with a placeholder script that just echoes "TODO: implement QA for your stack".
- Generalize agent prompts: remove all references to `uv`, `pytest`, `ruff`, `mypy`. Replace with `<test command>`, `<lint command>`, etc.
- Update `docs/documentation.md` to be empty (user fills in based on stack).
- Update `docs/structure.txt` to reflect a minimal generic layout.

## When to use

When the project uses a stack not covered by the other templates (Rust, Go, Elixir, etc.). The 3-subagent setup + upstream `tdd` skill + docs structure still applies, but you'll need to customize the commands.
