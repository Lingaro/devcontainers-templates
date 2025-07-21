# Devcontainer Templates

This repository contains development container templates providing standardized devcontainer configurations for various development environments.

## Available Templates

Each template is organized in its own directory with a descriptive name. Browse the directories to see available templates and their specific features.

## How to Use a Template

### Prerequisites

- Docker and Docker Compose installed
- VS Code with Dev Containers extension installed
- Any template-specific requirements (check individual template README files)

### Using with Dev Containers (Recommended)

1. **Open in VS Code**:

   - Open VS Code
   - Use `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) to open command palette
   - Type "Dev Containers: Open Folder in Container"
   - Navigate to this repository root directory
   - Select the template directory you want to use (e.g., `lingaro-azure-databricks-py312-ubuntu24/`)
2. **Development ready**:

   - VS Code will reopen inside the container
   - All dependencies and tools will be automatically installed
   - Start developing immediately

## Template Structure

Each template typically includes:

- **`.devcontainer/`**: Dev container configuration (if using VS Code Dev Containers)
  - `devcontainer.json`: VS Code dev container settings
- **`docker-compose.yml`**: Container orchestration configuration
- **`scripts/`**: Lifecycle hooks and setup scripts
  - `post-create.sh`: Runs after container creation
  - `post-attach.sh`: Runs when attaching to container
  - `post-start.sh`: Runs when starting container
- **`README.md`**: Template-specific documentation
- **`.env.example`**: Environment variable template (if needed)

## Creating a New Template

To create a new devcontainer template:

1. **Copy the boilerplate template**:

   ```bash
   cp -r template-boilerplate/ your-new-template-name/
   cd your-new-template-name/
   ```
2. **Update the configuration**:

   - Edit `.devcontainer/devcontainer.json` - change name and service references
   - Edit `docker-compose.yml` - update service name and image reference
   - Modify scripts in `scripts/` directory as needed
   - Update `README.md` with template-specific documentation
   - Update `.env.example` with any additional environment variables
3. **Follow naming conventions**:

   - Use descriptive directory names
   - Include key technologies and versions
   - Example: `company-python311-nodejs18-ubuntu22`

## Troubleshooting

### Container Issues

- Check Docker daemon is running
- Verify environment file exists and is properly formatted
