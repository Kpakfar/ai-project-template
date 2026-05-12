# Documentation Index

Direct links to up-to-date library documentation. Agents should consult these when working with the corresponding library, not rely on training data alone.

## Core stack

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

## AI / RAG stack

- **OpenAI Python SDK**: https://github.com/openai/openai-python
- **Anthropic Python SDK**: https://github.com/anthropics/anthropic-sdk-python
- **LangChain Python**: https://python.langchain.com/docs/introduction/
- **LlamaIndex**: https://docs.llamaindex.ai/
- **pgvector (Postgres extension)**: https://github.com/pgvector/pgvector
- **pgvector Python**: https://github.com/pgvector/pgvector-python
- **Chroma**: https://docs.trychroma.com/
- **sentence-transformers**: https://www.sbert.net/

## Evals

- **DeepEval**: https://docs.confident-ai.com/
- **promptfoo**: https://www.promptfoo.dev/docs/intro/
- **ragas**: https://docs.ragas.io/

## Notes for agents

- Always `WebFetch` the official docs when in doubt about API shape. Library APIs change.
- The LLM SDKs in particular change frequently (streaming, tool use, structured output APIs). Verify before using from memory.
- For pgvector specifically: the Python binding's API for similarity search varies by version. Check.

---

*Add new entries here whenever a new library is introduced to the project.*
