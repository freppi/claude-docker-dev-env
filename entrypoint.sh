#!/bin/bash
set -e

echo "Starting Claude dev container..."

mkdir -p /workspace/repo
mkdir -p /workspace/specs
mkdir -p /workspace/notes
mkdir -p /root/.ssh

# For SSH agent
ssh-keyscan github.com > /root/.ssh/known_hosts 2>/dev/null
chmod 644 /root/.ssh/known_hosts

# Clone repo
if [ -n "$REPO_URL" ]; then
  if [ ! -d "/workspace/repo/.git" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" /workspace/repo
  else
    echo "Repo already exists"
  fi

  cd /workspace/repo

  echo "Fetching latest..."
  git fetch --all

  # Detect default branch
  DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
  BRANCH=${BRANCH:-$DEFAULT_BRANCH}

  echo "Using branch: $BRANCH"

  # Checkout properly
  if git show-ref --verify --quiet refs/heads/$BRANCH; then
    git checkout $BRANCH
  else
    git checkout -b $BRANCH origin/$BRANCH
  fi

  git pull origin $BRANCH || true
fi

exec sleep infinity
