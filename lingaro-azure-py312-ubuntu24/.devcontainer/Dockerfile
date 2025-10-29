# Azure Python Dev Container Image
FROM python:3.12-slim-bookworm

# Avoid interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Update and install essential packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    bash \
    jq \
    build-essential \
    libssl-dev \
    sudo \
    vim \
    ca-certificates \
    gnupg \
    lsb-release \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install uv (Python package manager)
ENV UV_INSTALL_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && uv --version

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Python dependencies from requirements.txt
COPY requirements.txt ./
RUN if [ -s requirements.txt ]; then \
        uv pip install --system -r requirements.txt; \
    fi

# Set Python environment
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Azure specific environment variables
ENV AZURE_CONFIG_DIR=/workspaces/.azure
ENV AZURE_EXTENSION_DIR=/workspaces/.azure/extensions

# --- GENERIC AI TOOLS INSTALLATION *start* --- #
# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Install claude-code, qwen-code, and create qwen-proxy script
RUN npm install -g \
       @anthropic-ai/claude-code \
       @qwen-code/qwen-code \
    && npm cache clean --force \
    && echo '#!/bin/bash\n\
if [ -n "$OPENAI_BASE_URL" ]; then\n\
  exec qwen --openai-base-url "$OPENAI_BASE_URL" "$@"\n\
else\n\
 exec qwen "$@"\n\
fi' > /usr/local/bin/qwen-proxy \
    && chmod +x /usr/local/bin/qwen-proxy
# Claude Code environment variables
ENV ANTHROPIC_BASE_URL=""
ENV ANTHROPIC_AUTH_TOKEN=""
ENV ANTHROPIC_MODEL=""
# Qwen Code environment variables
ENV OPENAI_BASE_URL=""
ENV OPENAI_API_KEY=""
ENV OPENAI_MODEL=""
# Legacy environment variables (for backward compatibility)
ENV ANTHROPIC_API_KEY=""
# --- AI TOOLS INSTALLATION *end* --- #

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default shell and working directory
SHELL ["/bin/bash", "-c"]
WORKDIR /workspaces
