# Databricks Dev Container Pipeline

## Quick Start

1. Copy `.env.example` to `.env` and fill in your Azure and Databricks credentials.
2. Run the build and deploy script:
   ```bash
   ./scripts/build-and-deploy.sh
   ```

## Environment Variables

- `AZURE_TENANT_ID`: Azure tenant ID
- `AZURE_CLIENT_ID`: Service principal client ID
- `AZURE_CLIENT_SECRET`: Service principal client secret

## Notes

- The pipeline is designed to be simple: provide credentials, run the script, and you're done.
