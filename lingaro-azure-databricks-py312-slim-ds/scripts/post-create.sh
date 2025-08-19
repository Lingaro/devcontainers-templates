#!/bin/bash
# Post-create: Run once after container creation
set -e

echo "🔧 Post-create setup..."

# Load environment defaults from .env.example (safe load)
if [ -f "${PWD}/.env.example" ]; then
    set +e  # Don't fail if .env.example has issues
    source "${PWD}/.env.example" 2>/dev/null || echo "💡 Could not load .env.example"
    set -e
fi

# Override with actual .env if exists (safe load)
if [ -f "${PWD}/.env" ]; then
    set +e  # Don't fail if .env has issues
    source "${PWD}/.env" 2>/dev/null || echo "💡 Could not load .env"
    set -e
fi

# Set defaults if not provided
JUPYTER_PORT=${JUPYTER_PORT:-8888}
MLFLOW_PORT=${MLFLOW_PORT:-5000}

echo "🐍 Python version: $(python --version)"

# Update system packages (only if needed)
if [ ! -f "/tmp/.packages-updated" ]; then
    echo "📦 Updating packages..."
    apt-get update && touch /tmp/.packages-updated
else
    echo "✅ Packages already updated"
fi

# Install UV if missing
if ! command -v uv &> /dev/null; then
    echo "⚡ Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Configure Git LFS for Hugging Face models
echo "🔧 Configuring Git LFS..."
git lfs install --system || git lfs install || echo "✅ Git LFS already configured"

# Install Python packages
echo "🐍 Installing Python packages..."
if [ -f "${PWD}/requirements.txt" ]; then
    uv pip install --system -r "${PWD}/requirements.txt"
fi

# Essential Azure/Databricks packages
echo "☁️ Installing Azure/Databricks packages..."
uv pip install --system azure-identity databricks-sdk

# Unsloth (x86_64 only)
if [[ $(uname -m) == "x86_64" ]]; then
    echo "🦥 Installing Unsloth for x86_64..."
    uv pip install --system "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git" || true
else
    echo "💡 Skipping Unsloth on ARM64 (using transformers + PEFT)"
fi

# Setup MLflow tracking directory
echo "📊 Setting up MLflow..."
mkdir -p /workspaces/lingaro-azure-databricks-py312-slim-ds/mlruns

# Workspace structure
echo "📁 Creating workspace structure..."
mkdir -p /workspaces/lingaro-azure-databricks-py312-slim-ds/{data,models,notebooks,experiments}

echo "✅ Post-create completed!"