# Customization Guide

Learn how to customize GiantCroissant Lunar Dev Rules for your project's specific needs.

## Overview

The rules system uses a **layered merge strategy** where each layer can override or extend the previous:

```
Base Rules (universal)
    ↓
Stack Rules (language/framework specific)
    ↓
Adapters (AI agent specific)
    ↓
Local Overrides (project specific)
```

**Priority**: `local` > `adapters` > `stacks` > `base`

## Directory Structure

After installation:

```
.agent/
├── base/              # ✋ Don't edit - managed by installer
├── stacks/            # ✋ Don't edit - managed by installer
├── adapters/          # ✋ Don't edit - managed by installer
└── local/             # ✅ Edit here - your customizations
    ├── README.md
    ├── overrides.md       # Override/disable rules
    ├── custom-rules.md    # Add new rules
    └── variables.yaml     # Template variables (future)
```

## Customization Workflows

### 1. Disable a Rule

**Scenario**: Rule R-CODE-010 says "prefer editing over creating" but your project frequently creates new files.

**Solution**: Create `.agent/local/overrides.md`:

```markdown
# Project Overrides

## Disabled Rules

### R-CODE-010: Prefer Editing Over Creating
**Status**: DISABLED

**Reason**: Our microservices architecture requires frequent creation of new service files following template patterns.

**Alternative**: Use R-CODE-050 to ensure proper file organization instead.
```

### 2. Modify a Rule

**Scenario**: Base rules suggest max line length of 100, but your team uses 120.

**Solution**: In `.agent/local/overrides.md`:

```markdown
## Modified Rules

### R-CODE-030: Code Formatting
**Original**: Max line length 100 characters
**Override**: Max line length **120 characters**

**Reason**: Team consensus after discussion on 2025-10-01. Approved in ADR-0042.
```

### 3. Add Project-Specific Rules

**Scenario**: Your Unity project has specific naming conventions.

**Solution**: Create `.agent/local/custom-rules.md`:

```markdown
# Custom Rules for [Project Name]

## Naming Conventions

### R-LOCAL-001: Scene Naming Convention
- **Format**: `{Type}_{Name}_{Variant?}`
- **Examples**:
  - `MainMenu_Login`
  - `GamePlay_Level01_Night`
  - `Settings_Audio`
- **Location**: `Assets/Scenes/`
- **Enforcement**: Pre-commit hook (planned)

### R-LOCAL-002: ScriptableObject Configuration
- **What**: All game configuration uses ScriptableObjects
- **Where**: `Assets/Data/Config/`
- **Why**: Unity best practice for designer-friendly config
- **How**:
  ```csharp
  [CreateAssetMenu(menuName = "Config/Player Settings")]
  public class PlayerConfig : ScriptableObject { }
  ```

### R-LOCAL-003: Service Layer Pattern
- **Structure**:
  ```
  Services/
    Interfaces/
      IPlayerService.cs
    Implementations/
      PlayerService.cs
  ```
- **Naming**: Interface `I{Name}Service`, Implementation `{Name}Service`
- **Registration**: All services registered in `ServiceBootstrap.cs`
```

### 4. Configure for Your Stack

**Scenario**: You're using both .NET backend and Unity frontend.

**Solution**: Install multiple stacks:

```bash
./cli/install.sh --stack dotnet
```

Then reference both in your project documentation.

### 5. Team-Specific Workflow Rules

**Scenario**: Your team has specific Git workflow requirements.

**Solution**: In `.agent/local/custom-rules.md`:

```markdown
## Git Workflow

### R-LOCAL-010: Branch Naming
- **Feature**: `feature/{issue-number}-{short-description}`
- **Bugfix**: `bugfix/{issue-number}-{short-description}`
- **Hotfix**: `hotfix/{issue-number}-{short-description}`
- **Example**: `feature/123-add-player-inventory`

### R-LOCAL-011: Commit Message Format
```
<type>(<scope>): <subject>

<body>

Refs #<issue-number>
```
- **Types**: feat, fix, docs, style, refactor, test, chore
- **Scope**: component/module name
- **Subject**: Imperative mood, lowercase, no period
- **Body**: Why (not what), wrapped at 72 characters
```

## Advanced Customization

### Custom Pre-commit Hooks

Add project-specific hooks to `.pre-commit-config.yaml`:

```yaml
repos:
  # ... existing hooks ...

  # Custom project hooks
  - repo: local
    hooks:
      - id: check-scene-references
        name: Validate Unity Scene References
        entry: python scripts/validators/check_scene_refs.py
        language: system
        files: \.unity$
        pass_filenames: true
```

### Stack-Specific Customizations

#### For .NET Projects

Override in `.agent/local/overrides.md`:

```markdown
### R-DOTNET-030: Solution Structure
**Override**: We use flat structure instead of hierarchical

**Structure**:
```
src/
  ProjectName.Core/
  ProjectName.Api/
  ProjectName.Data/
tests/
  ProjectName.Core.Tests/
  ProjectName.Api.Tests/
```
```

#### For Unity Projects

Add Unity-specific rules in `.agent/local/custom-rules.md`:

```markdown
### R-LOCAL-020: Addressables Usage
- All runtime assets loaded via Addressables
- No `Resources` folder usage
- Asset groups organized by scene/feature
- Labels: `default`, `dlc-{name}`, `platform-{name}`

### R-LOCAL-021: Asset Bundle Strategy
- **Development**: Local asset bundles
- **Production**: CDN delivery via Addressables
- **Versioning**: Semantic versioning in catalog
```

