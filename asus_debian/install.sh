#!/bin/bash

# This script automates the installation of supergfxctl and asusctl on Debian 13.
# It is intended to be run on a fresh Debian 13 installation.
#
# Disclaimer:
# This script is provided as-is. The author is not responsible for any damage
# caused by this script. The asusctl installation is experimental and may not
# work on all systems.

set -e

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Check kernel version
KERNEL_VERSION=$(uname -r)
if [[ ! "$KERNEL_VERSION" > "6.1" ]]; then
    echo "Kernel version 6.1 or higher is required."
    exit
fi

# Install prerequisites
echo "Installing prerequisites..."
apt update
apt install -y curl git build-essential

# Install Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Install supergfxctl
echo "Installing supergfxctl..."
git clone https://gitlab.com/asus-linux/supergfxctl.git
cd supergfxctl
make && make install
cd ..
rm -rf supergfxctl

# Enable and start supergfxd service
echo "Enabling and starting supergfxd service..."
systemctl enable supergfxd.service --now

# Add user to adm group
echo "Adding user to adm group..."
usermod -a -G adm $SUDO_USER

# Install asusctl
echo "Installing asusctl..."
mkdir -p /usr/local/share/keyrings
curl -S "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x1d4f9ce6e1492b69c43e95a3d60afa41a606bc01" | gpg --batch --yes --dearmor --output "/usr/local/share/keyrings/asusctl-ma-keyring.gpg"
echo "deb [signed-by=/usr/local/share/keyrings/asusctl-ma-keyring.gpg] https://ppa.launchpadcontent.net/mitchellaugustin/asusctl/ubuntu oracular main" | tee /etc/apt/sources.list.d/asusctl.list
apt update
apt install -y rog-control-center

# Reload systemd daemon and restart asusd
echo "Reloading systemd daemon and restarting asusd..."
systemctl daemon-reload
systemctl restart asusd

echo "Installation complete. A reboot is recommended."
