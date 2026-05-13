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
2. **Install supporting skills** if not already installed:
   ```bash
   npx skills@latest add mattpocock/skills
   ```
   Recommended skills for this template: `grill-me`, `tdd`, `to-prd`, `caveman`, `write-a-skill`, `handoff`.
3. **Run the init-project skill** to generate the project structure.
   - If `init-project` is available as a slash command (`/init-project`), invoke it.
   - Otherwise, read `.claude/skills/init-project/SKILL.md` and follow its instructions.

The init-project skill will interview the user, then generate:

- `AGENTS.md` (project-specific, replacing this file)
- `CLAUDE.md` (symlinked to `AGENTS.md` for Claude Code compatibility)
- `.claude/skills/tdd-pipeline/` with the `/tdd-pipeline` coordination skill
- `.claude/agents/` with three subagent definitions
- `docs/` with templates filled in from the interview
- `.devcontainer/` if requested
- `scripts/qa.sh` tailored to the chosen stack
</bootstrap-mode>

<development-process>
Until bootstrap is complete:

- Do not write code or create unrelated files.
- Do not commit to git.
- Focus exclusively on running the init-project skill to set up the project.
</development-process>
