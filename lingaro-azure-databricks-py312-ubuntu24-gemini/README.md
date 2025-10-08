# Lingaro Azure Databricks Gemini DevContainer

DevContainer variant that pulls the `lingaro-azure-databricks-py312-ubuntu24-gemini:latest` image from your GitHub Container Registry and adds support for Gemini tooling alongside Azure and Databricks integrations.

## Quick Start

1. **Prepare environment file**
   ```bash
   cd lingaro-azure-databricks-py312-ubuntu24-gemini
   cp .env.example .env
   ```
2. **Configure `.env`** – provide Azure service principal values, registry name (`AZURE_ACR_REGISTRY_NAME`), Databricks host/token (if needed), and secrets such as `GEMINI_API_KEY`.
3. **Launch the container** – open the folder in VS Code using Dev Containers or run `docker compose up -d`.
4. **Sign in** – execute `az login` and `databricks configure --token` inside the container to finish authentication.
5. **Start coding** – port `8000` is forwarded and the recommended Python tooling is available out of the box.

## Features

- Pulls `${AZURE_ACR_REGISTRY_NAME}/lingaro-azure-databricks-py312-ubuntu24-gemini:latest` via `docker-compose.yml`.
- VS Code automatically installs: `ms-python.python`, `ms-python.pylint`, and `ms-python.black-formatter`.
- `.env` gives you placeholders for Azure, Databricks, generic values, and Gemini API keys.
- Lifecycle hooks under `scripts/` let you extend the setup when the container is created, started, or attached.

## Verification

```bash
# Python / formatting toolchain
python3 --version
black --version
pylint --version

# Optional: confirm Gemini credentials are exposed
printenv GEMINI_API_KEY
```

## File Layout

```
lingaro-azure-databricks-py312-ubuntu24-gemini/
├── .devcontainer/devcontainer.json
├── docker-compose.yml
├── scripts/
│   ├── post-attach.sh
│   ├── post-create.sh
│   └── post-start.sh
├── .env.example
└── README.md
```

Adapt the image or scripts if you need extra SDKs beyond what the Gemini variant already contains.
