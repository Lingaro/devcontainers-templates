# Lingaro Samanta Devcontainer

Devcontainer definition that runs against an ACR-hosted image `${AZURE_ACR_REGISTRY_NAME}/lingaro-samanta:latest`.

## Links

[![Open in Dev Containers](https://img.shields.io/badge/Open%20in-Dev%20Containers-blue?logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/Lingaro-Enterprise-PoC/devcontainers-templates)

[![Open in Dev Containers (Insiders)](<https://img.shields.io/badge/Open%20in-Dev%20Containers%20(Insiders)-blue?logo=visualstudiocode>)](https://vscode.dev/redirect?url=vscode-insiders://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/this-repo)

-

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Open%20in&message=Dev%20Containers&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=<URL_REPO>)

[![Open in Dev Containers (Insiders)](<https://img.shields.io/static/v1?label=Open%20in&message=Dev%20Containers%20(Insiders)&color=blue&logo=visualstudiocode>)](https://insiders.vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=<URL_REPO>)

## Quick Start

1. Copy `.env.example` to `.env` and set `AZURE_ACR_REGISTRY_NAME` to your registry (e.g., `acrdevcontainers.azurecr.io`).
2. Open this folder in VS Code and Reopen in Container.
3. Your workspace is mounted at `/workspaces` and port 3000 is forwarded.

## Pull and run from Azure Container Registry

Prereqs:

- Docker is running
- Azure CLI installed and signed in
- `.env` contains all required variables

```bash
# To sign in azure:
export REGISTRY_HOST="${AZURE_ACR_REGISTRY_NAME}"
export REGISTRY_NAME="${REGISTRY_HOST%%.azurecr.io}"

az login
az acr login --name "$REGISTRY_NAME"

# optional:
# To verify the image exists
az acr repository list --name "$REGISTRY_NAME" --output table | grep -i lingaro-samanta || echo "Warning: lingaro-samanta image not found in registry!"
az acr repository list --name "$REGISTRY_NAME" --output table | grep -i lingaro-samanta-dbx164lts || echo "Warning: lingaro-samanta-dbx164lts image not found in registry!"
```

## Ports

- none

## Image expectation

This template pulls the prebuilt image `lingaro-samanta:latest` from your ACR. A local Dockerfile is intentionally not included here. Make sure the image exists in `${AZURE_ACR_REGISTRY_NAME}`.
