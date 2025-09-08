#############################################
# Multi-stage image without Java/Databricks #
#############################################

#############################
# -------- Builder -------- #
#############################
FROM node:22-slim AS builder

# Avoid interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Base tools and Python runtime for building Python deps
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

## Azure CLI removed per request

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

#############################
# -------- Runner --------- #
#############################
FROM node:22-slim AS runner

ARG DEBIAN_FRONTEND=noninteractive

# Essential runtime tools (no Java/Databricks)
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    lsb-release \
    openssh-client \
    sudo \
    unzip \
    vim \
    wget \
    python3 \
    python3-venv \
    python3-pip \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Install uv (Python package manager)
ENV UV_INSTALL_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && uv --version

## Azure CLI removed per request

# Bring in filtered requirements from builder and install (no Databricks/PySpark)
COPY --from=builder /tmp/requirements.filtered.txt /tmp/requirements.filtered.txt
RUN if [ -s /tmp/requirements.filtered.txt ]; then \
      uv pip install --system -r /tmp/requirements.filtered.txt; \
    fi \
    && rm -f /tmp/requirements.filtered.txt

# Clean up (run as root before switching users)
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create non-root 'lingaro' user with passwordless sudo
RUN groupadd --gid 1001 lingaro || true \
    && useradd --uid 1001 --gid 1001 -m lingaro || true \
    && usermod -aG sudo lingaro \
    && echo "lingaro ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-lingaro \
    && chmod 0440 /etc/sudoers.d/90-lingaro

USER lingaro

# Python env
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    NODE_ENV=production \
    NODE_OPTIONS=--max-http-header-size=80000 \
    PATH=/workspaces/node_modules/.bin:$PATH

## Azure environment variables removed per request

# Default shell and workdir
SHELL ["/bin/bash", "-c"]
WORKDIR /workspaces

# Expose default app port
EXPOSE 3000

# Use tini for proper signal handling if container is run directly
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]
