# Template Boilerplate

A basic development container template that serves as a starting point for new projects.

## Quick Start

1. Copy this template directory and rename it to your project name
2. Update the configuration files with your specific requirements
3. Copy `.env.example` to `.env` and configure your environment variables
4. Open the directory in VS Code and use "Dev Containers: Open Folder in Container"

## What's Included

- **Pre-built container image** from Azure Container Registry
- **Python 3.12** runtime environment
- **Ubuntu 24.04** base image
- **Azure CLI** pre-installed
- **VS Code** integration with recommended extensions
- **Git** version control
- **Basic development tools** (curl, wget, vim, build-essential)

## Customization

### 1. Update Container Configuration

Edit `.devcontainer/devcontainer.json`:
- Change the `name` field to your project name
- Update the `service` name to match your project
- Add/remove VS Code extensions as needed
- Configure VS Code settings

### 2. Modify Docker Configuration

Edit `docker-compose.yml`:
- Update service name
- Change image name and tag (should reference your ACR image)
- Add additional services (databases, caches, etc.)
- Configure port mappings
- Add environment variables

### 4. Customize Setup Scripts

Edit scripts in `scripts/` directory:
- `post-create.sh`: Runs after container creation
- `post-attach.sh`: Runs when attaching to container
- `post-start.sh`: Runs when starting container

### 5. Environment Variables

Copy `.env.example` to `.env` and configure:
- Azure service principal credentials
- Azure Container Registry settings
- Application-specific variables
- Database connections
- API keys and secrets

## Development Workflow

1. **Container Setup**: Environment variables and dependencies are automatically configured
2. **Azure Authentication**: Automatic authentication with Azure Container Registry
3. **VS Code Integration**: Full IDE experience with debugging, IntelliSense, and extensions
4. **Port Forwarding**: Port 8000 is forwarded for web applications
5. **Volume Mounting**: Your workspace is mounted for persistent file changes

## File Structure

```
template-boilerplate/
├── .devcontainer/
│   └── devcontainer.json          # VS Code dev container configuration
├── scripts/
│   ├── post-create.sh            # Container creation setup
│   ├── post-attach.sh            # Container attachment setup
│   └── post-start.sh             # Container startup setup
├── docker-compose.yml            # Container orchestration
├── .env.example                  # Environment variables template
└── README.md                     # This file
```

## Testing Your Template

1. Build and test the container:
   ```bash
   docker-compose up --build -d
   docker-compose logs
   ```

2. Test with VS Code Dev Containers:
   - Open this directory in VS Code
   - Use "Dev Containers: Open Folder in Container"
   - Verify all extensions and tools work correctly

## Notes

- Uses pre-built images from Azure Container Registry
- Azure authentication is handled automatically during container creation
- Python dependencies are installed during container creation
- The container stays running with a sleep loop
- All development tools are pre-installed and configured in the base image