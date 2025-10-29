# Lingaro Azure Python 3.12 DevContainer

A comprehensive Azure-focused development environment running Python 3.12 on Ubuntu with integrated AI tooling and cloud development capabilities. Built from the GitHub Container Registry image `ghcr.io/lingaro/lingaro-azure-py312-ubuntu24:latest`.

## Features

- **Python 3.12** with `uv` package manager for fast dependency management
- **Azure CLI** pre-installed and configured with Service Principal authentication
- **AI Development Tools** including Claude Dev, Qwen Coder, and GitHub Copilot extensions
- **VS Code Extensions** optimized for Python, Azure, and AI development
- **Zsh Terminal** with enhanced shell experience
- **Automatic Azure Authentication** via environment variables

## Quick Start

1. **Get the setup script** and put it in a desired empty folder:
   - If your OS is Windows use `git bash`
   - Try `curl -fsSLo get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-azure-py312-ubuntu24/get-devcontainer.sh`
   - or `wget -O get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-azure-py312-ubuntu24/get-devcontainer.sh`

2. **Run the script** - Template files will be downloaded:

   ```bash
   chmod +x get-devcontainer.sh
   ./get-devcontainer.sh
   ```

3. **Configure environment**:

   ```bash
   cp .devcontainer/.env.example .devcontainer/.env
   ```

4. **Update `.env` file** with your credentials:
   - **Required**: Set `AZURE_TENANT_ID`, `AZURE_CLIENT_ID`, and `AZURE_CLIENT_SECRET` for Azure Service Principal authentication
   - Set `API_KEY` for AI services (Claude, Qwen)
   - Note: Azure credentials are now required and will be automatically used for authentication

5. **Open in VS Code** and use Dev Containers extension command "Reopen in Container"

6. **Your workspace is mounted** at `/workspaces/lingaro-azure-py312-ubuntu24`

### Verification

After setup, verify your installation:

```bash
python3 --version       # Should show Python 3.12.x
az version              # Verify Azure CLI
uv --version            # Check uv package manager
az account show         # Verify Azure authentication (should show your service principal)
```

## Development Environment

### Pre-installed Tools

- **Python 3.12** with standard library
- **Azure CLI** for cloud resource management
- **uv** - Ultra-fast Python package manager
- **Git** for version control
- **curl, wget, jq** for API interactions
- **Build essentials** for compiling packages

### VS Code Extensions

- Python development (ms-python.python, black-formatter, pylint)
- Azure tools (azurecli, azure-account)
- AI assistants (Claude Dev, Qwen Coder, GitHub Copilot)

### Port Configuration

- **Port 8004** is forwarded and labeled for your applications
- Accessible at `http://localhost:8004` from your host machine

## AI Development Setup

This template includes integrated AI development tools:

### Claude AI Integration

```bash
# Claude API is pre-configured via environment variables
# ANTHROPIC_BASE_URL=https://llm.lingarogroup.com
# ANTHROPIC_MODEL=vertex_ai/claude-sonnet-4
```

### Qwen Coder Integration

```bash
# Qwen API configured as OpenAI-compatible endpoint
# OPENAI_BASE_URL=https://llm.lingarogroup.com
# OPENAI_MODEL=qwen3-coder
```

## Azure Development

### Service Principal Authentication

The container is now configured to use Azure Service Principal authentication automatically. Ensure your `.env` file contains:

```bash
AZURE_TENANT_ID=your-tenant-id-here
AZURE_CLIENT_ID=your-client-id-here
AZURE_CLIENT_SECRET=your-client-secret-here
```

### Additional Authentication Options

You can also use interactive authentication within the container:

```bash
# Login to Azure (opens browser)
az login

# Verify your account
az account show --output table

# List available subscriptions
az account list --output table
```

### Common Azure Operations

```bash
# Set default subscription
az account set --subscription "Your-Subscription-Name"

# List resource groups
az group list --output table

# Create a resource group
az group create --name myResourceGroup --location eastus
```

## Package Management with uv

This container uses `uv` for fast Python package management:

```bash
# Install packages
uv pip install requests pandas numpy

# Install from requirements.txt
uv pip install -r requirements.txt

# Create virtual environment
uv venv myproject
source myproject/bin/activate

# Install packages in virtual environment
uv pip install --python myproject/bin/python requests
```

## Customization

### Lifecycle Scripts

Located in `.devcontainer/scripts/`:

- `post-create.sh` - Runs once after container creation
- `post-start.sh` - Runs every time the container starts
- `post-attach.sh` - Runs when VS Code attaches to the container

### Adding Custom Extensions

Edit `.devcontainer/devcontainer.json`:

```json
"customizations": {
  "vscode": {
    "extensions": [
      "your.extension.id"
    ]
  }
}
```

## File Structure

```text
lingaro-azure-py312-ubuntu24/
├── .devcontainer/
│   ├── devcontainer.json     # DevContainer configuration
│   ├── docker-compose.yml    # Container orchestration
│   ├── Dockerfile            # Container image definition
│   ├── .env.example          # Environment template
│   └── scripts/              # Lifecycle scripts
│       ├── post-attach.sh
│       ├── post-create.sh
│       └── post-start.sh
├── get-devcontainer.sh       # Setup helper script
└── README.md                 # This file
```

## Troubleshooting

### Container Issues

```bash
# Rebuild container completely
Ctrl+Shift+P → "Dev Containers: Rebuild Container"

# Check container logs
docker logs <container-name>
```

### Python Issues

```bash
# Verify Python installation
which python3
python3 --version

# Check installed packages
uv pip list
```

### Azure CLI Issues

```bash
# Re-authenticate
az logout
az login

# Check configuration
az config list
```

## Best Practices

1. **Azure Service Principal**: Create a dedicated service principal for development with appropriate permissions
2. **Environment Variables**: Keep sensitive data in `.env` file, never commit it to version control
3. **Package Management**: Use `uv` for faster package installation
4. **Version Control**: Use `.gitignore` to exclude `.env` and virtual environments
5. **Resource Cleanup**: Stop containers when not in use to save resources
6. **Least Privilege**: Configure Azure service principal with minimal required permissions

## Support

For issues specific to this DevContainer template, please check:

- Container logs via Docker Desktop
- VS Code DevContainer documentation
- Azure CLI troubleshooting guides

This template provides a robust foundation for Azure and AI-powered Python development with modern tooling and best practices built-in.
