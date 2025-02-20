#!/usr/bin/env bash
source /usr/bin/bashio

bashio::log.info "Starting Renogy BT Add-on..."

# Ensure Bluetooth is up (optional, for debugging)
hciconfig hci0 up || bashio::log.warning "Failed to enable Bluetooth, continuing anyway..."

# Run the Python script
python3 /renogy_bt.py || bashio::log.error "Renogy BT script failed!"
