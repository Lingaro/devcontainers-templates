# Lingaro Samanta DevContainer

A specialized development environment for the Samanta project with integrated Databricks support. Runs against GHCR-hosted images with dual-container setup for application and Databricks workflows.

## Features

- **GHCR-hosted Images** - Pre-built containers from GitHub Container Registry
  - `ghcr.io/lingaro/lingaro-samanta:latest` - Main application container
  - `ghcr.io/lingaro/lingaro-dbx164lts:latest` - Databricks runtime container
- **Dual Container Setup** - Separate Samanta and Databricks (dbx) environments
- **Pre-configured Databricks** integration for workspace operations
- **VS Code Extensions** optimized for Scala, Spark, and cloud development
- **Built-in Aliases** for quick container access

## Quick Start

1. **Get the setup script** and put it in a desired empty folder:

   - If your OS is Windows use `git bash`
   - Try `curl -fsSLo get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-samanta/get-devcontainer.sh`
   - or `wget -O get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-samanta/get-devcontainer.sh`

2. **Run the script** - Template files will be downloaded:

   ```bash
   chmod +x get-devcontainer.sh
   ./get-devcontainer.sh
   ```

3. **Configure environment**:

   ```bash
   cp .devcontainer/.env.example .devcontainer/.env
   ```

4. **Update `.env` file** with your required variables (Databricks host, token, Azure credentials)

5. **Open in VS Code** and use Dev Containers extension command "Reopen in Container"

6. **Your workspace is mounted** at `/samanta`

### Verification

After setup, verify your installation:

```bash
# Check Scala/sbt version (in Samanta container)
sbt --version

# Access Databricks container
dbx

# Verify Databricks CLI (in dbx container)
databricks --version
```

## Development Environment

### Container Architecture

This template uses a multi-container setup:

1. **Samanta Container** (main dev environment)

   - Workspace mounted at `/samanta`
   - Scala and sbt tooling
   - Development tools and utilities

2. **DBX Container** (Databricks runtime)
   - Databricks CLI pre-configured
   - Databricks Runtime 16.4 LTS
   - Spark and cluster integration

### Pre-installed Tools

**Samanta Container**:

- **Scala & sbt** for Scala/Spark development
- **Git** for version control
- **curl, wget** for API interactions

**DBX Container**:

- **Databricks CLI** for workspace management
- **Databricks Runtime 16.4 LTS**
- **Apache Spark** with cluster connectivity

### VS Code Extensions

The template includes recommended extensions for Scala, Spark, and cloud development. Configure in `.devcontainer/devcontainer.json`.

### Port Configuration

This template does not expose any default ports. Configure ports in `.devcontainer/docker-compose.yml` as needed for your application.

## Container Operations

### Special Commands

Quick access to the Databricks container:

```bash
# Access Databricks container bash
dbx
# Alias for: docker compose exec dbx bash
```

### Manual Container Operations

```bash
# Start all containers
docker compose up -d

# View logs
docker compose logs -f samanta
docker compose logs -f dbx

# Access containers
docker compose exec samanta bash
docker compose exec dbx bash

# Stop containers
docker compose down
```

## Databricks Integration

### CLI Configuration

The Databricks CLI is pre-installed in the dbx container. Configure it with:

```bash
# Access dbx container
dbx

# Configure Databricks CLI
databricks configure --token

# Or use environment variables (recommended)
export DATABRICKS_HOST="https://your-workspace.cloud.databricks.com"
export DATABRICKS_TOKEN="your-token"
```

### Common Operations

```bash
# List workspace files
databricks workspace list /

# Upload file to workspace
databricks workspace import ./local-file.py /Users/your-email/remote-file.py

# Run a job
databricks jobs run-now --job-id 123

# List clusters
databricks clusters list
```

## Build and Deployment

### Building the Project

```bash
# In the Samanta container
sbt clean compile

# Run tests
sbt test

# Create assembly JAR
sbt assembly
```

### Spark Job Execution

Use the included `spark-run.sh` script for local Spark job execution:

```bash
# Run Spark job locally
./spark-run.sh your-assembly.jar com.yourcompany.MainClass arg1 arg2
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
lingaro-samanta/
├── .devcontainer/
│   ├── devcontainer.json     # DevContainer configuration
│   ├── docker-compose.yml    # Multi-container orchestration
│   └── .env.example          # Environment template
├── initdb/
│   └── init.sql.example      # Database initialization example
├── get-devcontainer.sh       # Setup helper script
├── spark-run.sh              # Spark job execution script
├── build.sbt                 # sbt build definition
└── README.md                 # This file
```

## Troubleshooting

### Container Issues

```bash
# Rebuild containers
Ctrl+Shift+P → "Dev Containers: Rebuild Container"

# Check container status
docker compose ps

# View container logs
docker compose logs -f

# Remove all containers and volumes
docker compose down -v
```

### macOS Permission Issues

If you encounter `permission denied` errors on macOS related to `mariadb.cnf`:

```bash
# The mariadb.cnf mount is commented out by default to avoid macOS permission issues
# If you need custom MariaDB configuration:

# 1. Copy the example file
cp mariadb.cnf.example mariadb.cnf

# 2. Edit your custom configuration
# nano mariadb.cnf

# 3. Uncomment the volume mount in .devcontainer/docker-compose.yml
# Find this line and uncomment it:
# - ${HOST_ABSOLUTE_PATH}/mariadb.cnf:/etc/mysql/conf.d/zz-custom.cnf:ro
```

**Alternative**: Place configuration files in the `initdb/` directory which is mounted as a directory (works better on macOS).

### Databricks Connection Issues

```bash
# Verify Databricks CLI configuration
databricks workspace list /

# Test authentication
export DATABRICKS_HOST="your-host"
export DATABRICKS_TOKEN="your-token"
databricks workspace list /

# Check network connectivity
curl -H "Authorization: Bearer $DATABRICKS_TOKEN" $DATABRICKS_HOST/api/2.0/clusters/list
```

### Build Issues

```bash
# Clean sbt cache
sbt clean

# Update dependencies
sbt update

# Check sbt version
sbt --version
```

## Best Practices

1. **Environment Variables**: Keep sensitive data (tokens, credentials) in `.env` file, never commit it to version control
2. **Container Management**: Stop containers when not in use to save resources
3. **Databricks Authentication**: Use token-based authentication stored in environment variables
4. **Version Control**: Use `.gitignore` to exclude build artifacts and `.env`
5. **Database Init**: Use `initdb/` folder for database initialization scripts
6. **Resource Limits**: Configure memory and CPU limits in `docker-compose.yml` for large Spark jobs

## Support

For issues specific to this DevContainer template, please check:

- Container logs via Docker Desktop
- VS Code DevContainer documentation
- Databricks CLI troubleshooting guides
- Scala/sbt documentation

This template provides a robust foundation for Samanta project development with integrated Databricks support and modern tooling built-in.
