#!/bin/bash
# Post-create: Run once after container creation
set -e

echo "🔧 CCEP UDP Post-create setup..."

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
SPARK_UI_PORT=${SPARK_UI_PORT:-4040}
HADOOP_NAMENODE_PORT=${HADOOP_NAMENODE_PORT:-9870}

echo "🐍 Python version: $(python --version)"
echo "☕ Java version: $(java -version 2>&1 | head -n 1)"
echo "🐘 Hadoop version: $(hadoop version | head -n 1)"

# Update system packages (only if needed)
if [ ! -f "/tmp/.packages-updated" ]; then
    echo "📦 Updating packages..."
    apt-get update && touch /tmp/.packages-updated
fi

# Install additional Python packages if needed
if [ -f "requirements-dev.txt" ]; then
    echo "📦 Installing additional dev requirements..."
    pip install -r requirements-dev.txt
fi

# Initialize Hadoop if not already done
if [ ! -d "/tmp/hadoop-root/dfs" ]; then
    echo "🐘 Initializing Hadoop filesystem..."
    
    # Create SSH keys for Hadoop (passwordless SSH)
    if [ ! -f "/root/.ssh/id_rsa" ]; then
        ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa
        cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
        chmod 0600 /root/.ssh/authorized_keys
    fi
    
    # Format namenode
    mkdir -p /tmp/hadoop-root/dfs/name /tmp/hadoop-root/dfs/data
    $HADOOP_HOME/bin/hdfs namenode -format -force
fi

# Create CCEP UDP project structure if not exists
echo "📁 Setting up CCEP UDP project structure..."

mkdir -p src/databricks/ccep_udp/tests
mkdir -p src/databricks/master/tests
mkdir -p src/databricks/commercial/tests
mkdir -p src/databricks/scm/tests
mkdir -p src/databricks/marketing/tests
mkdir -p src/databricks/finance/tests
mkdir -p data/input
mkdir -p data/output
mkdir -p configs
mkdir -p notebooks
mkdir -p logs

# Create __init__.py files for proper Python module structure
find src -type d -name "*.py" -prune -o -type d -exec touch {}/__init__.py \;

# Configure Git LFS for Hugging Face models
echo "🔧 Configuring Git LFS..."
git lfs install --system || git lfs install || echo "✅ Git LFS already configured"

# Azure CLI login check
if [ -n "$AZURE_TENANT_ID" ] && [ -n "$AZURE_CLIENT_ID" ] && [ -n "$AZURE_CLIENT_SECRET" ]; then
    echo "🔐 Azure service principal configured"
else
    echo "⚠️  Azure credentials not configured. Please set AZURE_TENANT_ID, AZURE_CLIENT_ID, and AZURE_CLIENT_SECRET in .env"
fi


if [ ! -f "configs/spark.yml" ]; then
    cat > configs/spark.yml << EOF
# Spark configuration for CCEP UDP
spark:
  app_name: "CCEP-UDP-Application"
  master: "local[*]"
  config:
    spark.sql.adaptive.enabled: "true"
    spark.sql.adaptive.coalescePartitions.enabled: "true"
    spark.sql.execution.arrow.pyspark.enabled: "true"
    spark.serializer: "org.apache.spark.serializer.KryoSerializer"
    spark.sql.warehouse.dir: "/tmp/spark-warehouse"
EOF
fi

echo "✅ CCEP UDP post-create setup complete!"
echo "📖 Next steps:"
echo "   1. Copy .env.example to .env and configure your Azure credentials"
echo "   2. Start Hadoop with: start-hadoop"
echo "   3. Access Jupyter Lab at: http://localhost:${JUPYTER_PORT}"