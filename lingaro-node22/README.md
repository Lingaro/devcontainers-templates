# Lingaro Node 22 Devcontainer

Devcontainer definition that runs against an self-contained Dockerfile.

## Quick Start

1. Get `get-devcontainer.sh` file and put it in a desired empty folder.
   - If your OS is Windows use `git bash`.
   - Try `curl -fsSLo get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-node22/get-devcontainer.sh`
   - or `wget -O get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-node22/get-devcontainer.sh`
2. Run it. Template files will be downloaded.
3. Copy `.devcontainer/.env.example` to `.devcontainer/.env`.
4. Provide all required variables in `.devcontainer/.env`.
5. Open the folder in VS Code and use Dev Containers extension command "Reopen in Container".
6. Your workspace is mounted at `/app`.
7. Special commands:
   - PROD container can be rebuild by `prodbuild` command (alias for `docker compose up --build -d prod`).
   - PROD container bash can be accessed by `prodbash` command (alias for `docker compose exec prod bash`).

## Ports (host:container)

- 3000:3000 -> DEV container Node app.
- 3001:3000 -> PROD container Node app.
