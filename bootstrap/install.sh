#!/usr/bin/env bash
# install.sh - Bootstrap a new project from this template.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/Kpakfar/ai-project-template/main/bootstrap/install.sh)
#
# This script:
#   1. Drops the bootstrap AGENTS.md into the current directory
#   2. Installs the init-project skill (SKILL.md + templates/) into
#      .claude/skills/init-project/ using `npx degit`
#   3. Prints next steps
#
# Requires: curl, npx (Node.js).

set -euo pipefail

REPO="${REPO:-Kpakfar/ai-project-template}"
BRANCH="${BRANCH:-main}"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

echo "==> Bootstrapping AI project from ${REPO} (branch: ${BRANCH})"
echo

# Sanity: make sure the current directory looks safe to bootstrap into.
if [[ -f "AGENTS.md" ]] || [[ -d ".claude/agents" ]] || [[ -d ".claude/skills/init-project" ]]; then
  echo "ERROR: This project already appears to be initialized." >&2
  echo "Found existing AGENTS.md, .claude/agents/, or .claude/skills/init-project/." >&2
  echo "Refusing to overwrite. Bootstrap into an empty directory instead." >&2
  exit 1
fi

# Required tools.
MISSING=()
command -v npx >/dev/null 2>&1 || MISSING+=("npx (install Node.js: https://nodejs.org/)")
command -v uv >/dev/null 2>&1 || MISSING+=("uv (https://docs.astral.sh/uv/getting-started/installation/)")
command -v git >/dev/null 2>&1 || MISSING+=("git")

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "ERROR: Required tools are missing:" >&2
  for tool in "${MISSING[@]}"; do echo "  - $tool" >&2; done
  echo >&2
  echo "Install the missing tools, then re-run the bootstrap." >&2
  echo "(uv is required because /init-project runs 'uv sync' to install Python deps.)" >&2
  exit 1
fi

# 1. Drop the bootstrap AGENTS.md.
echo "==> Installing bootstrap AGENTS.md"
curl -fsSL "${RAW}/bootstrap/AGENTS.md" -o AGENTS.md

# 2. Install the init-project skill (SKILL.md + templates/).
echo "==> Installing init-project skill into .claude/skills/init-project/"
mkdir -p .claude/skills
npx --yes degit "${REPO}/init-project#${BRANCH}" .claude/skills/init-project --force

# 3. Done.
cat <<'EOF'

==> Bootstrap kit installed.

Next steps:

  1. Open Claude Code in this directory:
       claude

  2. Install the supporting skills (REQUIRED):
       npx skills@latest add mattpocock/skills
     Pick at minimum: tdd, grill-me, to-prd, caveman, write-a-skill, handoff
     The 'tdd' skill is the Red -> Green -> Refactor methodology this template
     relies on. The 3 generated subagents pair with it.

  3. In Claude Code, run:
       /init-project
     (or just say: "bootstrap this project")

The init skill will interview you about the project and generate the full structure,
including a .mcp.json with Context7 wired up for live library docs lookup.

EOF
