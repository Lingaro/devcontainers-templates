#!/bin/bash
# Post-attach: Run every VS Code attach
set -e

echo "🔗 Environment check..."
echo "👤 User: $(whoami) | Dir: $(pwd)"

# Load environment defaults from .env.example (safe load)
if [ -f "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env.example" ]; then
    set +e  # Don't fail if .env.example has issues
    source "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env.example" 2>/dev/null || echo "💡 Could not load .env.example"
    set -e
fi

# Load environment variables (safe load)
if [ -f "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env" ]; then
    echo "🔧 Loading .env..."
    set +e  # Don't fail if .env has issues
    set -a; source "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env" 2>/dev/null; set +a || echo "💡 Could not load .env"
    set -e
else
    echo "💡 No .env file found"
fi

# Set defaults if not provided
JUPYTER_PORT=${JUPYTER_PORT:-8888}
MLFLOW_PORT=${MLFLOW_PORT:-5000}

# Package update check
if [ -f "/workspaces/lingaro-azure-databricks-py312-slim-ds/requirements.txt" ]; then
    echo "🔄 Checking for package updates..."
    if command -v uv &> /dev/null; then
        # Check if requirements have changed (simplified)
        echo "💡 Use 'uv pip install --upgrade -r requirements.txt' to update packages"
    fi
fi

# Check function (with timeout)
check() {
    local name="$1" cmd="$2" success="$3" info="$4"
    if timeout 5 bash -c "$cmd" >/dev/null 2>&1; then
        echo "✅ $success"
    else
        echo "💡 $info"
    fi
}

# Quick status checks
echo "🔍 Status check..."
check "Azure CLI" "command -v az && az account show --output none" \
    "Azure authenticated" \
    "Azure CLI: Run 'az login'"

check "Databricks" "[ -n '$DATABRICKS_HOST' ] && [ -n '$DATABRICKS_TOKEN' ] || [ -f '$HOME/.databrickscfg' ]" \
    "Databricks configured" \
    "Databricks: Set DATABRICKS_HOST/TOKEN"

check "MLflow" "[ -n '$MLFLOW_TRACKING_URI' ]" \
    "MLflow URI: $MLFLOW_TRACKING_URI" \
    "MLflow: Using default URI"

# Anthropic / Cline
mask() { [ -n "$1" ] && echo "${1:0:4}****${1: -4}" || echo "(empty)"; }
echo "🧠 Cline/Anthropic config:"
echo "  Base URL: ${ANTHROPIC_BASE_URL:-(unset)}"
echo "  Model: ${ANTHROPIC_DEFAULT_SONNET_MODEL:-(unset)}"
echo "  API Key: $(mask "$ANTHROPIC_API_KEY")"
if [ -f "$HOME/.claude/settings.json" ]; then
    echo "  Claude settings: present at ~/.claude/settings.json"
else
    echo "  Claude settings: not found"
fi

# GitHub token presence (masked)
echo "🐙 GitHub token: $(mask "$GH_TOKEN")"

# Service status check
echo "🔍 Service status..."
check "Jupyter Lab" "pgrep -f 'jupyter-lab'" \
    "Jupyter Lab running" \
    "Jupyter Lab: Not running"

check "MLflow UI" "pgrep -f 'mlflow ui'" \
    "MLflow UI running" \
    "MLflow UI: Not running"

echo ""
echo "🚀 DevContainer ready!"
echo "💡 Commands: az login | databricks configure | uv pip install --upgrade -r requirements.txt"