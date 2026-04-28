# Claude Docker Dev Environment
Docker image for .NET and REACT dev environment.
Persistence on host, so create a new folder and run container from there.

## Docker file includes
- Git
- Dotnet
- Node.js

## Start scripts
### Initial run
docker run -it \
  --name claude-dev \
  -v "$PWD":/workspace \
  -v /home/fredrik/.ssh/id_ed25519:/root/.ssh/id_ed25519:ro \
  -v /home/fredrik/.ssh/id_ed25519.pub:/root/.ssh/id_ed25519.pub:ro \
  -v /home/fredrik/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
  -e GIT_SSH_COMMAND="ssh -i /root/.ssh/id_ed25519 -o IdentitiesOnly=yes" \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -e REPO_URL=git@github.com:freppi/alarm-monitor.git \
  claude-code bash

#### Start again
docker start -ai claude-dev

### Run in background
docker run -dit \
  --name claude-dev \
  -v "$PWD":/workspace \
  ... \
  claude-code bash

#### Attach anytime
docker exec -it claude-dev bash

### Jump into running container
docker exec -it claude-dev bash




