#!/bin/bash

# Zsh Setup Script for DevContainers
# This script installs and configures Oh My Zsh with useful plugins for development

set -e

echo "🚀 Setting up Zsh with Oh My Zsh..."

# Install Oh My Zsh
echo "📦 Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Zsh plugins
echo "🔌 Installing Zsh plugins..."
CUSTOM_PLUGINS="${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins"

git clone https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM_PLUGINS/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$CUSTOM_PLUGINS/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-history-substring-search "$CUSTOM_PLUGINS/zsh-history-substring-search"

echo "⚙️ Configuring Zsh..."

# Configure plugins (removed duplicate)
sed -i 's/plugins=(git)/plugins=(git docker docker-compose python pip azure zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)/g' /root/.zshrc

# Add consolidated configuration
cat >> /root/.zshrc << 'EOF'

# History Configuration
export HIST_STAMPS="yyyy-mm-dd"
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS

# Key Bindings
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Essential Aliases
alias ll='ls -alF'
alias grep='grep --color=auto'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias py='python'
alias k='kubectl'
alias az-login='az login'

EOF

# Set Zsh as default shell
chsh -s $(which zsh) root

echo "✅ Zsh setup completed with auto-suggestions, syntax highlighting, and history search!"
