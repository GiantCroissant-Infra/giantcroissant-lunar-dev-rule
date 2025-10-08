# Quick Reference Card

## Installation

```bash
# Basic install
curl -fsSL https://raw.githubusercontent.com/yourusername/giantcroissant-lunar-dev-rule/main/cli/install.sh | bash -s -- --stack dotnet

# Or local
./cli/install.sh --stack dotnet

# Dry run
./cli/install.sh --stack dotnet --dry-run
```

## Directory Structure

```
.agent/
├── base/           # Universal rules (don't edit)
├── stacks/         # Stack rules (don't edit)
├── adapters/       # AI agent adapters (don't edit)
└── local/          # YOUR CUSTOMIZATIONS HERE ✅
    ├── overrides.md      # Disable/modify rules
    └── custom-rules.md   # Add new rules
```

## Common Tasks

### Disable a Rule

`.agent/local/overrides.md`:
```markdown
### R-CODE-010: Prefer Editing Over Creating
**Status**: DISABLED
**Reason**: Our workflow creates many new files
```

### Add Custom Rule

`.agent/local/custom-rules.md`:
```markdown
### R-LOCAL-001: API Versioning
- All APIs must include version in URL: `/api/v1/`
- Breaking changes require major version bump
```

### Modify Pre-commit Hooks

Edit `.pre-commit-config.yaml`:
```yaml
hooks:
  - id: gitleaks
    # Comment out to disable
```

### Update Rules

```bash
# Re-run installer (keeps local customizations)
./cli/install.sh --stack dotnet

# Review changes
git diff .agent/
```

## Pre-commit Commands

```bash
# Run all hooks
pre-commit run --all-files

# Run specific hook
pre-commit run gitleaks

# Skip hooks (not recommended)
git commit --no-verify

# Install hooks
pre-commit install
```

## Rule Reference Format

```markdown
### R-{CATEGORY}-{NUMBER}: Rule Title
- **What**: What the rule requires
- **Why**: Rationale
- **How**: Implementation details
```

### Categories
- `CODE` - Code quality
- `SEC` - Security
- `DOC` - Documentation
- `GIT` - Git workflow
- `TST` - Testing
- `BLD` - Build/deployment
- `PRC` - Process
- `DOTNET` - .NET specific
- `LOCAL` - Project specific

## File Locations

| File | Purpose |
|------|---------|
| `.agent/base/20-rules.md` | All base rules |
| `.agent/stacks/dotnet/rules.md` | .NET-specific rules |
| `.agent/local/overrides.md` | Your overrides |
| `.agent/local/custom-rules.md` | Your rules |
| `.pre-commit-config.yaml` | Pre-commit hooks |
| `scripts/validators/*.py` | Custom validators |

## Help

- 📖 [Full README](README.md)
- 🚀 [Quick Start](docs/quickstart.md)
- 🎨 [Customization Guide](docs/customization.md)
- 💡 [Examples](examples/)
- 🐛 [Issues](https://github.com/yourusername/giantcroissant-lunar-dev-rule/issues)

## Version

Current: **v1.0.0** (2025-10-08)

Base Rules: **v1.1.0**
.NET Stack: **v1.0.0**
