# Databricks with AI Tools Container Image (Optimized)
FROM python:3.12-slim-bookworm

# Avoid interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Update and install essential packages, Azure CLI, Zulu OpenJDK 17, Node.js, and tools (combined layers)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget bash jq unzip build-essential libssl-dev sudo vim \
    ca-certificates gnupg lsb-release openssh-client htop dnsutils \
    telnet net-tools elinks \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    \
    # Install Azure CLI \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    \
    # Install Zulu OpenJDK 17 \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
    && curl -O https://cdn.azul.com/zulu/bin/zulu-repo_1.0.0-3_all.deb \
    && apt-get install -y ./zulu-repo_1.0.0-3_all.deb \
    && apt-get update && apt-get install -y --no-install-recommends zulu17-jdk \
    && rm -f ./zulu-repo_1.0.0-3_all.deb \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    \
    # Install Node.js \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# Install uv, set JAVA_HOME for Zulu, and AI tools (combined layers)
ENV UV_INSTALL_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && uv --version \
    \
    # Set JAVA_HOME for Zulu OpenJDK \
    && export ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "arm64" ]; then \
         export JAVA_DIR="zulu17"; \
       elif [ "$ARCH" = "amd64" ]; then \
         export JAVA_DIR="zulu17"; \
       else \
         export JAVA_DIR="zulu17"; \
       fi \
    && ln -sf /usr/lib/jvm/$JAVA_DIR /usr/lib/jvm/java-17-zulu \
    \
    # Install AI tools \
    && npm install -g @anthropic-ai/claude-code @qwen-code/qwen-code \
    && npm cache clean --force \
    \
    # Create qwen-proxy script \
    && echo '#!/bin/bash\nif [ ! -z "$OPENAI_BASE_URL" ]; then\n  exec qwen --openai-base-url "$OPENAI_BASE_URL" "$@"\nelse\n  exec qwen "$@"\nfi' > /usr/local/bin/qwen-proxy \
    && chmod +x /usr/local/bin/qwen-proxy

ENV JAVA_HOME=/usr/lib/jvm/java-17-zulu
ENV PATH=$PATH:$JAVA_HOME/bin

# Install Python dependencies and final cleanup (combined layer)
COPY requirements.txt ./
RUN if [ -s requirements.txt ]; then \
        uv pip install --system -r requirements.txt; \
    fi \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache \
    && find /usr/lib/node_modules -name "*.md" -delete \
    && find /usr/lib/node_modules -name "README*" -delete \
    && find /usr/lib/node_modules -name "CHANGELOG*" -delete

# Install Claude Code and Qwen Code
RUN npm install -g @anthropic-ai/claude-code @qwen-code/qwen-code \
    && npm cache clean --force

# Create setup script for Qwen with base URL
RUN echo '#!/bin/bash\n\
if [ ! -z "$OPENAI_BASE_URL" ]; then\n\
  exec qwen --openai-base-url "$OPENAI_BASE_URL" "$@"\n\
else\n\
  exec qwen "$@"\n\
fi' > /usr/local/bin/qwen-proxy && chmod +x /usr/local/bin/qwen-proxy

# Install Python dependencies from requirements.txt
COPY requirements.txt ./
RUN if [ -s requirements.txt ]; then \
        uv pip install --system -r requirements.txt; \
    fi

# Set Python environment
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Azure and AI tools specific environment variables
ENV AZURE_CONFIG_DIR=/workspaces/.azure
ENV AZURE_EXTENSION_DIR=/workspaces/.azure/extensions

# Final cleanup (remove Databricks CLI and clean cache)
RUN rm -f /usr/local/bin/databricks \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache \
    && find /usr/lib/node_modules -name "*.md" -delete \
    && find /usr/lib/node_modules -name "README*" -delete \
    && find /usr/lib/node_modules -name "CHANGELOG*" -delete

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

# Set default shell and working directory
SHELL ["/bin/bash", "-c"]
WORKDIR /workspaces
