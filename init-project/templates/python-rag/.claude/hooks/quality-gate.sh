#!/usr/bin/env bash
# .claude/hooks/quality-gate.sh
#
# Triggered by the code-reviewer subagent on Stop (auto-converted to
# SubagentStop). Runs the bundled QA check.
#
# Exit code 2 blocks the subagent from completing — see
# https://code.claude.com/docs/en/hooks (exit-code behaviour). Any other
# non-zero exit is logged but does NOT block, so we deliberately exit 2
# on QA failure to gate APPROVE on a passing build.

set -euo pipefail

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

echo "==> Quality gate: running uv run qa"
echo

if ! uv run qa; then
  echo
  echo "FAILED: Quality gate did not pass." >&2
  echo "The code-reviewer subagent cannot complete until QA is green." >&2
  exit 2
fi

echo
echo "PASSED: Quality gate green."
