#!/usr/bin/env bash
set -euo pipefail

# If arguments are provided, execute them as a command and exit
exec "$@"

# Set up alias for easier rebuild of the prod container
echo "alias prodbuild='docker compose up --build -d prod'" >> ~/.bashrc
# Set up alias for easier access to the prod container bash
echo "alias prodbash='docker compose exec prod bash'" >> ~/.bashrc
# Reload bashrc to apply the changes
source ~/.bashrc
