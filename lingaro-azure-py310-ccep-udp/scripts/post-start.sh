#!/bin/bash
# Post-start: Run when container starts
set -e

echo "🚀 CCEP UDP Post-start setup..."

# Load environment variables
if [ -f "${PWD}/.env" ]; then
    source "${PWD}/.env"
fi

# Set defaults
JUPYTER_PORT=${JUPYTER_PORT:-8888}
SPARK_UI_PORT=${SPARK_UI_PORT:-4040}

# Ensure proper permissions for scripts
chmod +x scripts/*.sh 2>/dev/null || true

# Hadoop is configured in standalone mode (no services to start)
echo "🐘 Hadoop available in standalone mode"

# Start Jupyter Lab if not already running
if ! pgrep -f "jupyter-lab" > /dev/null; then
    echo "📓 Starting Jupyter Lab on port ${JUPYTER_PORT}..."
    nohup jupyter lab \
        --ip=0.0.0.0 \
        --port=${JUPYTER_PORT} \
        --no-browser \
        --allow-root \
        --NotebookApp.token=${JUPYTER_TOKEN:-} \
        --NotebookApp.password='' \
        > /tmp/jupyter.log 2>&1 &
fi

# Azure CLI service principal login if credentials provided
if [ -n "$AZURE_TENANT_ID" ] && [ -n "$AZURE_CLIENT_ID" ] && [ -n "$AZURE_CLIENT_SECRET" ]; then
    echo "🔐 Logging in to Azure with service principal..."
    az login --service-principal \
        --username "$AZURE_CLIENT_ID" \
        --password "$AZURE_CLIENT_SECRET" \
        --tenant "$AZURE_TENANT_ID" > /dev/null 2>&1 || echo "⚠️  Azure login failed"
fi

# Display service status
echo ""
echo "🎯 CCEP UDP Services Status:"
echo "  🐘 Hadoop: ✅ Available (standalone mode)"
echo "  📓 Jupyter Lab: $(if pgrep -f jupyter-lab > /dev/null; then echo "✅ Running on port ${JUPYTER_PORT}"; else echo "❌ Not running"; fi)"
echo ""
echo "🌐 Access URLs:"
echo "  📓 Jupyter Lab: http://localhost:${JUPYTER_PORT}"
echo "  ⚡ Spark UI: http://localhost:${SPARK_UI_PORT} (when Spark job is running)"
echo ""
echo "🛠️  Useful commands:"
echo "  🐘 Hadoop commands: hadoop version"
echo "  ⚡ Start PySpark: pyspark"
echo "  🧪 Run tests: ccep-test"
echo "  🎨 Format code: ccep-format"
echo ""
echo "✅ CCEP UDP environment is ready!"