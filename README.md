# GiantCroissant Lunar Dev Rules

Reusable AI agent rules and pre-commit hooks for consistent development across projects.

## Overview

This repository provides:
- **Agent Rules**: Structured instructions for AI coding assistants (Claude, Cursor, Windsurf, etc.)
- **Pre-commit Hooks**: Automated checks for code quality, security, and standards
- **Stack-specific Conventions**: Tailored rules for different tech stacks (.NET, Node.js, Python, etc.)

## Features

✅ **Layered Configuration** - Base rules + stack-specific + local customization
✅ **Version Controlled** - Semantic versioning for all rule sets
✅ **Easy Installation** - Simple shell script to set up new projects
✅ **Multiple Stacks** - Support for .NET, Node.js, Python, and more
✅ **Security First** - Built-in secret detection and security checks
✅ **Pre-commit Integration** - Automated enforcement of standards

## Quick Start

### Install in a New Project

```bash
# From your project root
curl -fsSL https://raw.githubusercontent.com/yourusername/giantcroissant-lunar-dev-rule/main/cli/install.sh | bash -s -- --stack dotnet
```

### Supported Stacks

- `dotnet` - .NET/C#/Unity projects
- `nodejs` - Node.js/TypeScript projects (coming soon)
- `python` - Python projects (coming soon)

## What Gets Installed

```
your-project/
├── .agent/                    # AI agent rules
│   ├── base/                  # Universal rules (all projects)
│   ├── stacks/dotnet/         # Stack-specific rules
│   ├── adapters/              # Agent-specific adapters
│   └── local/                 # Your customizations
├── .pre-commit-config.yaml    # Pre-commit hook configuration
└── scripts/validators/        # Custom validation scripts
```

## Repository Structure

```
giantcroissant-lunar-dev-rule/
├── cli/                       # Installation tooling
│   └── install.sh            # Main installation script
├── templates/                 # Source templates
│   ├── base/                 # Universal agent rules
│   │   ├── 00-index.md
│   │   ├── 10-principles.md
│   │   ├── 20-rules.md
│   │   └── 30-glossary.md
│   ├── stacks/               # Stack-specific additions
│   │   ├── dotnet/
│   │   │   ├── rules.md
│   │   │   └── adapters/
│   │   ├── nodejs/
│   │   └── python/
│   ├── hooks/                # Pre-commit hooks
│   │   ├── base/
│   │   │   └── pre-commit-config.yaml
│   │   ├── dotnet/
│   │   │   └── pre-commit-config.yaml
│   │   └── python/
│   │       └── validators/
│   └── meta/                 # Versioning and templates
├── examples/                 # Sample configurations
├── docs/                     # Documentation
└── README.md
```

## Usage

### Basic Installation

```bash
# Install for .NET project
./cli/install.sh --stack dotnet

# Dry run (show what would be installed)
./cli/install.sh --stack dotnet --dry-run
```

### Customization

After installation, customize your setup in `.agent/local/`:

```markdown
# .agent/local/overrides.md

## Disabled Rules
- R-CODE-010: disabled (we prefer creating new files)

## Custom Settings
- Max line length: 120 (instead of default 100)
```

### Pre-commit Hooks

```bash
# Test all hooks
pre-commit run --all-files

# Run specific hook
pre-commit run gitleaks --all-files

# Skip hooks for a commit (not recommended)
git commit --no-verify
```

## Agent Rules

### Rule Structure

Rules follow a hierarchical merge system:

1. **Base rules** (`.agent/base/`) - Universal principles
2. **Stack rules** (`.agent/stacks/dotnet/`) - Stack-specific conventions
3. **Adapters** (`.agent/adapters/`) - Agent-specific formatting
4. **Local overrides** (`.agent/local/`) - Project customizations

**Priority**: `local` > `adapters` > `stacks` > `base`

### Rule Format

Rules use standardized IDs for easy reference:

```markdown
### R-CODE-010: Prefer Editing Over Creating
- **What**: Always edit existing files rather than creating new ones
- **Why**: Maintains codebase coherence
- **How**: Search for existing files first
```

### Supported AI Agents

- **Claude Code** (`.agent/adapters/claude.md`)
- **Cursor** (`.agent/adapters/cursor.md`)
- **Windsurf** (`.agent/adapters/windsurf.md`)
- **GitHub Copilot** (`.agent/adapters/copilot.md`)

## Pre-commit Hooks

### Base Hooks (All Projects)

- Trailing whitespace removal
- End-of-file fixing
- JSON/YAML validation
- Secret detection (GitLeaks)
- Merge conflict detection
- Large file prevention

### Stack-Specific Hooks

#### .NET (dotnet)
- `dotnet format` enforcement
- JetBrains code cleanup (optional)
- Solution file validation
- Custom validators (issue metadata, RFC frontmatter)

#### Python (python)
- Ruff linting and formatting
- Bandit security checks
- Type checking

#### Node.js (nodejs)
- ESLint
- Prettier
- Package.json validation

## Validators

### Issue Dependency Validator

Ensures commits don't reference blocked issues:

```bash
python scripts/validators/validate_issue_dependencies.py
```

### RFC/ADR Frontmatter Validator

Validates documentation frontmatter:

```bash
python scripts/validators/validate_frontmatter.py docs/rfcs/*.md
```

## Development

### Adding a New Stack

1. Create stack directory:
   ```bash
   mkdir -p templates/stacks/your-stack
   ```

2. Add stack rules:
   ```bash
   # templates/stacks/your-stack/rules.md
   ```

3. Add pre-commit config:
   ```bash
   # templates/hooks/your-stack/pre-commit-config.yaml
   ```

4. Add adapters (optional):
   ```bash
   # templates/stacks/your-stack/adapters/
   ```

### Testing Locally

```bash
cd your-test-project
/path/to/giantcroissant-lunar-dev-rule/cli/install.sh --stack dotnet
```

## Versioning

This project uses semantic versioning:

- **Base rules**: `v1.1.0`
- **Stack rules**: Independent versioning per stack
- **Adapters**: Synced with base version

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your changes
4. Test with `--dry-run`
5. Submit a pull request

## License

MIT License - see LICENSE file

## Credits

Extracted from the Winged Bean project by apprenticegc.

## Links

- [Documentation](docs/)
- [Examples](examples/)
- [Issue Tracker](https://github.com/yourusername/giantcroissant-lunar-dev-rule/issues)
