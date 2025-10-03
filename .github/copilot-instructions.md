# DevContainer Templates Project Guide

This repository contains Lingaro's collection of development container templates for consistent, production-ready development environments across Azure, Databricks, and data science workflows.

## Project Architecture

### Template Types
- **ACR-based templates** (`lingaro-azure-*`): Pull pre-built images from Azure Container Registry
- **Local build templates** (`*-slim-ds`): Build Docker images locally with optimized caching
- **Boilerplate template**: Base template for creating new variants

### Core Components
- `docker-compose.yml`: Container orchestration with environment-specific configurations
- `scripts/post-*.sh`: Lifecycle hooks (create, attach, start) for automated setup
- `.env.example`: Template for required environment variables
- `requirements.txt`: Python dependencies (local build templates only)

## Development Workflows

### Creating New Templates
1. Copy `template-boilerplate/` directory
2. Update service names in `docker-compose.yml` to match directory name
3. Modify ACR image reference or add `Dockerfile` for local builds
4. Customize lifecycle scripts in `scripts/`
5. Update `.env.example` with template-specific variables

### Testing Templates
```bash
cd template-name/
cp .env.example .env
# Configure Azure credentials in .env
docker compose build  # Local builds only
docker compose up -d
docker exec -it <container-name> zsh
```

### VS Code Integration
Templates integrate with VS Code DevContainers extension. Missing `.devcontainer/devcontainer.json` files indicate VS Code opens the entire docker-compose service directly.

## Project-Specific Patterns

### Environment Variable Hierarchy
1. `.env.example` provides defaults and documentation
2. `.env` overrides for local development (gitignored)
3. `docker-compose.yml` environment section for runtime configuration

### Docker Optimization (Slim-DS Templates)
- **Layer ordering**: System packages → UV → requirements → Azure CLI → shell setup
- **Persistent caches**: UV and pip caches mounted as named volumes
- **Build performance**: `COMPOSE_BAKE=true` enables Docker Buildx optimizations

### Port Management Convention
- Jupyter Lab: `8888` (configurable via `JUPYTER_PORT`)
- MLflow UI: `5000` (configurable via `MLFLOW_PORT`) 
- Application: `8000` (configurable via `APP_PORT`)
- ACR templates use offset ports (e.g., `8005:8000`) to avoid conflicts

### Azure Integration Patterns
All templates require Azure service principal authentication:
```bash
AZURE_TENANT_ID=<tenant-id>
AZURE_CLIENT_ID=<client-id>
AZURE_CLIENT_SECRET=<client-secret>
AZURE_ACR_REGISTRY_NAME=<registry-name>  # ACR templates only
```

### Script Lifecycle Hooks
- `post-create.sh`: One-time setup after container creation (package installs, auth)
- `post-attach.sh`: Runs when VS Code attaches (lightweight startup tasks)
- `post-start.sh`: Runs when container starts (service startup, health checks)

## Key Files to Reference

- `lingaro-azure-databricks-py312-slim-ds/`: Full-featured local build example
- `template-boilerplate/`: Minimal ACR-based template structure  
- `scripts/setup-zsh.sh`: Shell customization patterns for enhanced developer experience
- Root `README.md`: User-facing documentation structure and deployment instructions

## Critical Dependencies

- Azure Container Registry access for ACR-based templates
- Docker or Docker Desktop with BuildKit support
- VS Code with Dev Containers extension for full IDE integration
- Azure CLI authentication for Azure resource access

When modifying templates, preserve the environment variable patterns, script naming conventions, and volume mount structure to maintain consistency across the template collection.