# Install ASUS Tools on Debian 13

This script automates the installation of `supergfxctl` and `asusctl` on Debian 13. These tools are useful for managing graphics and other features on ASUS laptops.

## Disclaimer

This script is intended for **Debian 13 (Trixie)**. It may not work on other versions of Debian or other distributions. The installation of `asusctl` uses an experimental PPA and is not officially supported on Debian. Use this script at your own risk.

## Prerequisites

- A fresh installation of Debian 13 (Trixie).
- An internet connection.

## Usage

1.  **Download the script:**

    ```bash
    wget https://raw.githubusercontent.com/your-username/your-repo/main/install_asus_tools.sh
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x install_asus_tools.sh
    ```

3.  **Run the script with root privileges:**

    ```bash
    sudo ./install_asus_tools.sh
    ```

4.  **Reboot your system:**

    After the script finishes, it is recommended to reboot your system for all changes to take effect.

## What the script does

The script performs the following steps:

1.  **Installs prerequisites:** `curl`, `git`, and `build-essential`.
2.  **Installs Rust:** The programming language used to build `supergfxctl`.
3.  **Installs `supergfxctl`:**
    - Clones the `supergfxctl` repository from GitLab.
    - Builds and installs `supergfxctl`.
    - Enables and starts the `supergfxd` systemd service.
    - Adds the user to the `adm` group.
4.  **Installs `asusctl`:**
    - Adds a GPG key and an experimental PPA for `asusctl`.
    - Installs `rog-control-center`, which includes `asusctl`.
    - Reloads the systemd daemon and restarts the `asusd` service.
