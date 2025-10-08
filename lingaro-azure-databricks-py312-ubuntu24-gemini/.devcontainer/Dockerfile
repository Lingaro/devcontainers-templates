# Databricks with Gemini Dev Container Image
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
    unzip \
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

# Install Java 17 (required for Databricks and Spark)
RUN apt-get update && apt-get install -y openjdk-17-jdk && rm -rf /var/lib/apt/lists/*
# Set JAVA_HOME dynamically to work on both ARM and AMD architectures
RUN export ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "arm64" ]; then \
         export JAVA_DIR="java-17-openjdk-arm64"; \
       elif [ "$ARCH" = "amd64" ]; then \
         export JAVA_DIR="java-17-openjdk-amd64"; \
       else \
         export JAVA_DIR="java-17-openjdk-$ARCH"; \
       fi \
    && ln -sf /usr/lib/jvm/$JAVA_DIR /usr/lib/jvm/java-17-openjdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$PATH:$JAVA_HOME/bin

# Install new Databricks CLI
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh

# Install Google Cloud SDK for Gemini support
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update && apt-get install -y google-cloud-sdk \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies from requirements.txt
COPY requirements.txt ./
RUN if [ -s requirements.txt ]; then \
        uv pip install --system -r requirements.txt; \
    fi

# Set up environment variables for Databricks
ENV DATABRICKS_CONFIG_FILE=/workspaces/.databrickscfg
ENV SPARK_HOME=/usr/local/lib/python3.12/site-packages/pyspark
ENV PATH=$PATH:$SPARK_HOME/bin

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Python environment
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Azure, Databricks and Gemini specific environment variables
ENV AZURE_CONFIG_DIR=/workspaces/.azure
ENV AZURE_EXTENSION_DIR=/workspaces/.azure/extensions
ENV GOOGLE_APPLICATION_CREDENTIALS=/workspaces/.config/gcloud/application_default_credentials.json

# Set default shell and working directory
SHELL ["/bin/bash", "-c"]
WORKDIR /workspaces
