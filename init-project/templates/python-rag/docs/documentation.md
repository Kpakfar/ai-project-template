# Documentation Index

This project uses **Context7 MCP** (wired up in `.mcp.json`) as the primary tool for live, version-specific library API lookups. Query Context7 first; fall back to the URLs below only if Context7 doesn't cover the library or returns nothing useful.

## How to use Context7

- Always query the **pinned version** in `pyproject.toml`, not "latest."
- Use for any library whose API may have shifted since training cutoff: LangChain, Pydantic v2, OpenAI SDK, Streamlit, FastAPI, SQLAlchemy 2.0, ChromaDB.
- If Context7 returns nothing useful, fall back to `WebFetch` on the URLs below, then note the gap in `docs/gotchas.md`.

## Backup URLs (for WebFetch fallback)

### Core stack

- **FastAPI**: https://fastapi.tiangolo.com/
- **Pydantic v2**: https://docs.pydantic.dev/latest/
- **pydantic-settings**: https://docs.pydantic.dev/latest/concepts/pydantic_settings/
- **SQLAlchemy 2.0**: https://docs.sqlalchemy.org/en/20/
- **Alembic (migrations)**: https://alembic.sqlalchemy.org/
- **uv**: https://docs.astral.sh/uv/
- **ruff**: https://docs.astral.sh/ruff/
- **mypy**: https://mypy.readthedocs.io/
- **pytest**: https://docs.pytest.org/
- **pytest-asyncio**: https://pytest-asyncio.readthedocs.io/

### AI / RAG stack

- **OpenAI Python SDK**: https://github.com/openai/openai-python
- **Anthropic Python SDK**: https://github.com/anthropics/anthropic-sdk-python
- **LangChain Python**: https://python.langchain.com/docs/introduction/
- **LlamaIndex**: https://docs.llamaindex.ai/
- **pgvector (Postgres extension)**: https://github.com/pgvector/pgvector
- **pgvector Python**: https://github.com/pgvector/pgvector-python
- **Chroma**: https://docs.trychroma.com/
- **sentence-transformers**: https://www.sbert.net/

### Frontend (if applicable)

- **Streamlit**: https://docs.streamlit.io/
- **Gradio**: https://www.gradio.app/docs

### Evals

- **DeepEval**: https://docs.confident-ai.com/
- **promptfoo**: https://www.promptfoo.dev/docs/intro/
- **ragas**: https://docs.ragas.io/

## Notes for agents

- Always query Context7 first. If a library moves fast (LangChain v1 vs v0, Pydantic v2 minor versions, OpenAI SDK tool-use shape, Streamlit `width="stretch"` API), training-data memory will be wrong.
- The LLM SDKs in particular change frequently (streaming, tool use, structured output APIs). Verify before using from memory.
- For pgvector specifically: the Python binding's API for similarity search varies by version. Check.

---

*Add new entries here whenever a new library is introduced to the project.*
