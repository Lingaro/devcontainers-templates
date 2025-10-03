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

# Configure plugins
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
alias pyspark='pyspark'
alias spark-shell='spark-shell'
alias hdfs='hdfs'
alias hadoop='hadoop'
alias az-login='az login'

# Hadoop/Spark Aliases
alias start-hadoop='/opt/hadoop/sbin/start-dfs.sh'
alias stop-hadoop='/opt/hadoop/sbin/stop-dfs.sh'
alias hadoop-status='jps'

# CCEP UDP specific shortcuts
alias ccep-test='python -m pytest'
alias ccep-lint='pylint src/'
alias ccep-format='autopep8 --in-place --recursive src/'

EOF

echo "✅ Zsh setup complete!"