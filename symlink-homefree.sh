#!/usr/bin/env bash
set -euxo pipefail

# Keep this in sync with ./symlink.sh

DIR="$(realpath $(dirname $0))"

# TODO avoid copy/paste between here and ./symlink.sh
f() {
  if [[ -h $1 && ! -e $1 ]]; then
    echo "$1 is a BROKEN symlink, fixing it..." >&2
    rm "$1"
  fi

  if [ ! -e $1 ]
  then
    mkdir -p $(dirname $1)
    ln --symbolic --relative $DIR/$2 $1
  else
    ls -l $1
    echo "$1 ALREADY EXISTS, so NO NEW DOTFILES SYMLINK CREATED (rm it first to create)"
  fi
}

d() {
  mkdir -p $1
  find $DIR/$2 -maxdepth 1 -type f,l -exec ln -sfnr {} $1 \;
}

cp -R /etc/fish /etc/fish.original
mv /etc/inputrc /etc/inputrc.original
mv /etc/gitconfig /etc/gitconfig.original
f /etc/inputrc dotfiles/.inputrc
f /usr/local/etc/nanorc  dotfiles/.nanorc
f /etc/gitconfig dotfiles/gitconfig
d /etc/fish/ dotfiles/fish/
d /etc/fish/completions/ dotfiles/fish/completions/
d /etc/fish/conf.d/ dotfiles/fish/conf.d/
d /etc/fish/functions/ dotfiles/fish/functions/
f /etc/starship.toml dotfiles/starship.toml
# This ^^^ only works because `STARSHIP_CONFIG` is set to use it in fish/conf.d/starship.fish

# This ^^^ sets up the "homefree" config for containers with dotfiles in / instead of /home
# so that it works for all and any users and with an empty host-mounted $HOME.
# This is useful e.g. in Toolbox and Google Cloud Shell and similar.

# NOT WORKING: cp "$(dirname "$0")"/etc/profile.d/PATH_HOME-bin.sh /etc/profile.d/

# BEWARE of an an infinite loop in `/etc/inputrc` with its `$include /etc/inputrc`; replace that:
sed -i 's/inputrc/inputrc.original/' /etc/inputrc
