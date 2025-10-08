# Changelog

All notable changes to GiantCroissant Lunar Dev Rules will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-08

### Added

#### Core Infrastructure
- Initial repository structure with templates system
- Layered configuration approach (base → stacks → adapters → local)
- Shell-based installation script (`cli/install.sh`)
- Comprehensive README and documentation

#### Agent Rules (Base v1.1.0)
- Base rules from Winged Bean project:
  - 00-index.md - Version and overview
  - 10-principles.md - 7 core principles
  - 20-rules.md - 31 rules across 7 categories
  - 30-glossary.md - Domain terminology
- Meta documentation:
  - versioning.md - Versioning strategy
  - changelog.md - Historical changes
  - adapter-template.md - Template for new adapters

#### Stack Support
- **dotnet (v1.0.0)**:
  - .NET/C#/Unity-specific rules
  - ECS (Arch) conventions
  - Unity best practices
  - Adapters for Claude, Cursor, Windsurf, Copilot

#### Pre-commit Hooks
- **Base hooks**:
  - File hygiene (trailing whitespace, EOF, etc.)
  - Secret detection (GitLeaks v8.28.0)
  - Markdown linting (markdownlint v0.45.0)
  - YAML linting (yamllint v1.37.1)
  - JSON/XML validation
  - Large file detection

- **dotnet hooks**:
  - `dotnet format` integration
  - JetBrains cleanup/inspection (optional)
  - Python validators:
    - Issue metadata validator
    - Issue dependency validator
    - RFC/ADR frontmatter validator

#### Documentation
- Quick start guide (`docs/quickstart.md`)
- Example configuration (`examples/dotnet-unity/`)
- Installation instructions
- Customization guide

#### Examples
- .NET/Unity project example with:
  - Complete directory structure
  - Sample customizations
  - Integration examples
  - Team workflow guide

### Project Metadata
- MIT License
- .gitignore for Python and common IDEs
- Comprehensive README

## Roadmap

### [1.1.0] - Planned
- Node.js/TypeScript stack support
- Python stack support
- Advanced CLI with update command
- Template variable substitution

### [1.2.0] - Planned
- PowerShell installation script (Windows)
- GitHub Actions integration examples
- Pre-commit CI/CD templates
- Multi-stack project support

### [2.0.0] - Future
- npm/NuGet package distribution
- Interactive installer with prompts
- Auto-update mechanism
- Web-based configuration generator

## Migration Notes

### From Winged Bean
If you're migrating from the Winged Bean monorepo:

1. Remove `.agent/` directory from Winged Bean
2. Install from this repo: `./cli/install.sh --stack dotnet`
3. Migrate customizations from old `.agent/` to new `.agent/local/`
4. Update CLAUDE.md to point to new `.agent/` structure

## Credits

Extracted from the Winged Bean project by apprenticegc (2025-10-08).

## Links

- [GitHub Repository](https://github.com/yourusername/giantcroissant-lunar-dev-rule)
- [Documentation](docs/)
- [Issue Tracker](https://github.com/yourusername/giantcroissant-lunar-dev-rule/issues)
