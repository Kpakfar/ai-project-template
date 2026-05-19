# python-api template (stub)

**Status:** placeholder.

This template will be a plain FastAPI + Postgres scaffold without AI features (no vector store, no LLM SDKs).

## To flesh out

Copy `../python-rag/` and remove:
- pgvector dependency from `pyproject.toml`
- LLM SDK dependencies (openai, anthropic)
- `src/services/retrieval.py`, `src/services/generation.py`
- `tests/evals/`
- AI-related sections from `docs/requirements.md` and `docs/documentation.md`
- Vector DB references from `.claude/agents/*.md`

Update `docs/structure.txt` to reflect the simpler layout.

## When to use

When you want the structured 3-subagent setup + upstream `tdd` skill (mattpocock/skills) but the project doesn't involve AI/RAG/agents at all.
