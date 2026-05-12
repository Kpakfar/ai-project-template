#!/usr/bin/env bash
# scripts/qa.sh
#
# Bundled quality checks. Runs in order:
#   1. ruff check (lint, auto-fix safe issues)
#   2. ruff format (format)
#   3. mypy (type check)
#   4. pytest (tests)
#
# Each step must pass for the script to succeed.
# This is the gate that the code-reviewer agent enforces.

set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> [1/4] ruff check --fix"
uv run ruff check . --fix

echo
echo "==> [2/4] ruff format"
uv run ruff format .

echo
echo "==> [3/4] mypy"
uv run mypy src/

echo
echo "==> [4/4] pytest"
uv run pytest

echo
echo "==> QA passed."