### Variables (Future Feature)

Coming in v1.1.0 - `.agent/local/variables.yaml`:

```yaml
project:
  name: "MyAwesomeGame"
  version: "1.2.0"
  unity_version: "2022.3.10f1"

conventions:
  max_line_length: 120
  indent_style: spaces
  indent_size: 4

paths:
  scenes: "Assets/Scenes"
  prefabs: "Assets/Prefabs"
  scripts: "Assets/Scripts"
```

These variables can be referenced in templates: `{{project.name}}`, `{{conventions.max_line_length}}`

## Best Practices

### 1. Document Your Decisions

Always explain **why** you're overriding or adding rules:

```markdown
### R-CODE-010: Prefer Editing Over Creating
**Status**: DISABLED

**Reason**: Microservices architecture with code generation

**Decided**: Team meeting 2025-10-01

**Approved By**: Tech Lead, Architect

**ADR**: See docs/adr/0042-code-generation-strategy.md
```

### 2. Keep Overrides Minimal

Only override when truly necessary. Base rules exist for good reasons.

**Good**:
- Disable 2-3 rules that don't fit your workflow
- Modify settings (line length, etc.)
- Add 5-10 project-specific rules

**Bad**:
- Disable most base rules
- Complete rewrite of rule philosophy
- 50+ custom rules (consider contributing to base instead)

### 3. Review with Team

Changes to `.agent/local/` should be reviewed like code:

```bash
git add .agent/local/custom-rules.md
git commit -m "docs: Add Unity addressables rules"
# → Creates PR for team review
```

### 4. Version Your Customizations

Track when customizations were added:

```markdown
### R-LOCAL-005: API Versioning
**Added**: 2025-10-08
**Version**: 1.0.0
**Last Updated**: 2025-10-08
```

### 5. Link to ADRs

Reference Architecture Decision Records:

```markdown
### R-LOCAL-010: Use Event Sourcing
**ADR**: docs/adr/0031-event-sourcing.md
**Status**: Accepted
```

## Examples by Use Case

### Startup MVP

**Goal**: Move fast, minimal rules

```markdown
# Disabled Rules
- R-TST-010: Testing (MVP phase, defer until v1.0)
- R-DOC-020: RFC frontmatter (no RFCs yet)

# Custom Rules
- Ship fast, iterate
- Manual testing acceptable
- Document technical debt
```

### Enterprise Application

**Goal**: High quality, comprehensive governance

```markdown
# Additional Rules
- R-LOCAL-001: All APIs must have OpenAPI specs
- R-LOCAL-002: Security review required for auth changes
- R-LOCAL-003: Performance testing for DB queries
- R-LOCAL-004: Accessibility compliance (WCAG 2.1 AA)

# Modified Rules
- R-TST-010: 80% code coverage minimum (was optional)
```

### Open Source Library

**Goal**: Community friendly, well documented

```markdown
# Custom Rules
- R-LOCAL-001: Public APIs must have XML docs
- R-LOCAL-002: Breaking changes require major version bump
- R-LOCAL-003: CHANGELOG.md updated with every PR
- R-LOCAL-004: All examples in README must be tested
```

## Sharing Customizations

### Across Projects

If multiple projects share customizations:

1. Create a "stack" in your fork
2. Submit PR to add to official stacks
3. Or maintain private fork with company-specific stacks

### With Community

Contribute useful customizations back:

1. Open issue describing your use case
2. Share your `.agent/local/` files
3. Discuss converting to official stack or base rules

## Migration

### From Existing Rules

If you have existing agent rules:

```bash
# 1. Backup old rules
cp -r .agent .agent.backup

# 2. Install new rules
./cli/install.sh --stack dotnet

# 3. Migrate customizations
cat .agent.backup/custom-rules.md >> .agent/local/custom-rules.md

# 4. Review and edit
vim .agent/local/custom-rules.md
```

### Updating Customizations

When base rules update:

```bash
# 1. Update to latest
./cli/install.sh --stack dotnet

# 2. Review changes
git diff .agent/

# 3. Update local overrides if needed
vim .agent/local/overrides.md

# 4. Commit
git commit -am "chore: Update dev rules to v1.1.0"
```

## Troubleshooting

### "Rule conflicts between layers"

**Symptom**: AI agent seems confused about which rule to follow

**Solution**: Be explicit in `.agent/local/overrides.md`:

```markdown
### R-CODE-030 vs R-LOCAL-015: Line Length
**Resolution**: R-LOCAL-015 takes precedence (120 chars, not 100)
```

### "Too many custom rules"

**Symptom**: `.agent/local/custom-rules.md` is very long

**Solution**:
1. Split into multiple files (future feature)
2. Move stable rules to a company stack
3. Review if some should be base rules (contribute PR)

### "Team disagrees on overrides"

**Solution**:
1. Document disagreement in override
2. Time-box trial period
3. Revisit in ADR
4. Vote or defer to tech lead

## See Also

- [Quick Start](quickstart.md)
- [Base Rules](../templates/base/20-rules.md)
- [.NET Stack Rules](../templates/stacks/dotnet/rules.md)
- [Examples](../examples/)
