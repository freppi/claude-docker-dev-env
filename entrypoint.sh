#!/usr/bin/env bash
set -euo pipefail

echo "Starting Claude dev container..."

WORKSPACE_DIR="/workspace"
REPO_DIR="$WORKSPACE_DIR/repo"
SPECS_DIR="$WORKSPACE_DIR/specs"
NOTES_DIR="$WORKSPACE_DIR/notes"



mkdir -p "$REPO_DIR" "$SPECS_DIR" "$NOTES_DIR"
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# --------------------------------------------------
# SSH setup (only if using SSH repo)
# --------------------------------------------------
if [[ "${REPO_URL:-}" == git@* ]]; then
  if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    echo "WARNING: SSH_AUTH_SOCK not set. SSH agent may not work."
  else
    echo "SSH agent detected"
  fi

  # Extract host from REPO_URL
  # Handles:
  #   git@github.com:org/repo.git
  #   git@ssh.dev.azure.com:v3/org/project/repo
  HOST=$(echo "$REPO_URL" | sed -E 's#.*@(.*):.*#\1#')

  if [ -n "$HOST" ]; then
    echo "Adding SSH host to known_hosts: $HOST"
    ssh-keyscan -H "$HOST" >> /root/.ssh/known_hosts 2>/dev/null || true
    chmod 644 /root/.ssh/known_hosts
  fi
fi

# --------------------------------------------------
# Git setup
# --------------------------------------------------
if [ -n "${REPO_URL:-}" ]; then
  if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Cloning repository..."
    echo "Testing SSH connection..."
    ssh -T git@ssh.dev.azure.com || true

    echo "Running git clone..."
    GIT_SSH_COMMAND="ssh -v" git clone "$REPO_URL" "$REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
  else
    echo "Repository already exists"
  fi

  cd "$REPO_DIR"

  echo "Fetching latest..."
  git fetch --all --prune

  # Detect default branch safely
  DEFAULT_BRANCH=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')

  # Fallback if detection fails
  if [ -z "$DEFAULT_BRANCH" ]; then
    DEFAULT_BRANCH="main"
  fi

  BRANCH="${BRANCH:-$DEFAULT_BRANCH}"

  echo "Using branch: $BRANCH"

  # Checkout logic
  if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git checkout "$BRANCH"
  elif git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
    git checkout -b "$BRANCH" "origin/$BRANCH"
  else
    echo "Branch does not exist remotely, creating local branch: $BRANCH"
    git checkout -b "$BRANCH"
  fi

  # Pull latest (don’t fail hard if upstream missing)
  git pull origin "$BRANCH" || true
fi

# Only set if variables exist (avoids overwriting intentionally unset configs)
if [[ -n "${GIT_EMAIL:-}" ]]; then
  git config --global user.email "$GIT_EMAIL"
fi

if [[ -n "${GIT_NAME:-}" ]]; then
  git config --global user.name "$GIT_NAME"
fi

# --------------------------------------------------
# Claude/Antrhopic Setup
# --------------------------------------------------

export ANTHROPIC_MODEL="$ANTHROPIC_MODEL"
export ANTHROPIC_BASE_URL="$ANTHROPIC_BASE_URL"
export ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN"
export ANTHROPIC_DEFAULT_SONNET_MODEL="$ANTHROPIC_DEFAULT_SONNET_MODEL"
export ANTHROPIC_CUSTOM_HEADERS="$ANTHROPIC_CUSTOM_HEADERS"
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS="$CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS"

# --------------------------------------------------
# Done
# --------------------------------------------------
echo "Container ready."

exec sleep infinity
