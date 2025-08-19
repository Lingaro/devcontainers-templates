FROM python:3.12-slim

# Set working directory
WORKDIR /workspaces/lingaro-azure-databricks-py312-slim-ds

# Install system dependencies including Zsh
RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    curl \
    wget \
    build-essential \
    ca-certificates \
    lsb-release \
    gnupg \
    procps \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Install UV for fast package management
RUN pip install --upgrade pip && pip install uv

# Copy requirements EARLY to leverage Docker cache
COPY requirements.txt .

# Install Python packages with UV (this layer will be cached if requirements.txt doesn't change)
RUN uv pip install --system -r requirements.txt

# Install Azure CLI using the install script method (works on all Debian versions)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Copy and setup Zsh configuration script
COPY scripts/setup-zsh.sh /tmp/setup-zsh.sh
RUN chmod +x /tmp/setup-zsh.sh && /tmp/setup-zsh.sh && rm /tmp/setup-zsh.sh

# Setup Git LFS
RUN git lfs install --system

# Create necessary directories (except scripts which will be copied)
RUN mkdir -p /workspaces/lingaro-azure-databricks-py312-slim-ds/{data,models,mlruns}

# Set environment variables
ENV PYTHONPATH=/workspaces/lingaro-azure-databricks-py312-slim-ds
ENV JUPYTER_PORT=8888
ENV MLFLOW_PORT=5000
ENV APP_PORT=8000

# Setup ports from environment variables
EXPOSE $JUPYTER_PORT $MLFLOW_PORT $APP_PORT
ENV JUPYTER_ENABLE_LAB=yes
ENV MLFLOW_TRACKING_URI=http://localhost:$MLFLOW_PORT

# Copy and make scripts executable
COPY scripts/ /workspaces/lingaro-azure-databricks-py312-slim-ds/scripts/
RUN chmod +x /workspaces/lingaro-azure-databricks-py312-slim-ds/scripts/*.sh


