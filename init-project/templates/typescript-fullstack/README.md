# typescript-fullstack template (stub)

**Status:** placeholder.

This template will scaffold a Next.js + tRPC + Drizzle + Postgres project, mirroring the original CMS workshop reference.

## To flesh out

Mirror the structure of `../python-rag/` but:

- Replace `pyproject.toml.example` with `package.json` (bun, vitest, biome/eslint, drizzle).
- Replace `scripts/qa.sh` with `bun run qa` that bundles `bun run typecheck && bun run lint:fix && bun run test && bun run e2e && bun run format`.
- Replace `.devcontainer/Dockerfile` with a Node 20 + bun base.
- Update agent prompts: replace `uv run qa` with `bun run qa`, replace pytest with vitest/playwright, replace mypy with `tsc --noEmit`.
- Update `docs/structure.txt` to reflect the TS project layout.
- Update `docs/documentation.md` with TS/Next/tRPC docs.

## When to use

When building a fullstack TypeScript web app (with or without AI features).

## Reference

The agent prompts in the workshop screenshots assumed this stack. See the workshop notes for the original phrasing.
