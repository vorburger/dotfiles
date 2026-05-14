#!/usr/bin/env bash
set -euxo pipefail

# https://cloud.google.com/sdk/docs/install#rpm
[ -s /etc/yum.repos.d/google-cloud-sdk.repo ] || sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

sudo dnf install -y \
    glibc-langpack-en glibc-all-langpacks \
    rpl psmisc procps-ng \
    bash-completion \
    dnf-automatic dnf5-plugin-automatic dnf-plugins-core dnf5-plugins \
    golang git htop \
    java-latest-openjdk-devel java-latest-openjdk-src java-latest-openjdk-javadoc java-latest-openjdk-javadoc-zip java-latest-openjdk-jmods \
    trash-cli ShellCheck tmux wipe wl-clipboard \
    fd-find bat \
    automake autoconf texinfo gettext-devel ncurses-devel \
    pwgen diceware \
    graphviz \
    python3-devel portaudio-devel \
    git-delta rclone \
    gcc gcc-c++ clang-tools-extra \
    nodejs xrandr \
    ruby-devel rubygems \
    openssl-devel \
    dracut-config-rescue \
    pandoc pipx rubygem-mustache zlib-devel
# helm google-cloud-sdk google-cloud-sdk-skaffold \
# clang-tools-extra for clang-format, gcc-c++ is used by Bazel Protobuf
# xrandr is required by Minecraft client to fix ArrayIndexOutOfBoundsException at org.lwjgl.opengl.LinuxDisplay.getAvailableDisplayModes()
# openssl-devel is used (only, so far) by https://github.com/swsnr/mdcat
# rubygem-mustache Mustache v1.1.1 is *NEWER* than https://github.com/mustache/mustache/releases, but latest from https://github.com/mustache/mustache/tags

# dracut-config-rescue as per https://docs.fedoraproject.org/en-US/quick-docs/upgrading-fedora-offline/#sect-update-rescue-kernel

# https://github.com/pypa/pipx?tab=readme-ov-file#shell-completions
mkdir -p ~/.config/fish/completions/
register-python-argcomplete --shell fish pipx >~/.config/fish/completions/pipx.fish

# Do NOT add the "kubernetes-client" package above, but it causes this error:
# file /usr/bin/kubectl conflicts between attempted installs of kubernetes-client-1.21.0-2.fc35.x86_64 and kubectl-1.23.0-0.x86_64
# (at least when run as part of ./container/build.sh which is FROM fedora:35 in container/fedora-updated/Dockerfile)

sudo echo '[commands]
apply_updates = yes
' | sudo tee -a /etc/dnf/automatic.conf

# Also in setup.sh
if [ $(ps --no-headers -o comm 1) = "systemd" ]; then
  sudo systemctl enable --now dnf5-automatic.timer
  systemctl status dnf5-automatic.timer
else
  echo "Not enabling dnf5-automatic.timer, because no systemd"
fi

./systemd-install.sh

sudo dnf update -y

sudo dnf remove -y "libreoffice*"

# sudo alternatives --config java
# sudo alternatives --config javac
# sudo alternatives --config java_sdk_openjdk
