#!/bin/bash

# Script to automatically set IMAGE_TAG for all templates before devcontainer build
# Run this from the templates root directory before using devcontainers

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set IMAGE_TAG for each template directory
for template_dir in "$SCRIPT_DIR"/*/; do
    if [ -d "$template_dir" ] && [ -f "$template_dir/docker-compose.yml" ]; then
        template_name=$(basename "$template_dir")
        
        
        echo "Setting IMAGE_TAG for $template_name..."
        
        # Get latest tag for this template
        latest_tag=$("$SCRIPT_DIR/get-latest-tag.sh" "$template_name")
        
        # Set environment variable in template's .env file
        env_file="$template_dir/.env"
        if [ ! -f "$env_file" ]; then
            # Create .env from .env.example if it exists
            if [ -f "$template_dir/.env.example" ]; then
                cp "$template_dir/.env.example" "$env_file"
            else
                touch "$env_file"
            fi
        fi
        
        # Update or add IMAGE_TAG
        if grep -q "^IMAGE_TAG=" "$env_file"; then
            sed -i.bak "s/^IMAGE_TAG=.*/IMAGE_TAG=$latest_tag/" "$env_file"
        else
            echo "IMAGE_TAG=$latest_tag" >> "$env_file"
        fi
        
        echo "Set IMAGE_TAG=$latest_tag for $template_name"
    fi
done

echo "All template IMAGE_TAG values updated successfully!"