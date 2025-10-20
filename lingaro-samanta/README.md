# Lingaro Samanta Devcontainer

Devcontainer definition that runs against an GHCR-hosted images:

- `ghcr.io/lingaro/lingaro-samanta:latest`
- `ghcr.io/lingaro/lingaro-dbx164lts:latest`

## Quick Start

1. Get `get-devcontainer.sh` file and put it in a desired empty folder.
   - If your OS is Windows use `git bash`.
   - Try `curl -fsSLo get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-samanta/get-devcontainer.sh`
   - or `wget -O get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-samanta/get-devcontainer.sh`
2. Run it. Template files will be downloaded.
3. Copy `.devcontainer/.env.example` to `.devcontainer/.env`.
4. Provide all required variables in `.devcontainer/.env`.
5. Open the folder in VS Code and use Dev Containers extension command "Reopen in Container".
6. Your workspace is mounted at `/samanta`.
7. Databricks container (dbx) bash can be open by `dbx` command (alias for `docker compose exec dbx bash`).

## Ports

- none
