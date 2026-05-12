# How to use this template

## Setting up the template repo (one-time)

1. Fork this repo on GitHub (keep the name `ai-project-template`, or rename it).
2. In `bootstrap/install.sh`, update the `REPO` variable to point to your fork:
   ```bash
   REPO="YOUR_GITHUB_USERNAME/ai-project-template"
   ```
3. Commit and push. Verify the raw URLs work:
   - `https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/ai-project-template/main/bootstrap/install.sh`
   - `https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/ai-project-template/main/bootstrap/AGENTS.bootstrap.md`
   - `https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/ai-project-template/main/init-project/SKILL.md`

## Starting a new project

Two equivalent options:

### Option A: One-line install (recommended)

```bash
mkdir my-new-project && cd my-new-project && git init
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/ai-project-template/main/bootstrap/install.sh)
```

Then open Claude Code and run `/init-project`.

### Option B: degit (no curl, no execution)

```bash
mkdir my-new-project && cd my-new-project && git init
npx degit YOUR_GITHUB_USERNAME/ai-project-template/bootstrap . --force
mkdir -p .claude/skills
npx degit YOUR_GITHUB_USERNAME/ai-project-template/init-project .claude/skills/init-project --force
```

Then open Claude Code and run `/init-project`.

## What happens during bootstrap

1. The skill confirms intent with you.
2. It runs `npx skills@latest add mattpocock/skills` (you pick which skills).
3. It interviews you (~6 questions).
4. It generates the project scaffold from `init-project/templates/<your-stack>/`.
5. It symlinks `CLAUDE.md` → `AGENTS.md`.
6. It removes itself from the project (the init skill is no longer needed).

## Updating the template

Edit files in this repo. The next project you bootstrap will use the updated version.

For lessons learned during a real project that should backport to the template:
- During the project, the reviewer agent flags candidate generic lessons in `docs/gotchas.md`.
- At sprint end, review those candidates.
- For each generic one, edit the corresponding file in your local clone of this template repo and push.

## Adding a new stack template

1. `cp -r init-project/templates/python-rag init-project/templates/my-new-stack`
2. Adjust everything stack-specific (Dockerfile, pyproject vs package.json, agent prompts, structure.txt).
3. Update `init-project/SKILL.md` to add the new option to Q3 (stack menu).
4. Test by bootstrapping a throwaway project with the new stack.

## Troubleshooting

**`/init-project` slash command doesn't appear.**
The skill needs to be in `.claude/skills/init-project/SKILL.md` (note: the directory name matters). If `npx degit` put it elsewhere, move it.

**Symlink fails on Windows.**
Use Option A above on WSL, or skip the symlink and use a one-line `CLAUDE.md` pointing to `AGENTS.md` instead: `# See @AGENTS.md for project conventions.`

**Mattpocock skills don't install.**
Make sure Node.js is available. On the host machine, not just the container. The npx skill installer writes to a project-local directory and is then available to all coding agents.
