#######################################
# -------- Multi-stage image -------- #
#######################################

#############################
# -------- Builder -------- #
#############################
FROM node:22-slim AS builder

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

WORKDIR /app

# COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
COPY --chown=lingaro:lingaro package.json ./
COPY --chown=lingaro:lingaro yarn.lock* ./
COPY --chown=lingaro:lingaro package-lock.json* ./
COPY --chown=lingaro:lingaro pnpm-lock.yaml* ./

# TODO npm ci -> npm install
RUN if [ -f "yarn.lock" ]; then \
      npm install -g --force yarn \
      && yarn install --frozen-lockfile; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      npm install -g --force pnpm \
      && pnpm install --frozen-lockfile; \
    else \
      npm install; \
    fi

COPY --chown=lingaro:lingaro . .

RUN if [ -f "yarn.lock" ]; then \
      yarn build; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      pnpm run build; \
    else \
      npm run build; \
    fi

EXPOSE 3000

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

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock* ./
COPY --from=builder /app/package-lock.json* ./
COPY --from=builder /app/pnpm-lock.yaml* ./

RUN if [ -f "yarn.lock" ]; then \
      npm install -g --force yarn \
      && yarn install --frozen-lockfile --production; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      npm install -g --force pnpm \
      && pnpm install --frozen-lockfile --prod; \
    else \
      npm ci --omit=dev; \
    fi

# Clean up (run as root before switching users)
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create non-root 'lingaro' user without passwordless sudo
RUN groupadd -g 1001 lingaro \
    && useradd -u 1001 -g lingaro -m lingaro

USER lingaro

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    NODE_ENV=production \
    NODE_OPTIONS=--max-http-header-size=80000 \
    PATH=/workspaces/node_modules/.bin:$PATH
    # Azure environment variables removed per request

# Default shell
SHELL ["/bin/bash", "-c"]

EXPOSE 3000

# Use tini for proper signal handling if container is run directly
ENTRYPOINT ["tini", "--"]
CMD ["bash"]
