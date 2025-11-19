#!/bin/bash
# Post-attach: Run when VS Code attaches to the container
set -e

echo "🔗 CCEP UDP Post-attach setup..."

# Load environment variables
if [ -f "${PWD}/.env" ]; then
    source "${PWD}/.env"
fi

# Ensure proper permissions
chmod +x scripts/*.sh 2>/dev/null || true

# Check if Hadoop is running
if ! jps | grep -q NameNode; then
    echo "⚠️  Hadoop is not running. You may want to start it with: start-hadoop"
fi

# Check if required directories exist
if [ ! -d "src" ]; then
    echo "📁 Creating src directory structure..."
    mkdir -p src/databricks
fi

# Display useful information
echo "📊 CCEP UDP Development Environment Ready!"
echo "🐍 Python: $(python --version)"
echo "☕ Java: $(java -version 2>&1 | head -n 1)"
echo "🐘 Hadoop: $($HADOOP_HOME/bin/hadoop version | head -n 1)"
echo "⚡ Spark: Available via pyspark command"

# Check Azure login status
if command -v az &> /dev/null; then
    if az account show &> /dev/null; then
        echo "✅ Azure CLI: Logged in as $(az account show --query user.name -o tsv)"
    else
        echo "🔐 Azure CLI: Not logged in (use 'az login' or configure service principal)"
    fi
fi

echo "🚀 Ready for CCEP UDP development!"