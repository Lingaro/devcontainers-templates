# Lingaro Azure Python 3.12 (ACR) DevContainer

Prebuilt Azure-focused development environment that runs from the `lingaro-azure-py312-ubuntu24:latest` image published in your Azure Container Registry.

## Quick Start

1. **Prepare configuration**
   ```bash
   cd lingaro-azure-py312-ubuntu24
   cp .env.example .env
   ```
2. **Update `.env`** – supply your Azure service principal credentials and registry name (`AZURE_ACR_REGISTRY_NAME`). Databricks variables are optional.
3. **Launch the container** – open the folder in VS Code with Dev Containers or start it manually with `docker compose up -d`.
4. **Authenticate Azure** – run `az login` inside the container to use the Azure CLI.
5. **Start building** – port `8005` forwards to `8000` inside the container for applications you run.

## Container Details

- `docker-compose.yml` references `${AZURE_ACR_REGISTRY_NAME}/lingaro-azure-py312-ubuntu24:latest`.
- Workspace directory is mounted at `/workspaces/lingaro-azure-py312-ubuntu24` with environment variables loaded from `.env`.
- Post lifecycle scripts simply echo status hooks; customise them for extra provisioning if needed.

## Verification

```bash
# Confirm Python & Azure CLI
python3 --version
az account show --output table

# Optional Databricks CLI smoke test
if command -v databricks >/dev/null; then
  databricks --version
fi
```

## File Layout

```
lingaro-azure-py312-ubuntu24/
├── .devcontainer/devcontainer.json
├── docker-compose.yml
├── scripts/
│   ├── post-attach.sh
│   ├── post-create.sh
│   └── post-start.sh
├── .env.example
└── README.md
```

Use this template as the baseline for Azure-centric projects that do not require Databricks toolchain preinstalls.
