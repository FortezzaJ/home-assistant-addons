ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

# Install system dependencies for Bluetooth and Python
RUN apk add --no-cache \
    python3 \
    py3-pip \
    bluez \
    bluez-dev \
    gcc \
    musl-dev \
    build-base \
    linux-headers \
    bash \
    curl

# Install bashio (latest stable version as of Feb 2025)
RUN curl -J -L -o /tmp/bashio.tar.gz "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" && \
    mkdir -p /usr/lib/bashio && \
    tar -xzf /tmp/bashio.tar.gz -C /usr/lib/bashio --strip-components=1 && \
    rm /tmp/bashio.tar.gz && \
    ln -s /usr/lib/bashio/bashio.sh /usr/bin/bashio && \
    chmod +x /usr/bin/bashio

# Ensure pip is installed and upgraded
RUN python3 -m ensurepip --upgrade && \
    pip3 install --no-cache-dir --upgrade pip

# Install Python dependencies from renogy_bt.py
RUN pip3 install --no-cache-dir \
    renogybt \
    paho-mqtt \
    pybluez

# Copy add-on files
COPY run.sh /run.sh
COPY renogy_bt.py /renogy_bt.py

# Set permissions
RUN chmod a+x /run.sh /renogy_bt.py

# Run the script
CMD ["/run.sh"]
