# Quick Start Guide

Get up and running with GiantCroissant Lunar Dev Rules in under 5 minutes.

## Prerequisites

- Git repository initialized
- (Optional) Python 3.8+ for pre-commit hooks
- (Optional) pre-commit installed (`pip install pre-commit` or `brew install pre-commit`)

## Installation

### Step 1: Run the Installer

From your project root:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/giantcroissant-lunar-dev-rule/main/cli/install.sh | bash -s -- --stack dotnet
```

Or download and run locally:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/giantcroissant-lunar-dev-rule/main/cli/install.sh -o install-dev-rules.sh
chmod +x install-dev-rules.sh
./install-dev-rules.sh --stack dotnet
```

### Step 2: Verify Installation

Check that files were created:

```bash
ls -la .agent/
ls -la .pre-commit-config.yaml
```

You should see:
```
.agent/
├── base/
├── stacks/
├── adapters/
└── local/

.pre-commit-config.yaml
```

### Step 3: Test Pre-commit Hooks

```bash
pre-commit run --all-files
```

This will:
- Download and install all hook dependencies
- Run checks against your codebase
- Report any issues found

### Step 4: Commit the Configuration

```bash
git add .agent/ .pre-commit-config.yaml scripts/
git commit -m "feat: Add GiantCroissant Lunar dev rules and pre-commit hooks"
```

## Usage

### With AI Agents

The `.agent/` directory contains instructions that AI coding assistants will automatically read.

**Claude Code**: Automatically reads `CLAUDE.md` or `.agent/` directory

**Cursor**: Configure in settings to read `.agent/adapters/cursor.md`

**Windsurf**: Configure to read `.agent/adapters/windsurf.md`

### Pre-commit Hooks

Hooks run automatically on `git commit`:

```bash
# Normal commit (hooks run automatically)
git commit -m "fix: Update validation logic"

# Skip hooks (use sparingly!)
git commit --no-verify -m "WIP: Temporary commit"

# Run hooks manually
pre-commit run --all-files

# Run specific hook
pre-commit run gitleaks
```

## Customization

### Add Project-Specific Rules

Edit `.agent/local/custom-rules.md`:

```markdown
# Project-Specific Rules

### R-LOCAL-001: Use ProjectX Naming Convention
- All services must use `Service` suffix
- All repositories must use `Repository` suffix
```

### Override Base Rules

Edit `.agent/local/overrides.md`:

```markdown
# Overrides

## Disabled Rules
- R-CODE-010: disabled  # We create new files frequently

## Modified Rules
- R-CODE-030: Max line length 120 (was 100)
```

### Modify Pre-commit Hooks

Edit `.pre-commit-config.yaml` to:
- Add new hooks
- Disable unwanted hooks
- Adjust hook parameters

Example - disable a hook:

```yaml
hooks:
  - id: markdownlint
    # Disable by commenting out or removing
```

## Common Tasks

### Update Rules

Re-run the installer to get latest rules:

```bash
./install-dev-rules.sh --stack dotnet
```

Your local customizations in `.agent/local/` are preserved.

### Add Another Stack

Some projects use multiple stacks:

```bash
./install-dev-rules.sh --stack nodejs
```

This adds Node.js-specific rules alongside existing ones.

### Share with Team

Commit `.agent/` and `.pre-commit-config.yaml` to your repository. Team members just need to:

```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install
```

## Troubleshooting

### "pre-commit: command not found"

Install pre-commit:

```bash
pip install pre-commit
# or
brew install pre-commit
```

### "gitleaks: command not found"

Pre-commit will download it automatically on first run:

```bash
pre-commit run gitleaks --all-files
```

### Hooks are Too Slow

Run expensive hooks manually only:

```yaml
hooks:
  - id: jetbrains-inspect
    stages: [manual]  # Only run with: pre-commit run --hook-stage manual
```

### Python Validator Errors

Ensure Python dependencies are installed:

```bash
pip install pyyaml
```

## Next Steps

- Read [Customization Guide](customization.md)
- Explore [Examples](../examples/)
- Review [Base Rules](../templates/base/20-rules.md)
- Check [Stack-Specific Rules](../templates/stacks/dotnet/rules.md)

## Getting Help

- [Documentation](.)
- [GitHub Issues](https://github.com/yourusername/giantcroissant-lunar-dev-rule/issues)
- Review installed README: `.agent/local/README.md`
