#!/usr/bin/env bash
set -euo pipefail


echo "Setting up workspace structure"
WORKSPACE_DIR="/workspace"
REPO_DIR="$WORKSPACE_DIR/repo"
SPECS_DIR="$WORKSPACE_DIR/specs"
NOTES_DIR="$WORKSPACE_DIR/notes"



mkdir -p "$REPO_DIR" "$SPECS_DIR" "$NOTES_DIR"

#export ANTHROPIC_MODEL="$ANTHROPIC_MODEL"
#export ANTHROPIC_BASE_URL="$ANTHROPIC_BASE_URL"
#export ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN"
#export ANTHROPIC_DEFAULT_SONNET_MODEL="$ANTHROPIC_DEFAULT_SONNET_MODEL"
#export ANTHROPIC_CUSTOM_HEADERS="$ANTHROPIC_CUSTOM_HEADERS"
#export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS="$CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS"

# --------------------------------------------------
# Done
# --------------------------------------------------

exec sleep infinity
