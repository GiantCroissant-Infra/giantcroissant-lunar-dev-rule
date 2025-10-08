#!/usr/bin/env bash
# Installation script for GiantCroissant Lunar Dev Rules
# Usage: curl -fsSL https://raw.githubusercontent.com/you/giantcroissant-lunar-dev-rule/main/cli/install.sh | bash -s -- --stack dotnet

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
STACK=""
REPO_URL="https://github.com/yourusername/giantcroissant-lunar-dev-rule"
BRANCH="main"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --stack)
      STACK="$2"
      shift 2
      ;;
    --repo)
      REPO_URL="$2"
      shift 2
      ;;
    --branch)
      BRANCH="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 --stack <stack-name> [options]"
      echo ""
      echo "Options:"
      echo "  --stack <name>      Stack to install (dotnet, nodejs, python, etc.)"
      echo "  --repo <url>        Repository URL (default: GitHub URL)"
      echo "  --branch <name>     Branch to use (default: main)"
      echo "  --dry-run           Show what would be installed without installing"
      echo "  -h, --help          Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0 --stack dotnet"
      echo "  $0 --stack nodejs --branch develop"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Validate stack
if [ -z "$STACK" ]; then
  echo -e "${RED}Error: --stack is required${NC}"
  echo "Run with --help for usage information"
  exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  GiantCroissant Lunar Dev Rules Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Stack:       ${GREEN}${STACK}${NC}"
echo -e "Repository:  ${BLUE}${REPO_URL}${NC}"
echo -e "Branch:      ${YELLOW}${BRANCH}${NC}"
echo -e "Dry run:     ${DRY_RUN}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
  echo -e "${RED}Error: Not in a git repository${NC}"
  echo "Please run this script from the root of your git repository"
  exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo -e "${YELLOW}→${NC} Downloading rules from ${REPO_URL}..."

# For local testing, check if we're running from the repo
if [ -f "../templates/base/00-index.md" ] && [ "$REPO_URL" = "https://github.com/yourusername/giantcroissant-lunar-dev-rule" ]; then
  echo -e "${YELLOW}  (Using local files for testing)${NC}"
  cp -r ../templates "$TEMP_DIR/"
else
  # Clone the repository (sparse checkout for efficiency)
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR/repo" 2>/dev/null || {
    echo -e "${RED}Error: Failed to clone repository${NC}"
    exit 1
  }
  cp -r "$TEMP_DIR/repo/templates" "$TEMP_DIR/"
fi

# Validate stack exists
if [ ! -d "$TEMP_DIR/templates/stacks/$STACK" ]; then
  echo -e "${RED}Error: Stack '$STACK' not found${NC}"
  echo ""
  echo "Available stacks:"
  for stack_dir in "$TEMP_DIR/templates/stacks"/*; do
    if [ -d "$stack_dir" ]; then
      echo "  - $(basename "$stack_dir")"
    fi
  done
  exit 1
fi

echo -e "${GREEN}✓${NC} Downloaded rules"
echo ""

# Function to copy files
copy_files() {
  local src="$1"
  local dst="$2"
  local description="$3"

  if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would copy $description to $dst"
  else
    mkdir -p "$dst"
    cp -r "$src"/* "$dst/"
    echo -e "${GREEN}✓${NC} Installed $description"
  fi
}

# Install agent rules
echo -e "${YELLOW}→${NC} Installing agent rules..."

# Base rules
copy_files "$TEMP_DIR/templates/base" ".agent/base" "base rules"

# Stack-specific rules
if [ -f "$TEMP_DIR/templates/stacks/$STACK/rules.md" ]; then
  copy_files "$TEMP_DIR/templates/stacks/$STACK" ".agent/stacks/$STACK" "stack rules"
fi

# Adapters (if they exist in the stack)
if [ -d "$TEMP_DIR/templates/stacks/$STACK/adapters" ]; then
  copy_files "$TEMP_DIR/templates/stacks/$STACK/adapters" ".agent/adapters" "adapters"
fi

# Create local customization directory
if [ ! -d ".agent/local" ]; then
  if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would create .agent/local directory"
  else
    mkdir -p ".agent/local"
    cat > ".agent/local/README.md" << 'EOF'
# Local Agent Rules

This directory is for project-specific customizations.

## Files

- `overrides.md` - Override or disable specific rules
- `custom-rules.md` - Add project-specific rules
- `variables.yaml` - Template variables (optional)

## Example overrides.md

```markdown
# Project Overrides

## Disabled Rules
- R-CODE-010: disabled (we prefer creating new files)

## Custom Settings
- Max line length: 120 (instead of default 100)
```

These files are typically committed to version control.
EOF
    echo -e "${GREEN}✓${NC} Created .agent/local directory"
  fi
fi

echo ""

# Install pre-commit hooks
echo -e "${YELLOW}→${NC} Installing pre-commit hooks..."

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
  echo -e "${YELLOW}⚠${NC}  pre-commit not found"
  echo "   Install with: pip install pre-commit"
  echo "   or: brew install pre-commit"
  echo ""
else
  # Merge base + stack configs
  if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would install pre-commit config"
  else
    # Start with base config
    cp "$TEMP_DIR/templates/hooks/base/pre-commit-config.yaml" ".pre-commit-config.yaml"

    # If stack has specific hooks, use those instead
    if [ -f "$TEMP_DIR/templates/hooks/$STACK/pre-commit-config.yaml" ]; then
      cp "$TEMP_DIR/templates/hooks/$STACK/pre-commit-config.yaml" ".pre-commit-config.yaml"
    fi

    echo -e "${GREEN}✓${NC} Installed pre-commit configuration"

    # Install validators if they exist
    if [ -d "$TEMP_DIR/templates/hooks/python/validators" ]; then
      mkdir -p "scripts/validators"
      cp "$TEMP_DIR/templates/hooks/python/validators"/*.py "scripts/validators/" 2>/dev/null || true
      echo -e "${GREEN}✓${NC} Installed Python validators"
    fi

    # Install pre-commit hooks
    echo -e "${YELLOW}→${NC} Installing git hooks..."
    pre-commit install --install-hooks
    echo -e "${GREEN}✓${NC} Git hooks installed"
  fi
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Installed:"
echo "  • Agent rules in .agent/"
echo "  • Pre-commit hooks in .pre-commit-config.yaml"
echo "  • Validators in scripts/validators/ (if applicable)"
echo ""
echo "Next steps:"
echo "  1. Review .agent/local/README.md for customization options"
echo "  2. Run 'pre-commit run --all-files' to test hooks"
echo "  3. Commit the new files to version control"
echo ""
