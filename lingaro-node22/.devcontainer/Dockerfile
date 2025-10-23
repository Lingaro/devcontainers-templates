#############################
# --- Multi-stage image --- #
#############################

##################
# ---  Base  --- #
##################
FROM node:22-slim AS base

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
RUN npm install -g --force yarn pnpm \
    && npm cache clean --force

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

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    NODE_OPTIONS=--max-http-header-size=80000 \
    PATH=/app/node_modules/.bin:$PATH
    # Azure environment variables removed per request

###################
# ---   Dev   --- #
###################
FROM base AS dev

ENV NODE_ENV=development

# AI TOOLS INSTALLATION *start*
# # Install Node.js
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
#     && apt-get install -y --no-install-recommends nodejs \
#     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Install clude-code, qwen-code, and create qwen-proxy script
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
# *end* AI TOOLS INSTALLATION

# Create non-root 'lingaro' user with passwordless sudo
RUN groupadd --gid 1001 lingaro || true \
    && useradd --uid 1001 --gid 1001 -m lingaro || true \
    && usermod -aG sudo lingaro \
    && echo "lingaro ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-lingaro \
    && chmod 0440 /etc/sudoers.d/90-lingaro

# Set up application directory with proper ownership
WORKDIR /app
RUN mkdir -p /app \
    && chown -R lingaro:lingaro /app
RUN mkdir -p /home/lingaro/.npm \
    && chown -R lingaro:lingaro /home/lingaro

COPY --chown=lingaro:lingaro package.json ./
COPY --chown=lingaro:lingaro yarn.lock* ./
COPY --chown=lingaro:lingaro package-lock.json* ./
COPY --chown=lingaro:lingaro pnpm-lock.yaml* ./

USER lingaro

# Install Node.js dependencies based on lock file
RUN if [ -f "yarn.lock" ]; then \
      yarn install --frozen-lockfile; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      pnpm install --frozen-lockfile; \
    elif [ -f "package-lock.json" ]; then \
      npm ci; \
    else \
      npm install; \
    fi

COPY --chown=lingaro:lingaro . .

# Build the application
RUN if [ -f "yarn.lock" ]; then \
      yarn build; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      pnpm run build; \
    else \
      npm run build; \
    fi

# Default shell
SHELL ["/bin/bash", "-c"]

EXPOSE 3000

##################
# ---  Prod  --- #
##################
FROM base AS prod

ENV NODE_ENV=production

WORKDIR /app

COPY --from=dev /app/build ./build
COPY --from=dev /app/package.json ./
COPY --from=dev /app/package-lock.json* ./
COPY --from=dev /app/yarn.lock* ./
COPY --from=dev /app/pnpm-lock.yaml* ./

RUN if [ -f "yarn.lock" ]; then \
      yarn install --frozen-lockfile --production; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      pnpm install --frozen-lockfile --prod; \
    elif [ -f "package-lock.json" ]; then \
      npm ci --omit=dev; \
    else \
      npm install --omit=dev; \
    fi

# Create non-root 'lingaro' user without passwordless sudo
RUN groupadd -g 1001 lingaro \
    && useradd -u 1001 -g lingaro -m lingaro

# Set proper ownership of application files
RUN chown -R lingaro:lingaro /app

USER lingaro

# Default shell
SHELL ["/bin/bash", "-c"]

EXPOSE 3000
