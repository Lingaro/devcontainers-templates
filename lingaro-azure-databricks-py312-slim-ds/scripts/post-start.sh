#!/bin/bash
# Post-start: Run every container start
set -e

# Load environment defaults from .env.example (safe load)
if [ -f "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env.example" ]; then
    set +e  # Don't fail if .env.example has issues
    source "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env.example" 2>/dev/null || echo "💡 Could not load .env.example"
    set -e
fi

# Override with actual .env if exists (safe load)
if [ -f "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env" ]; then
    set +e  # Don't fail if .env has issues
    source "/workspaces/lingaro-azure-databricks-py312-slim-ds/.env" 2>/dev/null || echo "💡 Could not load .env"
    set -e
fi

# Set defaults if not provided
JUPYTER_PORT=${JUPYTER_PORT:-8888}
MLFLOW_PORT=${MLFLOW_PORT:-5000}

# Simple and reliable: test if services respond on their ports
mlflow_running=false
jupyter_running=false

# Test MLflow port
if curl -s http://localhost:$MLFLOW_PORT >/dev/null 2>&1; then
    mlflow_running=true
fi

# Test Jupyter port  
if curl -s http://localhost:$JUPYTER_PORT >/dev/null 2>&1; then
    jupyter_running=true
fi

if $mlflow_running && $jupyter_running; then
    echo "✅ Services already running"
    exit 0
fi

echo "🚀 Starting services..."

# Start MLflow UI if not responding
if ! $mlflow_running; then
    nohup mlflow ui --host=0.0.0.0 --port=$MLFLOW_PORT --backend-store-uri=/workspaces/lingaro-azure-databricks-py312-slim-ds/mlruns >/dev/null 2>&1 &
    echo "📈 MLflow UI: http://localhost:$MLFLOW_PORT"
fi

# Start Jupyter Lab if not responding
if ! $jupyter_running; then
    nohup jupyter-lab --ip=0.0.0.0 --port=$JUPYTER_PORT --no-browser --allow-root --notebook-dir=/workspaces/lingaro-azure-databricks-py312-slim-ds --ServerApp.token= --ServerApp.password= >/dev/null 2>&1 &
    echo "📊 Jupyter Lab: http://localhost:$JUPYTER_PORT"
fi

echo "✅ Services ready!"
