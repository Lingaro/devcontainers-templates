# Lingaro Node 22 DevContainer

A comprehensive Node.js 22 development environment with integrated tooling and dual-container setup for development and production workflows.

## Features

- **Node.js 22** latest LTS version
- **Multiple Package Managers** - npm, yarn, and pnpm support
- **Dual Container Setup** - Separate DEV and PROD environments
- **VS Code Extensions** optimized for Node.js development
- **Environment Configuration** via .env files
- **Built-in Aliases** for quick container operations

## Quick Start

1. **Get the setup script** and put it in a desired empty folder:

   - If your OS is Windows use `git bash`
   - Try `curl -fsSLo get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-node22/get-devcontainer.sh`
   - or `wget -O get-devcontainer.sh https://raw.githubusercontent.com/Lingaro/devcontainers-templates/main/lingaro-node22/get-devcontainer.sh`

2. **Run the script** - Template files will be downloaded:

   ```bash
   chmod +x get-devcontainer.sh
   ./get-devcontainer.sh
   ```

3. **Configure environment**:

   ```bash
   cp .devcontainer/.env.example .devcontainer/.env
   ```

4. **Update `.env` file** with your required variables

5. **Open in VS Code** and use Dev Containers extension command "Reopen in Container"

6. **Your workspace is mounted** at `/app`

### Verification

After setup, verify your installation:

```bash
node --version          # Should show Node.js v22.x
npm --version           # Verify npm
yarn --version          # Verify yarn
pnpm --version          # Verify pnpm
```

## Development Environment

### Pre-installed Tools

- **Node.js 22** with npm package manager
- **yarn** - Alternative package manager
- **pnpm** - Fast, disk space efficient package manager
- **Git** for version control
- **curl, wget** for API interactions
- **Build essentials** for native module compilation

### VS Code Extensions

The template includes recommended extensions for Node.js development. Configure in `.devcontainer/devcontainer.json`.

### Port Configuration

- **Port 3000** - DEV container Node app (host:3000 → container:3000)
- **Port 3001** - PROD container Node app (host:3001 → container:3000)

Both ports are forwarded and accessible from your host machine.

## Container Operations

### Special Commands

This template includes convenient aliases for container management:

```bash
# Rebuild PROD container
prodbuild
# Alias for: docker compose up --build -d prod

# Access PROD container bash
prodbash
# Alias for: docker compose exec prod bash
```

### Manual Container Operations

```bash
# Build and start all containers
docker compose up -d

# View container logs
docker compose logs -f

# Stop containers
docker compose down

# Rebuild specific container
docker compose up --build -d dev
docker compose up --build -d prod
```

## Package Management

### Using npm

```bash
# Install dependencies
npm install

# Install specific package
npm install express

# Run scripts from package.json
npm run start
npm run test
```

### Using yarn

```bash
# Install dependencies
yarn install

# Add package
yarn add express

# Run scripts
yarn start
yarn test
```

### Using pnpm

```bash
# Install dependencies
pnpm install

# Add package
pnpm add express

# Run scripts
pnpm start
pnpm test
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
lingaro-node22/
├── .devcontainer/
│   ├── devcontainer.json     # DevContainer configuration
│   ├── Dockerfile            # Container image definition
│   └── .env.example          # Environment template
├── src/
│   └── index.js              # Entry point
├── get-devcontainer.sh       # Setup helper script
├── package.json              # Project dependencies
└── README.md                 # This file
```

## Troubleshooting

### Container Issues

```bash
# Rebuild container completely
Ctrl+Shift+P → "Dev Containers: Rebuild Container"

# Check container logs
docker logs <container-name>

# Remove all containers and volumes
docker compose down -v
```

### Node.js Issues

```bash
# Verify Node.js installation
which node
node --version

# Check installed packages
npm list
yarn list
pnpm list
```

### Port Conflicts

```bash
# Check what's using port 3000 or 3001
lsof -i :3000
lsof -i :3001

# Stop the container using the port
docker compose down
```

## Best Practices

1. **Environment Variables**: Keep sensitive data in `.env` file, never commit it to version control
2. **Package Manager**: Choose one package manager (npm/yarn/pnpm) per project for consistency
3. **Version Control**: Use `.gitignore` to exclude `node_modules` and `.env`
4. **Resource Cleanup**: Stop containers when not in use to save resources
5. **Dependencies**: Keep `package.json` dependencies up to date
6. **Testing**: Use the PROD container to test production builds before deployment

## Support

For issues specific to this DevContainer template, please check:

- Container logs via Docker Desktop
- VS Code DevContainer documentation
- Node.js troubleshooting guides

This template provides a robust foundation for Node.js development with modern tooling and dual-environment workflow built-in.
