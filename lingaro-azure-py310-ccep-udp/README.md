# Lingaro Azure Python 3.10 CCEP UDP Development Container

A specialized development container for **CCEP UDP Academy** projects, featuring Python 3.10.11, Java OpenJDK 11, Hadoop 3.3.5, and all required data engineering tools for Spark/Delta Lake development.

## 🚀 Features

- **Python 3.10.11** - Exact version required for CCEP UDP projects
- **Java OpenJDK 11** (Temurin build) - Required for Spark and Hadoop
- **Hadoop 3.3.5** - Distributed processing framework
- **Apache Spark** - Via PySpark 3.5.3 with Delta Lake support
- **Azure Integration** - Full Azure SDK and CLI support
- **Development Tools** - Testing, linting, and formatting tools
- **Jupyter Lab** - Interactive development environment
- **Enhanced Shell** - Zsh with Oh My Zsh and useful aliases

## 📋 Prerequisites

- Docker Desktop or Docker with BuildKit support
- VS Code with Dev Containers extension (recommended)
- Azure service principal credentials

## 🛠️ Quick Start

1. **Clone and Navigate**
   ```bash
   cd lingaro-azure-py310-ccep-udp/
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your Azure credentials
   ```

3. **Build and Start**
   ```bash
   docker compose up -d --build
   ```

4. **Access the Container**
   ```bash
   docker exec -it lingaro-azure-py310-ccep-udp zsh
   ```

## 🌐 Access Points

| Service | URL | Description |
|---------|-----|-------------|
| Jupyter Lab | http://localhost:8888 | Interactive development |
| Hadoop NameNode | http://localhost:9870 | HDFS management |
| Hadoop DataNode | http://localhost:9864 | Data node status |
| Spark UI | http://localhost:4040 | Spark job monitoring |

## 📦 Included Python Packages

### Azure & Cloud Services
- `azure-identity==1.5.0` - Azure authentication
- `azure-storage-blob==12.23.0` - Blob storage
- `azure-storage-file-datalake==12.17.0` - Data Lake Gen2
- `azure-mgmt-datafactory==2.0.0` - Data Factory management

### Data Processing
- `pyspark==3.5.3` - Spark for Python
- `delta-spark==3.2.1` - Delta Lake functionality
- `pandas==1.5.3` - Data manipulation
- `numpy==1.24.4` - Numerical computing

### Testing & Quality
- `pytest==7.1` - Testing framework
- `pytest-cov==4.0.0` - Coverage reporting
- `pylint==2.15.3` - Code linting
- `autopep8==1.5.7` - Code formatting

### Additional Tools
- `great-expectations==0.18.3` - Data quality
- `envyaml==1.10.211231` - Environment configuration
- `python-dotenv==0.21.0` - Environment management

## 🏗️ Project Structure

The container automatically creates the following CCEP UDP structure:

```
src/
├── databricks/
│   ├── ccep_udp/tests/
│   ├── master/tests/
│   ├── commercial/tests/
│   ├── scm/tests/
│   ├── marketing/tests/
│   └── finance/tests/
data/
├── input/
└── output/
configs/
├── databricks.yml
└── spark.yml
notebooks/
logs/
```

## ⚙️ Environment Variables

### Required Azure Configuration
```bash
AZURE_TENANT_ID=your-tenant-id
AZURE_CLIENT_ID=your-client-id  
AZURE_CLIENT_SECRET=your-client-secret
```

### Optional Databricks Configuration
```bash
DATABRICKS_HOST=https://your-workspace.azuredatabricks.net
DATABRICKS_TOKEN=your-token
DATABRICKS_CLUSTER_ID=your-cluster-id
```

### Development Ports (Optional)
```bash
JUPYTER_PORT=8888
SPARK_UI_PORT=4040
HADOOP_NAMENODE_PORT=9870
```

## 🔧 Development Commands

### Hadoop Operations
```bash
# Start Hadoop services
start-hadoop

# Stop Hadoop services
stop-hadoop

# Check Hadoop processes
hadoop-status  # or jps

# HDFS operations
hdfs dfs -ls /
hdfs dfs -mkdir /user/data
```

### Spark Development
```bash
# Start PySpark shell
pyspark

# Start Spark with specific configuration
pyspark --master local[4] --conf spark.sql.adaptive.enabled=true
```

### CCEP UDP Shortcuts
```bash
# Run tests
ccep-test

# Lint code
ccep-lint

# Format code
ccep-format
```

### Azure CLI
```bash
# Login (if not using service principal)
az login

# List subscriptions
az account list
```

## 📝 Development Workflow

1. **Initialize Project**
   - Container automatically creates CCEP UDP directory structure
   - Configures Python paths for all modules
   - Sets up Hadoop filesystem

2. **Azure Authentication**
   - Service principal automatically logs in on startup
   - Or use `az login` for interactive login

3. **Start Development**
   - Use Jupyter Lab for interactive development
   - Access Hadoop UI to monitor HDFS
   - View Spark UI during job execution

4. **Testing**
   - Run `ccep-test` for all tests
   - Use `pytest src/databricks/specific_module/tests/` for specific modules
   - Coverage reports automatically generated

## 🛠️ Configuration Files

### Databricks Configuration (`configs/databricks.yml`)
```yaml
host: ${DATABRICKS_HOST}
token: ${DATABRICKS_TOKEN}
cluster_id: ${DATABRICKS_CLUSTER_ID}
```

### Spark Configuration (`configs/spark.yml`)
```yaml
spark:
  app_name: "CCEP-UDP-Application"
  master: "local[*]"
  config:
    spark.sql.adaptive.enabled: "true"
    spark.sql.execution.arrow.pyspark.enabled: "true"
```

## 🐛 Troubleshooting

### Hadoop Issues
```bash
# Check if Hadoop services are running
jps

# Restart Hadoop
stop-hadoop && start-hadoop

# Check Hadoop logs
tail -f $HADOOP_HOME/logs/*.log
```

### Python Environment Issues
```bash
# Verify Python version
python --version  # Should show 3.10.11

# Check installed packages
pip list | grep azure
pip list | grep spark
```

### Port Conflicts
If default ports are in use, modify them in `.env`:
```bash
JUPYTER_PORT=8889
SPARK_UI_PORT=4041
HADOOP_NAMENODE_PORT=9871
```

## 📚 Additional Resources

- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [Hadoop Documentation](https://hadoop.apache.org/docs/current/)
- [Delta Lake Documentation](https://docs.delta.io/)
- [Azure SDK for Python](https://docs.microsoft.com/en-us/azure/developer/python/)

## 🤝 Support

This template is designed specifically for CCEP UDP Academy projects. For issues or questions:
1. Check the troubleshooting section above
2. Review container logs: `docker logs lingaro-azure-py310-ccep-udp`
3. Ensure all required environment variables are configured