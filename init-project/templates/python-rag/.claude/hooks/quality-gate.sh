#!/usr/bin/env bash
# .claude/hooks/quality-gate.sh
#
# Triggered by the code-reviewer agent on Stop.
# Runs the bundled QA check. Exits non-zero on failure so the agent sees it failed.

set -euo pipefail

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

echo "==> Quality gate: running uv run qa"
echo

if ! uv run qa; then
  echo
  echo "FAILED: Quality gate did not pass."
  echo "The code-reviewer agent must address failures before approving."
  exit 1
fi

echo
echo "PASSED: Quality gate green."
