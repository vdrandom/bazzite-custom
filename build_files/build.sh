#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y \
  eza fd helix tmux zsh \
  qemu-system-x86
dnf5 install -y --enablerepo=brave-browser \
  brave-origin

# Use a COPR Example:
#
dnf5 -y copr enable scottames/ghostty
dnf5 -y install ghostty
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable scottames/ghostty

#### Example for enabling a System Unit File

# systemctl enable podman.socket

read -r heroic_url < <(
  curl https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest \
    | jq -r '.assets[] | select(.name | endswith("x86_64.rpm")) | .browser_download_url'
  )

dnf5 -y install "$heroic_url"
