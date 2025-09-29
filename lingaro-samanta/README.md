# Lingaro Samanta Devcontainer

Devcontainer definition that runs against an GHCR-hosted images:

- `ghcr.io/lingaro-enterprise-poc/lingaro-samanta:latest`
- `ghcr.io/lingaro-enterprise-poc/lingaro-dbx164lts:latest`

## Links

[![Open in Dev Containers](https://img.shields.io/badge/Open%20in-Dev%20Containers-blue?logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/Lingaro-Enterprise-PoC/devcontainers-templates)

[![Open in Dev Containers (Insiders)](<https://img.shields.io/badge/Open%20in-Dev%20Containers%20(Insiders)-blue?logo=visualstudiocode>)](https://vscode.dev/redirect?url=vscode-insiders://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/devcontainers-templates)

## Quick Start

1. Provide all required variables in `.devcontainer/.env`.
2. Open this folder in VS Code and use Dev Containers extension command "Reopen in Container".
3. Your workspace is mounted at `/samanta`.

## Ports

- none

## Image expectation

This template pulls the prebuilt image `lingaro-samanta:latest` from your GitHub Packages. A local Dockerfile is intentionally not included here.
