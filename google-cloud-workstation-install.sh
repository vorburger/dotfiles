#!/usr/bin/env bash
set -euxo pipefail

# Google Cloud Workstation's /etc/lsb-release identifies it as based on Ubuntu (24.04) - not Debian
./ubuntu-install.sh
./symlink.sh
