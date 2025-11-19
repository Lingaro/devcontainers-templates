# ==============================================================================
# BASE IMAGE AND WORKSPACE SETUP
# ==============================================================================
FROM python:3.10.11-slim

ARG SPARK_VERSION=3.4.1
ARG HADOOP_VERSION=3.3.5
ARG SPARK_PACKAGE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
ARG SPARK_ARCHIVE="${SPARK_PACKAGE}.tgz"
ARG SPARK_DOWNLOAD_URL="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_ARCHIVE}"
ARG HADOOP_DOWNLOAD_URL="https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

# Set working directory
WORKDIR /workspaces/lingaro-azure-py310-ccep-udp

# ==============================================================================
# SYSTEM DEPENDENCIES AND PACKAGE INSTALLATION
# ==============================================================================
# Install system dependencies including development tools, Java, and utilities
RUN apt-get update && apt-get install -y \
    # Version control and Git LFS
    git \
    git-lfs \
    # Network and download tools
    curl \
    wget \
    netcat-openbsd \
    # Build and development tools
    build-essential \
    ca-certificates \
    lsb-release \
    gnupg \
    procps \
    # Shell and SSH tools
    zsh \
    rsync \
    # Java Development Kit
    openjdk-11-jdk && \
    # Clean up package cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ==============================================================================
# JAVA ENVIRONMENT SETUP
# ==============================================================================
# Create symlink for Java installation and set environment variables
RUN cd /usr/lib/jvm && \
    TARGET_DIR=$(readlink java-1.11.0-openjdk-*) && \
    ln -s "$TARGET_DIR" default-java

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="$PATH:$JAVA_HOME/bin"

# Verify Java installation
RUN java -version && javac -version

# ==============================================================================
# HADOOP INSTALLATION AND CONFIGURATION
# ==============================================================================
# Re-declare ARGs to make them available in this build context
ARG HADOOP_VERSION=3.3.5
ARG HADOOP_DOWNLOAD_URL="https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

# Download and install Hadoop using version from ARG
RUN wget ${HADOOP_DOWNLOAD_URL} && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

# Set Hadoop environment variables
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Create necessary directories for Hadoop (standalone mode)
RUN mkdir -p /home/hadoop/logs && \
    mkdir -p /tmp/hadoop-root && \
    chmod 755 /tmp/hadoop-root

# Copy Hadoop configuration files
COPY hadoop-config/core-site.xml $HADOOP_CONF_DIR/core-site.xml

# ==============================================================================
# SPARK INSTALLATION AND CONFIGURATION
# ==============================================================================
# Re-declare ARGs to make them available in this build context
ARG SPARK_VERSION=3.5.7
ARG HADOOP_VERSION=3
ARG SPARK_PACKAGE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
ARG SPARK_ARCHIVE="${SPARK_PACKAGE}.tgz"
ARG SPARK_DOWNLOAD_URL="https://downloads.apache.org/spark/spark-${SPARK_VERSION}/${SPARK_ARCHIVE}"

# Download and extract Spark
RUN wget ${SPARK_DOWNLOAD_URL} && \
    tar -xzf ${SPARK_ARCHIVE} && \
    mv ${SPARK_PACKAGE} /opt/spark && \
    rm ${SPARK_ARCHIVE} && \
    mkdir -p /opt/spark/logs && \
    chmod -R 755 /opt/spark

# Configure environment variables
ENV SPARK_HOME=/opt/spark
ENV PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH

# Expose default Spark ports
EXPOSE 4040 7077 8080 8081

# ==============================================================================
# PYTHON ENVIRONMENT AND DEPENDENCIES
# ==============================================================================
# Install UV for fast package management
RUN pip install --upgrade pip && pip install uv

# Copy requirements early to leverage Docker cache
COPY requirements.txt .

# Install Python packages with UV (cached layer if requirements.txt unchanged)
RUN uv pip install --system -r requirements.txt

# Set PySpark and Python environment variables
ENV PYSPARK_PYTHON=python
ENV PYTHONPATH=/workspaces/lingaro-azure-py310-ccep-udp:/workspaces/lingaro-azure-py310-ccep-udp/src

# ==============================================================================
# AZURE CLI INSTALLATION
# ==============================================================================
# Install Azure CLI using the official install script
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# ==============================================================================
# SHELL CONFIGURATION
# ==============================================================================
# Copy and set up Zsh configuration
COPY scripts/setup-zsh.sh /tmp/setup-zsh.sh
RUN chmod +x /tmp/setup-zsh.sh && /tmp/setup-zsh.sh

# Set Zsh as default shell for subsequent RUN commands
SHELL ["/bin/zsh", "-c"]

# ==============================================================================
# CONTAINER STARTUP
# ==============================================================================
# Set default command to start Zsh shell
CMD ["/bin/zsh"]