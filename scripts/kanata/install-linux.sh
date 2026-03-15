#!/bin/bash

set -euxo pipefail

echo "Starting secure Kanata installation..."

# 1. Idempotent user creation
if id "kanata-svc" &>/dev/null; then
    echo "User kanata-svc already exists, skipping creation."
else
    sudo useradd --system --no-create-home --shell /usr/sbin/nologin kanata-svc
fi

# 2. Add the service user to the input group
sudo usermod -aG input kanata-svc

# 3. Create uinput group (idempotent via -f) and add the user
sudo groupadd -f uinput
sudo usermod -aG uinput kanata-svc

# 4. Write udev rule
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-uinput.rules > /dev/null

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# 5. Set up the configuration directory and file (idempotent via -p and overwrite)
sudo mkdir -p /etc/kanata
sudo cp scripts/kanata/kanata.kbd /etc/kanata/
sudo chown kanata-svc:kanata-svc /etc/kanata/kanata.kbd
sudo chmod 600 /etc/kanata/kanata.kbd

# 6. Install and start the systemd service
sudo cp scripts/kanata/kanata.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now kanata.service

echo "Installation complete! Check status with: systemctl status kanata.service"
