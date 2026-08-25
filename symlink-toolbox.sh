#!/usr/bin/env bash
set -euox pipefail

# TODO Replace this older approach with the newer ./symlink-homefree.sh idea and remove this

DIR="$(realpath $(dirname $0))"

l() {
  if [[ -h ~/$1 && ! -e ~/$1 ]]; then
    echo "$HOME/$1 is a BROKEN symlink, fixing it..." >&2
    rm ~/"$1"
  fi

  if [[ ! -e ~/$1 ]]; then
    mkdir -p "$(dirname ~/"$1")"
    ln --symbolic --relative "$DIR"/"$2" ~/"$1"
  fi
}

x() {
  mkdir -p ~/$1
  find $DIR/$2* -exec ln -sfnr {} ~/$1 \;
}

l .inputrc dotfiles/.inputrc
l .tmux.conf dotfiles/.tmux.conf
## x .config/fish/functions/ dotfiles/fish/functions/
x .config/fish/ dotfiles/fish/
# l .config/starship.toml dotfiles/starship.toml
