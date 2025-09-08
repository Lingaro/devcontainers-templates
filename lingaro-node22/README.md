# Lingaro Node 22 Devcontainer

Devcontainer definition that runs against an ACR-hosted image `${AZURE_ACR_REGISTRY_NAME}/lingaro-node22:latest` based on Node 22 slim, with Python utilities and uv preinstalled.

## Quick Start

1. Copy `.env.example` to `.env` and set `AZURE_ACR_REGISTRY_NAME` to your registry (e.g., `acrdevcontainers.azurecr.io`).
2. Open this folder in VS Code and Reopen in Container.
3. Your workspace is mounted at `/workspaces` and port 3000 is forwarded.

## Pull and run from Azure Container Registry

Prereqs: Docker running, Azure CLI installed and signed in, `.env` contains `AZURE_ACR_REGISTRY_NAME` and `AZURE_SUBSCRIPTION_ID`.

```bash
# from this folder (lingaro-node22)
export REGISTRY_HOST="${AZURE_ACR_REGISTRY_NAME}"
export REGISTRY_NAME="${REGISTRY_HOST%%.azurecr.io}"
export SUBSCRIPTION_ID="${AZURE_SUBSCRIPTION_ID}"

az account set --subscription "$SUBSCRIPTION_ID" || az login && az account set --subscription "$SUBSCRIPTION_ID"
az acr login --name "$REGISTRY_NAME"

# optional: verify the repo exists
az acr repository list --name "$REGISTRY_NAME" --output table | grep -i lingaro-node22 || echo "Warning: lingaro-node22 image not found in registry!"

# pull and start the service
docker pull "$REGISTRY_HOST/lingaro-node22:latest"
docker compose up -d

# stop when needed
# docker compose down
```

## Ports

- 3000 -> Node app default (exposed by the base image).

## Image expectation

This template pulls the prebuilt image `lingaro-node22:latest` from your ACR. A local Dockerfile is intentionally not included here. Make sure the image exists in `${AZURE_ACR_REGISTRY_NAME}`.
