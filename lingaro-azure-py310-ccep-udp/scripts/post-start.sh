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

# Start SSH service for Hadoop (if not running)
if ! pgrep -x "sshd" > /dev/null; then
    echo "🔑 Starting SSH service for Hadoop..."
    service ssh start 2>/dev/null || /usr/sbin/sshd -D &
fi

# Load Hadoop SSH environment if available
if [ -f /tmp/hadoop-env.sh ]; then
    source /tmp/hadoop-env.sh
fi

# Use Hadoop SSH directory (since /root/.ssh is read-only)
HADOOP_SSH_DIR="/tmp/hadoop-ssh"
if [ -d "$HADOOP_SSH_DIR" ]; then
    # Configure SSH to use Hadoop keys for localhost connections
    export SSH_AUTH_SOCK=""  # Disable agent to force key file usage
    
    # Start SSH agent and add Hadoop key
    if [ -f "$HADOOP_SSH_DIR/id_rsa" ]; then
        eval $(ssh-agent -s) > /dev/null
        ssh-add "$HADOOP_SSH_DIR/id_rsa" 2>/dev/null || true
    fi
fi

# Start Hadoop services
echo "🐘 Starting Hadoop services..."
if [ -d "$HADOOP_HOME" ]; then
    # Start DFS (NameNode and DataNode)
    $HADOOP_HOME/sbin/start-dfs.sh
    
    # Wait a moment for services to start
    sleep 5
    
    # Check if services started successfully
    if jps | grep -q NameNode; then
        echo "✅ Hadoop NameNode started successfully"
    else
        echo "❌ Failed to start Hadoop NameNode"
    fi
    
    if jps | grep -q DataNode; then
        echo "✅ Hadoop DataNode started successfully"
    else
        echo "❌ Failed to start Hadoop DataNode"
    fi
fi

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
echo "  🐘 Hadoop NameNode: $(if jps | grep -q NameNode; then echo "✅ Running"; else echo "❌ Not running"; fi)"
echo "  🐘 Hadoop DataNode: $(if jps | grep -q DataNode; then echo "✅ Running"; else echo "❌ Not running"; fi)"
echo "  📓 Jupyter Lab: $(if pgrep -f jupyter-lab > /dev/null; then echo "✅ Running on port ${JUPYTER_PORT}"; else echo "❌ Not running"; fi)"
echo ""
echo "🌐 Access URLs:"
echo "  📓 Jupyter Lab: http://localhost:${JUPYTER_PORT}"
echo "  🐘 Hadoop NameNode UI: http://localhost:9870"
echo "  🐘 Hadoop DataNode UI: http://localhost:9864"
echo "  ⚡ Spark UI: http://localhost:${SPARK_UI_PORT} (when Spark job is running)"
echo ""
echo "🛠️  Useful commands:"
echo "  🐘 Check Hadoop processes: jps"
echo "  🐘 HDFS commands: hdfs dfs -ls /"
echo "  ⚡ Start PySpark: pyspark"
echo "  🧪 Run tests: ccep-test"
echo "  🎨 Format code: ccep-format"
echo ""
echo "✅ CCEP UDP environment is ready!"