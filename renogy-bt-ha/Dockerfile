ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

# Install all necessary system dependencies for bleak, Bluetooth, and monitoring
RUN apk add --no-cache \
    python3 \
    py3-pip \
    bluez \
    bluez-dev \
    gcc \
    musl-dev \
    build-base \
    linux-headers \
    glibc \
    zlib-dev \
    dbus  # Add dbus for Bluetooth stability

# Check Python version
RUN python3 --version

# Install bashio for Home Assistant add-on compatibility
RUN mkdir -p /usr/local/bin/bashio && \
    wget -O /usr/local/bin/bashio/bashio "https://github.com/hassio-addons/bashio/archive/main.tar.gz" && \
    tar -xzf /usr/local/bin/bashio/bashio --strip 1 && \
    chmod a+x /usr/local/bin/bashio/bashio

# Ensure pip is installed and upgraded correctly, with retries
RUN for i in {1..5}; do \
    python3 -m ensurepip --upgrade && break || sleep 10; \
    done || (echo "Failed to install ensurepip after retries" && exit 1)
RUN for i in {1..5}; do \
    pip3 install --no-cache-dir --upgrade pip && break || sleep 10; \
    done || (echo "Failed to upgrade pip after retries" && exit 1)

# Install Python packages with retries, verbose output, and specific bleak version
RUN for i in {1..15}; do \  # Increase retries for reliability
    pip3 install --no-cache-dir --verbose \
        bleak==0.22.3 \
        paho-mqtt && \
    break || sleep 20; \
    done || (echo "Failed to install Python packages after retries" && pip3 list && cat /var/log/pip.log && exit 1)

# Verify bleak installation with detailed logging
RUN python3 -c "import bleak; print('Bleak installed successfully')" || (echo "Bleak installation failed" && pip3 show bleak || pip3 list && cat /var/log/pip.log && echo "Checking logs for details" && exit 1)

# Ensure BlueZ is running and configured
RUN rc-service bluetooth start || true  # Try to start Bluetooth if not already running

# Copy add-on files
COPY run.sh /run.sh
COPY renogy_bt.py /renogy_bt.py  # Corrected from previous typo (was /run.sh)

# Set permissions
RUN chmod a+x /run.sh

# Run the script
CMD ["/run.sh"]
