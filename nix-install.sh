#!/usr/bin/env bash
set -euxo pipefail

# Run home-manager to set up the Nix-based dotfiles environment.
# Requires nix to already be installed; see:
# https://github.com/vorburger/LearningLinux/blob/develop/nix/docs/install.md

DIR="$(realpath "$(dirname "$0")")"

nix --extra-experimental-features "nix-command flakes" run nixpkgs#home-manager -- switch --flake "$DIR/dotfiles/home-manager"
