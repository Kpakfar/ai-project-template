<!--
  This is the BOOTSTRAP version of AGENTS.md.

  When the init-project skill runs successfully, this file is REPLACED with
  the project-specific AGENTS.md generated from a template.

  If you are an agent reading this file: the project is uninitialized.
  Trigger BOOTSTRAP MODE below.
-->

# AGENTS.md (Bootstrap Mode)

<bootstrap-mode>
This project is uninitialized. The following files do not yet exist:

- `docs/structure.txt`
- `docs/requirements.md`
- `.claude/agents/`

When you detect this state, do the following:

1. **Confirm with the user** that they want to bootstrap this project.
2. **Install supporting skills** (REQUIRED, not optional):
   ```bash
   npx skills@latest add mattpocock/skills
   ```
   Required at minimum: `tdd`, `grill-me`, `to-prd`, `caveman`, `write-a-skill`, `handoff`.
   The `tdd` skill provides the Red to Green to Refactor methodology this template relies on; the 3 generated subagents pair with it.
3. **Run the init-project skill** to generate the project structure.
   - If `init-project` is available as a slash command (`/init-project`), invoke it.
   - Otherwise, read `.claude/skills/init-project/SKILL.md` and follow its instructions.

The init-project skill will interview the user about scope and stack, then generate:

- `AGENTS.md` (project-specific, stack-agnostic core, replacing this file)
- `CLAUDE.md` (symlinked to `AGENTS.md` for Claude Code compatibility)
- `.claude/agents/` with three subagent definitions (test-spec-writer, implementer, code-reviewer)
- `.claude/hooks/quality-gate.sh` (deterministic QA gate triggered by code-reviewer)
- `.mcp.json` with Context7 MCP server wired up for live library docs lookup
- `.github/workflows/qa.yml` (CI running the quality-gate command on push and PR)
- `.github/pull_request_template.md` (short PR checklist)
- `.pre-commit-config.yaml` (local pre-commit hooks)
- `docs/` with templates filled in from the interview, including `language-standards.md`
- `.devcontainer/` if requested
- `scripts/` with the language-specific quality-gate runner
- The chosen language's manifest file (`pyproject.toml`, `package.json`, `Cargo.toml`, etc.)
- A working environment via the chosen package manager (`uv sync`, `pnpm install`, etc.), unless dev container is chosen
</bootstrap-mode>

<development-process>
Until bootstrap is complete:

- Do not write code or create unrelated files.
- Do not commit to git.
- Focus exclusively on running the init-project skill to set up the project.
</development-process>
