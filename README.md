# Claude Docker Dev Environment

A portable dev environment to work with Claude Code inside Docker, with secure Git access via SSH agent forwarding.

## What does it do?
- Consistent and isolated dev environment
- SSH agent forwarding allowing secure Git access without exposing keys
- Entrypoint script to set up workspace and clone git repo
- Claude runs inside the container and works directly with code

## Requirements
- Docker (with docker compose)
- Git
- SSH access to your repository (e.g. GitHub)

## SSH Setup (Required)

Make sure SSH works on your host machine:

```bash
ssh -T git@github.com
```

Start an SSH agent and add your key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/<your-private-key>
```

Your private key is usually `id_ed25519` or `id_rsa`, but may vary depending on your setup.

Verify:

```bash
ssh-add -l
```

## Setup

### 1. Clone this repository

```bash
git clone git@github.com:freppi/claude-docker-dev-env.git
cd claude-docker-dev-env
```

### 2. Create your environment file

```bash
cp .env.example .env
```

Edit `.env`:

```env
ANTHROPIC_API_KEY=your_api_key_here
REPO_URL=git@github.com:your/repo.git
```

### 3. Build and run

```bash
docker compose up --build -d
```

### 4. Enter container

```bash
docker compose exec claude bash
```

## Workspace Structure

```
/workspace
  repo/      # your git repo
  specs/     # feature descriptions for Claude
  notes/     # optional scratch space
```

## Restarting / Re-entering

Start container:

```bash
docker compose up -d
```

Enter container:

```bash
docker compose exec claude bash
```

Stop container:

```bash
docker compose down
```

## Reset workspace

If something breaks, remove workspace:

```bash
rm -rf workspace/repo
```

Then restart:

```bash
docker compose down
docker compose up -d
```
