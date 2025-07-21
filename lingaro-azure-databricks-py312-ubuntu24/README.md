# Databricks Dev Container Pipeline

## Quick Start

1. Copy `.env.example` to `.env` and fill in your Azure and Databricks credentials.
2. Run the build and deploy script:
   ```bash
   ./scripts/build-and-deploy.sh
   ```

## Environment Variables

### Azure Configuration
- `AZURE_TENANT_ID`: Azure tenant ID
- `AZURE_CLIENT_ID`: Service principal client ID
- `AZURE_CLIENT_SECRET`: Service principal client secret

### Databricks Configuration
- `DATABRICKS_HOST`: Your Databricks workspace URL (e.g., https://adb-123.16.azuredatabricks.net)
- `DATABRICKS_TOKEN`: Your Databricks personal access token


## Verify Databricks Connection

Once your devcontainer is running, you can verify your Databricks connection:

```bash
# Check environment variables are loaded
echo $DATABRICKS_HOST
echo $DATABRICKS_TOKEN

# Test connection with Databricks CLI
databricks clusters list
databricks current-user me

# Test with Python SDK
python3 -c "
from databricks.sdk import WorkspaceClient
w = WorkspaceClient()
user = w.current_user.me()
print(f'Connected as: {user.user_name}')
"
```

## Notes

- The pipeline is designed to be simple: provide credentials, run the script, and you're done.
