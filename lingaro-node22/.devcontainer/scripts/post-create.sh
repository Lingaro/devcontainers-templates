#!/usr/bin/env bash
set -euo pipefail

# If arguments are provided, execute them as a command and exit
exec "$@"

# Set up alias for easier rebuild of the prod container
echo "alias dbx='docker compose up --build -d prod'" >> ~/.bashrc
source ~/.bashrc

# Set up alias for easier access to the prod container bash
echo "alias dbx='docker compose exec prod bash'" >> ~/.bashrc
source ~/.bashrc
