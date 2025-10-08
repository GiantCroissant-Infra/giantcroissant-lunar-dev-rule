# Agent Rules for GiantCroissant Lunar Dev Rule Repository

**Repository Purpose**: Develop and maintain reusable agent rules and pre-commit hooks for other projects.

---

## For AI Agents Working on This Repository

This is a **meta-repository** that creates the rule system used by other projects. To avoid confusion, we keep this repo's own agent configuration minimal.

### Core Guidelines

1. **Clarity over cleverness** - This repo must be easy to understand and modify
2. **Simple is better** - Avoid over-engineering the tooling
3. **Test before ship** - All changes must be tested with `--dry-run`
4. **Documentation first** - Update docs when changing templates
5. **Backwards compatibility** - Don't break existing installations

### Project Structure

```
giantcroissant-lunar-dev-rule/
├── templates/          # SOURCE OF TRUTH - what gets installed
│   ├── base/          # Base rules (v1.1.0)
│   ├── stacks/        # Stack-specific rules
│   └── hooks/         # Pre-commit configurations
│
├── cli/               # Installation tooling
├── docs/              # Documentation
├── examples/          # Example configurations
│
└── .agent/            # THIS DIRECTORY - minimal repo-specific rules
```

### Development Workflow

#### Adding/Modifying Rules

1. **Edit source templates**:
   - Base rules: `templates/base/20-rules.md`
   - Stack rules: `templates/stacks/{stack}/rules.md`

2. **Update version** in:
   - `templates/base/00-index.md`
   - `CHANGELOG.md`

3. **Test installation**:
   ```bash
   cd /tmp/test-project
   /path/to/giantcroissant-lunar-dev-rule/cli/install.sh --stack dotnet --dry-run
   ```

4. **Update documentation**:
   - `README.md`
   - `docs/quickstart.md`
   - `CHANGELOG.md`

#### Modifying Installation Script

1. **Edit**: `cli/install.sh`
2. **Test dry-run**: `./cli/install.sh --stack dotnet --dry-run`
3. **Test actual install** in a clean project
4. **Run shellcheck**: `shellcheck cli/install.sh`
5. **Update docs** if behavior changes

#### Adding New Stacks

1. **Create directory**: `mkdir -p templates/stacks/{stack-name}`
2. **Add rules**: `templates/stacks/{stack-name}/rules.md`
3. **Add hooks**: `templates/hooks/{stack-name}/pre-commit-config.yaml`
4. **Add adapters**: `templates/stacks/{stack-name}/adapters/` (optional)
5. **Update README** with new stack
6. **Add example**: `examples/{stack-name}/`
7. **Test installation**

### Code Style

#### Shell Scripts
- Use `#!/usr/bin/env bash`
- Add `set -e` for error handling
- Use shellcheck-compliant syntax
- Add comments for complex logic
- Use functions for reusable code

#### Markdown
- Use GitHub-flavored markdown
- Keep line length reasonable (no hard limit)
- Use code blocks with language tags
- Include examples

#### Python (for validators)
- Follow PEP 8
- Add docstrings
- Use type hints
- Keep scripts standalone (minimal dependencies)

### Testing

Before committing:

```bash
# Test pre-commit hooks
pre-commit run --all-files

# Test installer (dry run)
./cli/install.sh --stack dotnet --dry-run

# Test installer (actual) in clean project
cd /tmp/test-project && git init
/path/to/giantcroissant-lunar-dev-rule/cli/install.sh --stack dotnet

# Shellcheck
shellcheck cli/install.sh

# Markdown lint
markdownlint README.md docs/*.md
```

### Security

- **Never commit secrets** - This repo will be public
- **Validate user input** in install script
- **Use `set -e`** in shell scripts to catch errors
- **Test with untrusted input** (edge cases)

### Documentation Standards

- **README.md**: High-level overview, quick start
- **docs/quickstart.md**: Step-by-step tutorial
- **docs/customization.md**: Deep dive on customization
- **CHANGELOG.md**: Version history (keep updated!)
- **examples/**: Working configurations

### Release Process

1. **Update version** in:
   - `templates/base/00-index.md`
   - `CHANGELOG.md`
   - `README.md`

2. **Test thoroughly**:
   - Install in clean project
   - Test all supported stacks
   - Verify pre-commit hooks work

3. **Commit and tag**:
   ```bash
   git commit -m "chore: Release v1.1.0"
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push --tags
   ```

4. **Update GitHub release** with CHANGELOG notes

### Common Tasks

#### Update Base Rules from Winged Bean

If syncing changes from Winged Bean:

```bash
# Copy updated files
cp /path/to/winged-bean/.agent/base/*.md templates/base/

# Review changes
git diff templates/base/

# Update version and changelog
vim templates/base/00-index.md
vim CHANGELOG.md

# Commit
git commit -m "feat: Sync base rules from Winged Bean vX.Y.Z"
```

#### Add New Pre-commit Hook

1. Add to appropriate config:
   - Universal: `templates/hooks/base/pre-commit-config.yaml`
   - Stack-specific: `templates/hooks/{stack}/pre-commit-config.yaml`

2. Test locally:
   ```bash
   pre-commit try-repo . hook-name --verbose --all-files
   ```

3. Document in README and quickstart guide

4. Add example to `examples/`

### Rule Philosophy

When developing rules, follow these principles (from `templates/base/10-principles.md`):

1. **Clarity over cleverness** - Rules should be easy to understand
2. **Proactive security** - Security is non-negotiable
3. **Pragmatic quality** - Balance rigor with velocity
4. **Convention over configuration** - Sensible defaults
5. **Ask when uncertain** - Rules should encourage clarification
6. **Respectful of context** - Stack-specific needs matter
7. **Evolvable** - Rules can be updated as best practices change

### Reference Materials

- **Our base rules**: `templates/base/20-rules.md` (31 rules)
- **Our principles**: `templates/base/10-principles.md` (7 principles)
- **Versioning guide**: `templates/meta/versioning.md`
- **Pre-commit docs**: https://pre-commit.com

### Meta-Confusion Avoidance

**Important**: This `.agent/` directory is for developing the rule system itself, NOT the full rule system we ship.

- ✅ Keep this simple and focused on repo development
- ✅ Reference `templates/` as the canonical rules
- ❌ Don't duplicate rules from `templates/base/` here
- ❌ Don't run the installer on this repo (creates circular confusion)

### Questions?

- Review existing templates in `templates/`
- Check examples in `examples/`
- Read the source code in `cli/install.sh`
- Consult `EXTRACTION_SUMMARY.md` for design decisions

---

**Version**: 1.0.0
**Last Updated**: 2025-10-08
**Maintained By**: apprenticegc
