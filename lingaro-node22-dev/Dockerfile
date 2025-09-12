FROM node:22-slim

# Avoid interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Base tools and Python runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    libssl-dev \
    lsb-release \
    openssh-client \
    sudo \
    unzip \
    vim \
    wget \
    build-essential \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install uv (Python package manager)
ENV UV_INSTALL_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && uv --version

# Install yarn and pnpm
RUN npm install -g --force yarn pnpm

WORKDIR /tmp

# Copy requirements and filter out Databricks/Spark (dropped)
COPY requirements.txt /tmp/requirements.txt
RUN if [ -s /tmp/requirements.txt ]; then \
      awk 'BEGIN{IGNORECASE=1} /^\s*#/ {next} /^\s*$/ {next} /^databricks/ {next} /^pyspark/ {next} {print}' /tmp/requirements.txt > /tmp/requirements.filtered.txt; \
    else \
      : > /tmp/requirements.filtered.txt; \
    fi

# Pre-resolve/install Python deps to warm cache (optional for builder)
RUN if [ -s /tmp/requirements.filtered.txt ]; then \
      uv pip install --system -r /tmp/requirements.filtered.txt; \
    fi

# Create non-root 'lingaro' user with passwordless sudo
RUN groupadd --gid 1001 lingaro || true \
    && useradd --uid 1001 --gid 1001 -m lingaro || true \
    && usermod -aG sudo lingaro \
    && echo "lingaro ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-lingaro \
    && chmod 0440 /etc/sudoers.d/90-lingaro

USER lingaro

EXPOSE 3000
