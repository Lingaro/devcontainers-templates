#!/bin/bash
echo '🧱 Dev Container Created!'

# Set up alias for easier access to the dbx container
echo "alias dbx='docker compose exec dbx bash'" >> ~/.bashrc
echo "alias dbx='docker compose exec dbx zsh'" >> ~/.zshrc
source ~/.bashrc
source ~/.zshrc

exec "$@"
