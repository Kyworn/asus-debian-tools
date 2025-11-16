# ASUS Tools for Debian 13

Automated installation script for ASUS laptop management tools on Debian 13 (Trixie). This script installs `supergfxctl` and `asusctl` to enable advanced hardware control on ASUS ROG and TUF laptops.

## Features

This installation provides:

- **supergfxctl**: GPU switching control for hybrid graphics laptops
  - Integrated mode (iGPU only)
  - Hybrid mode (dynamic switching)
  - Discrete mode (dGPU only)
  - ASUS MUX switch support

- **asusctl**: Complete ASUS laptop control suite
  - Fan curve management
  - Performance profiles
  - RGB keyboard control
  - Battery charge limit
  - Panel overdrive settings
  - AniMe Matrix display support (on compatible models)

## Supported Hardware

- ASUS ROG series laptops
- ASUS TUF series laptops
- ASUS Zephyrus series laptops
- Other ASUS gaming laptops with compatible hardware

**Tested on:**
- ASUS Flow x13
 
## Prerequisites

- **OS**: Debian 13 (Trixie) or newer
- **Kernel**: 6.1 or higher
- **Root access**: Required for installation
- **Internet connection**: Required for downloading packages

## Installation

### Quick Install

```bash
# Download the installation script
wget https://raw.githubusercontent.com/Kyworn/asus-debian-tools/main/asus_debian/install.sh

# Make it executable
chmod +x install.sh

# Run with root privileges
sudo ./install.sh

# Reboot your system
sudo reboot
```

### Manual Install

Clone this repository and run the installation script:

```bash
git clone https://github.com/Kyworn/asus-debian-tools.git
cd asus-debian-tools/asus_debian
chmod +x install.sh
sudo ./install.sh
sudo reboot
```

## What the Script Does

The installation script performs the following steps:

1. **System Requirements Check**
   - Verifies root privileges
   - Checks kernel version (≥ 6.1 required)

2. **Prerequisites Installation**
   - `curl`, `git`, `build-essential`

3. **Rust Toolchain**
   - Installs Rust (required for building supergfxctl)

4. **supergfxctl Installation**
   - Clones from GitLab repository
   - Builds and installs from source
   - Enables and starts `supergfxd` systemd service
   - Adds user to `adm` group

5. **asusctl Installation**
   - Adds GPG key and experimental PPA
   - Installs `rog-control-center` package
   - Reloads systemd and restarts `asusd` service

## Usage

### GPU Switching (supergfxctl)

```bash
# Check current GPU mode
supergfxctl -g

# Switch to integrated GPU (power saving)
supergfxctl -m Integrated

# Switch to hybrid mode (automatic switching)
supergfxctl -m Hybrid

# Switch to discrete GPU only (performance)
supergfxctl -m AsusMuxDgpu
```

**Note**: GPU mode changes require a logout/login or reboot to take effect.

### ASUS Control (asusctl)

```bash
# Check laptop profile
asusctl profile -l

# Set performance profile
asusctl profile -P Performance
asusctl profile -P Balanced
asusctl profile -P Quiet

# Fan control
asusctl fan-curve -m Performance -f cpu -e true

# Battery charge limit (e.g., 80%)
asusctl -c 80

# RGB keyboard control
asusctl led-mode static -c ff0000  # Red static color
asusctl led-mode breathe          # Breathing effect
```

### GUI Control

After installation, you can use the graphical interface:

```bash
# Launch ROG Control Center
rog-control-center
```

The GUI provides easy access to all features without command-line usage.

## Troubleshooting

### GPU switching doesn't work

```bash
# Check supergfxd service status
systemctl status supergfxd

# Restart the service
sudo systemctl restart supergfxd

# Check logs
journalctl -u supergfxd -f
```

### asusctl not responding

```bash
# Check asusd service
systemctl status asusd

# Restart the service
sudo systemctl restart asusd

# Check logs
journalctl -u asusd -f
```

### Permission issues

Make sure your user is in the `adm` group:

```bash
# Check group membership
groups

# If not in adm group, add it
sudo usermod -a -G adm $USER

# Logout and login again for changes to take effect
```

## Uninstallation

To remove the installed tools:

```bash
# Stop and disable services
sudo systemctl stop supergfxd asusd
sudo systemctl disable supergfxd asusd

# Remove packages
sudo apt remove rog-control-center

# Remove supergfxctl (if installed from source)
sudo rm -f /usr/bin/supergfxctl /usr/bin/supergfxd
sudo rm -f /etc/systemd/system/supergfxd.service

# Remove PPA
sudo rm /etc/apt/sources.list.d/asusctl.list
sudo apt update
```

## Important Notes

⚠️ **Disclaimer**: This script is experimental and not officially supported by Debian or ASUS.

- The asusctl installation uses an **experimental PPA** originally designed for Ubuntu
- Some features may not work on all laptop models
- Use at your own risk
- Always backup your data before installation

## Contributing

Contributions are welcome! If you encounter issues or have improvements:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -m 'Add improvement'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

## Resources

- [supergfxctl GitLab](https://gitlab.com/asus-linux/supergfxctl)
- [asusctl GitHub](https://github.com/flukejones/asusctl)
- [ASUS Linux Community](https://asus-linux.org/)
- [Debian Wiki - ASUS Laptops](https://wiki.debian.org/InstallingDebianOn/Asus)

## License

This installation script is provided as-is under the MIT License.

## Author

Maintained by [Kyworn](https://github.com/Kyworn)

## Acknowledgments

- [asus-linux.org](https://asus-linux.org/) community for the excellent tools
- [Luke Jones](https://github.com/flukejones) for asusctl development
- [supergfxctl](https://gitlab.com/asus-linux/supergfxctl) team
