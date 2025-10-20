#!/bin/bash
echo '🧱 Dev Container Created!'

exec "$@"

# Set up alias for easier access to the dbx container
echo "alias dbx='docker compose exec dbx bash'" >> ~/.bashrc
source ~/.bashrc
