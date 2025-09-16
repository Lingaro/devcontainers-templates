# Devcontainer Templates

Collection of Lingaro development container templates for consistent development environments.

## Quick Start

1. **Set up environment**: Copy `.env.example` to `.env` in your chosen template
2. **Open in VS Code**: Use "Dev Containers: Open Folder in Container" on the template directory (or run `docker compose up -d` for templates that build locally)
3. **Start developing**: Container automatically builds and configures your environment

## Available Templates

- **template-boilerplate** - Base template for creating new templates
- **lingaro-azure-py312-ubuntu24** - Python 3.12 with Azure tools (image pulled from ACR)
- **lingaro-azure-databricks-py312-ubuntu24** - Python 3.12 with Databricks and Azure tools (image pulled from ACR)
- **lingaro-azure-databricks-py312-ubuntu24-gemini** - Python 3.12 with Databricks, Azure tools and Gemini add-ons (image pulled from ACR)
- **lingaro-azure-databricks-py312-slim-ds** - Local build optimised for data science workloads with Jupyter, MLflow and caching

## Folder Structure

Most templates follow this structure:
```
template-name/
├── .devcontainer/
│   └── devcontainer.json     # VS Code container configuration
├── scripts/
│   ├── post-create.sh        # Runs after container creation
│   ├── post-attach.sh        # Runs when attaching to container
│   └── post-start.sh         # Runs when container starts
├── docker-compose.yml        # Container service definition
├── .env.example             # Environment variables template
└── README.md                # Template-specific documentation
```

> ℹ️ `lingaro-azure-databricks-py312-slim-ds` builds its Docker image locally and includes an additional `Dockerfile` plus setup scripts tailored to that workflow.

## Deployment

### Prerequisites
- **VS Code** with Dev Containers extension
- **Docker** or Docker Desktop
- **Azure Container Registry** access (set `AZURE_ACR_REGISTRY_NAME`)

### Steps
1. **Configure**: Copy `.env.example` to `.env` and fill in your credentials
2. **Open**: Open template folder in VS Code
3. **Build**: VS Code will prompt to reopen in container - accept
4. **Wait**: Container builds and configures automatically
5. **Develop**: Full development environment ready

### Alternative: Command Line
```bash
cd your-template-directory
docker-compose up -d
```

ACR-based templates track their container images with the `:latest` tag. The slim template builds locally, so rebuild whenever you change the Dockerfile.
