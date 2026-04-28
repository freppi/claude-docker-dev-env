#!/bin/bash
set -e

echo "🚀 Starting Claude dev container..."

mkdir -p /workspace/repo
mkdir -p /workspace/specs
mkdir -p /workspace/notes

if [ -n "$REPO_URL" ]; then
  if [ ! -d "/workspace/repo/.git" ]; then
    echo "📦 Cloning repository..."
    git clone "$REPO_URL" /workspace/repo
  else
    echo "✅ Repo already exists"
  fi

  cd /workspace/repo

  echo "🔄 Fetching latest..."
  git fetch origin

  DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
  BRANCH=${BRANCH:-$DEFAULT_BRANCH}

  echo "🌿 Using branch: $BRANCH"

  git checkout $BRANCH || git checkout -b $BRANCH origin/$BRANCH
  git pull origin $BRANCH || true
fi

exec sleep infinity
