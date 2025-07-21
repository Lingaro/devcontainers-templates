#!/bin/bash

# Generic script to get the latest image tag for any template
# Works from any template directory or root templates directory
# Usage: ./get-latest-tag.sh [image-name]

set -e

# Determine image name from current directory or parameter
if [ -n "$1" ]; then
    IMAGE_NAME="$1"
else
    # Get image name from current directory name
    CURRENT_DIR=$(basename "$(pwd)")
    if [ "$CURRENT_DIR" = "devcontainers-templates" ]; then
        echo "Error: Please specify image name or run from a template directory" >&2
        exit 1
    fi
    IMAGE_NAME="$CURRENT_DIR"
fi

# Source environment variables from current directory or parent
ENV_FILE=""
if [ -f .env ]; then
    ENV_FILE=".env"
elif [ -f ../.env ]; then
    ENV_FILE="../.env"
fi

if [ -n "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

# Check if AZURE_ACR_REGISTRY_NAME is set
if [ -z "$AZURE_ACR_REGISTRY_NAME" ]; then
    echo "Error: AZURE_ACR_REGISTRY_NAME environment variable is not set" >&2
    exit 1
fi

# Get highest numeric tag
HIGHEST_TAG=$(az acr repository show-tags \
    --name "$AZURE_ACR_REGISTRY_NAME" \
    --repository "$IMAGE_NAME" \
    --output tsv \
    --query '[].name' 2>/dev/null | \
    grep -E '^[0-9]+$' | \
    sort -n | \
    tail -1)

if [ -z "$HIGHEST_TAG" ]; then
    echo "Error: No numeric tags found for image $IMAGE_NAME" >&2
    exit 1
fi

echo "$HIGHEST_TAG"