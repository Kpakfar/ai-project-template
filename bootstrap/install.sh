#!/usr/bin/env bash
# install.sh - Bootstrap a new project from this template.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/Kpakfar/ai-project-template/main/bootstrap/install.sh)
#
# This script:
#   1. Drops the bootstrap AGENTS.md into the current directory
#   2. Installs the init-project skill into .claude/skills/
#   3. Prints next steps

set -euo pipefail

REPO="${REPO:-Kpakfar/ai-project-template}"

BRANCH="${BRANCH:-main}"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

echo "==> Bootstrapping AI project from ${REPO}"
echo

# Sanity: make sure the current directory looks safe to bootstrap into.
if [[ -f "AGENTS.md" ]] || [[ -d ".claude/agents" ]]; then
  echo "ERROR: This project already appears to be initialized."
  echo "Found existing AGENTS.md or .claude/agents/ directory."
  echo "Refusing to overwrite. Bootstrap into an empty directory instead."
  exit 1
fi

# 1. Drop the bootstrap AGENTS.md.
echo "==> Installing bootstrap AGENTS.md"
curl -fsSL "${RAW}/bootstrap/AGENTS.bootstrap.md" -o AGENTS.md

# 2. Install the init-project skill.
echo "==> Installing init-project skill into .claude/skills/init-project/"
mkdir -p .claude/skills/init-project
curl -fsSL "${RAW}/init-project/SKILL.md" -o .claude/skills/init-project/SKILL.md

# 3. Done.
cat <<'EOF'

==> Bootstrap kit installed.

Next steps:

  1. Open Claude Code in this directory:
       claude

  2. Install the supporting skills (recommended):
       npx skills@latest add mattpocock/skills
     Pick at least: grill-me, tdd, to-prd, caveman, write-a-skill, handoff

  3. In Claude Code, run:
       /init-project
     (or just say: "bootstrap this project")

The init skill will interview you about the project and generate the full structure.

EOF
