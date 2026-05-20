# Language & tooling standards

Language- and tool-specific conventions for this project. Filled in by `/init-project` from your setup answers. Update this file whenever a tooling decision changes.

## Language

- **Language:** {{LANGUAGE}}
- **Version:** {{LANGUAGE_VERSION}}

## Package management

- **Package manager:** {{PACKAGE_MANAGER}}
- **Manifest file:** {{MANIFEST_FILE}}
- **Install dependencies:** `{{INSTALL_COMMAND}}`
- **Add a dependency:** `{{ADD_DEP_COMMAND}}`

Never bypass the package manager. Never install globally.

## Quality-gate toolchain

The bundled command `{{QA_COMMAND}}` chains the following, in order. Each must pass for the gate to be green.

| Step | Tool | Command |
|---|---|---|
| Lint (with auto-fix) | {{LINT_TOOL}} | `{{LINT_COMMAND}}` |
| Format | {{FORMAT_TOOL}} | `{{FORMAT_COMMAND}}` |
| Type-check | {{TYPE_TOOL}} | `{{TYPE_COMMAND}}` |
| Tests | {{TEST_RUNNER}} | `{{TEST_COMMAND}}` |

## Coding conventions

These are the conventions `@implementer` and `@code-reviewer` enforce alongside the language-agnostic rules in `AGENTS.md` `<architecture-discipline>`.

### Type annotations

{{TYPE_ANNOTATION_NOTES}}

### Imports

{{IMPORT_NOTES}}

### Async / concurrency

{{ASYNC_NOTES}}

### Error handling

{{ERROR_NOTES}}

### Config and secrets

{{CONFIG_NOTES}}

### Logging

{{LOGGING_NOTES}}

### Test layout and fixtures

{{TEST_LAYOUT_NOTES}}

## Pre-commit hooks (optional)

The project ships with `.pre-commit-config.yaml` containing the following hooks:

{{PRECOMMIT_HOOKS_NOTES}}

Install with:

```
{{PRECOMMIT_INSTALL_COMMAND}}
```

## CI

GitHub Actions runs the full `{{QA_COMMAND}}` on every push and every pull request (see `.github/workflows/qa.yml`). A red CI = a blocked merge.

---

*Last updated: {{DATE}}*
