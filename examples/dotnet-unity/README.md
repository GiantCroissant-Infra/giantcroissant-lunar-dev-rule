# Example: .NET Unity Project Configuration

This directory shows an example configuration for a .NET/Unity game project.

## Installation Result

After running:
```bash
./cli/install.sh --stack dotnet
```

Your project will have this structure:

```
your-unity-project/
├── .agent/
│   ├── base/
│   │   ├── 00-index.md
│   │   ├── 10-principles.md
│   │   ├── 20-rules.md
│   │   └── 30-glossary.md
│   ├── stacks/
│   │   └── dotnet/
│   │       ├── rules.md
│   │       └── adapters/
│   ├── adapters/
│   │   ├── claude.md
│   │   ├── cursor.md
│   │   ├── windsurf.md
│   │   └── copilot.md
│   └── local/
│       ├── README.md
│       ├── overrides.md (create this)
│       └── custom-rules.md (create this)
├── .pre-commit-config.yaml
├── scripts/
│   └── validators/
│       ├── pre_commit_issue_validator.py
│       ├── validate_issue_dependencies.py
│       └── validate_frontmatter.py
└── CLAUDE.md (optional - points to .agent/)
```

## Example Customizations

### .agent/local/overrides.md

```markdown
# Project Overrides for MyUnityGame

## Modified Settings
- Max line length: 120 (default: 100)
- Unity version: 2022.3 LTS

## Disabled Rules
None - all base rules apply
```

### .agent/local/custom-rules.md

```markdown
# Custom Rules for MyUnityGame

### R-LOCAL-001: Use ScriptableObject for Configuration
- All game configuration should use ScriptableObjects
- Store in Assets/Data/ directory
- Use [CreateAssetMenu] attribute

### R-LOCAL-002: Scene Naming Convention
- Scenes use PascalCase
- Prefix with type: MainMenu, GamePlay_Level1, Settings
- Test scenes go in Assets/Scenes/Test/

### R-LOCAL-003: Prefab Organization
- Prefabs organized by type in Assets/Prefabs/
- Subdirectories: Characters/, Environment/, UI/, Effects/
- Use nested prefabs for composition
```

### CLAUDE.md (Root Level)

```markdown
# Claude Code Instructions

**Canonical rules**: `.agent/base/`
**Claude adapter**: `.agent/adapters/claude.md`
**Stack rules**: `.agent/stacks/dotnet/`
**Project rules**: `.agent/local/`

---

## Quick Start

This Unity project uses **GiantCroissant Lunar Dev Rules** v1.0.0.

### Critical Project-Specific Rules
- Unity version: **2022.3 LTS**
- Use **Arch ECS** for gameplay systems
- **Terminal.Gui** for debug console UI
- See `.agent/local/custom-rules.md` for full project rules

### Architecture
- **ECS**: Arch library for entity management
- **Input**: Custom input system with Terminal.Gui integration
- **Scenes**: Multi-scene setup with additive loading

For complete rules, see `.agent/` directory.
```

## Pre-commit Configuration

The installed `.pre-commit-config.yaml` includes:

- ✅ File hygiene (trailing whitespace, EOF, etc.)
- ✅ Secret detection (GitLeaks)
- ✅ .NET formatting (`dotnet format`)
- ✅ Markdown/YAML linting
- ✅ Custom validators (issue metadata, RFC frontmatter)

### Running Hooks

```bash
# Test all hooks
pre-commit run --all-files

# Run just .NET formatting
pre-commit run dotnet-format

# Run secret detection
pre-commit run gitleaks

# Skip hooks for WIP commit
git commit --no-verify
```

## Integration with Unity

### Unity-Specific Settings

Unity generates many files that should be excluded from hooks:

```yaml
# In .pre-commit-config.yaml
hooks:
  - id: trailing-whitespace
    exclude: |
      (?x)^(
        .*\.meta$|           # Unity meta files
        .*\.asset$|          # Unity asset files
        .*\.unity$|          # Unity scene files
        ProjectSettings/.*   # Unity project settings
      )$
```

### Recommended Unity .gitignore

```gitignore
# Unity generated
[Ll]ibrary/
[Tt]emp/
[Oo]bj/
[Bb]uild/
[Bb]uilds/
[Ll]ogs/
UserSettings/

# Never commit
*.pidb.meta
*.pdb.meta
*.mdb.meta

# But do commit
!*.meta
```

## AI Agent Usage

### With Claude Code

Claude automatically reads the `.agent/` directory. You can reference rules:

```
User: "Add a new enemy type"
Claude: Following R-LOCAL-001, I'll create a ScriptableObject configuration...
```

### With Cursor

Configure Cursor to read `.agent/adapters/cursor.md`:

1. Open Cursor Settings
2. Add `.agent/adapters/cursor.md` to context
3. (Optional) Add project-specific rules from `.agent/local/`

### With Windsurf

Similar to Cursor, configure to read `.agent/adapters/windsurf.md`.

## Team Workflow

### Setup for New Team Members

1. Clone repository
2. Install pre-commit: `pip install pre-commit` or `brew install pre-commit`
3. Install hooks: `pre-commit install`
4. Open Unity project (Unity will import assets)
5. Start coding!

### Updating Rules

When dev rules are updated:

```bash
# Re-run installer (preserves local customizations)
curl -fsSL https://raw.githubusercontent.com/yourusername/giantcroissant-lunar-dev-rule/main/cli/install.sh | bash -s -- --stack dotnet

# Review changes
git diff .agent/

# Commit updates
git add .agent/
git commit -m "chore: Update dev rules to v1.1.0"
```

## Tips

1. **Start simple** - Use base rules first, add customizations as needed
2. **Document decisions** - Add project-specific rules to `.agent/local/custom-rules.md`
3. **Commit everything** - The `.agent/` directory should be in version control
4. **Review with team** - Agree on rule overrides before implementing
5. **Iterate** - Rules can evolve as the project grows

## See Also

- [Base Rules](../../templates/base/20-rules.md)
- [.NET Stack Rules](../../templates/stacks/dotnet/rules.md)
- [Customization Guide](../../docs/customization.md)
