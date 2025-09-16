# Lingaro Azure Databricks (ACR) DevContainer

Development container that pulls the `lingaro-azure-databricks-py312-ubuntu24:latest` image from your Azure Container Registry and exposes a ready-to-use Python 3.12 + Databricks setup.

## Quick Start

1. **Copy environment template**
   ```bash
   cd lingaro-azure-databricks-py312-ubuntu24
   cp .env.example .env
   ```
2. **Fill in secrets** – update `.env` with your Azure service principal, registry name (`AZURE_ACR_REGISTRY_NAME`), and optional Databricks host/token.
3. **Open in Dev Container** – in VS Code run "Dev Containers: Open Folder in Container" (or `docker compose up -d`).
4. **Authenticate** – inside the container run `az login` and, if needed, `databricks configure --token`.
5. **Confirm services** – forwarded port `8004` is free for your application. Python 3.12 and Azure CLI are pre-installed in the base image.

## Container Details

- Uses `docker-compose.yml` to start the `lingaro-azure-databricks-py312-ubuntu24` service.
- Pulls `${AZURE_ACR_REGISTRY_NAME}/lingaro-azure-databricks-py312-ubuntu24:latest` and keeps the container running via a sleep loop.
- Mounts the repository at `/workspaces/lingaro-azure-databricks-py312-ubuntu24` and loads variables from `.env`.
- Lightweight `post-*` scripts echo status messages; extend them with project-specific setup if required.

## Verify Databricks Connectivity

```bash
# Check environment variables
printenv DATABRICKS_HOST
printenv DATABRICKS_TOKEN

# CLI checks
databricks clusters list

databricks current-user me

# Python SDK check
python3 - <<'PY'
from databricks.sdk import WorkspaceClient
w = WorkspaceClient()
user = w.current_user.me()
print(f"Connected as: {user.user_name}")
PY
```

## File Layout

```
lingaro-azure-databricks-py312-ubuntu24/
├── .devcontainer/devcontainer.json
├── docker-compose.yml
├── scripts/
│   ├── post-attach.sh
│   ├── post-create.sh
│   └── post-start.sh
├── .env.example
└── README.md
```

Extend the scripts or VS Code configuration when you need extra tooling or automation.
