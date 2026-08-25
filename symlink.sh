#!/usr/bin/env bash
set -euo pipefail

# TODO Clean-up and unify the messy file naming conventions - everything should simply be exactly where it ends up!

# TODO Why not just hard- instead of soft-link everything? Research other dotfiles frameworks..

# TODO Simplify and just link everything under dotfiles/ into $HOME

# TODO Flip order - it would be more logically readable if it was flipped (source to target)

# See also ./symlink-homefree.sh for an equivalent which does not use $HOME
# TODO avoid copy/paste between here and ./symlink-homefree.sh

DIR="$(realpath $(dirname "$0"))"

f() {
  _f "soft" "$1" "$2"
}

fh() {
  _f "hard" "$1" "$2"
}

_f() {
  local mode=$1
  local target=$2
  local source=$3
  local dest="$HOME/$target"
  local src_path="$DIR/$source"

  if [[ -h "$dest" && ! -e "$dest" ]]; then
    echo "$dest is a BROKEN symlink, fixing it..." >&2
    rm "$dest"
  fi

  if [[ ! -e "$dest" ]]; then
    mkdir -p "$(dirname "$dest")"
    if [[ "$mode" == "soft" ]]; then
      ln --symbolic --relative "$src_path" "$dest"
    else
      ln "$src_path" "$dest"
    fi
    echo "$mode linked $dest"
  else
    # It exists. Check if it is the correct link.
    if [[ "$dest" -ef "$src_path" ]]; then
      # It is the correct link (either soft or hard), all good.
      # If we're in hard-link mode, but it's currently a soft link, we might want to change it.
      if [[ "$mode" == "hard" && -L "$dest" ]]; then
        echo "$dest is a soft link but should be a hard link. Fixing..." >&2
        rm "$dest"
        ln "$src_path" "$dest"
        echo "hard linked $dest"
      fi
    elif [[ -L "$dest" && "$(realpath "$dest")" == /nix/store/* ]]; then
      # It is managed by Nix, which is also fine.
      :
    else
      # It is not the correct link.
      if [[ "${CODESPACES:-}" == "true" ]]; then
        echo "$dest already exists and is not the correct link. Backing up to $dest.bak and overwriting, because CODESPACES is set." >&2
        mv "$dest" "$dest.bak"
        if [[ "$mode" == "soft" ]]; then
          ln --symbolic --relative "$src_path" "$dest"
        else
          ln "$src_path" "$dest"
        fi
        echo "$mode linked $dest"
      else
        echo "$dest already exists and is not the correct link (and we're not in a Codespace)." >&2
        if [[ -L "$dest" ]]; then
          echo "  it is a soft link pointing to: $(readlink "$dest") -> $(realpath "$dest")" >&2
          echo "  should point to: $(realpath "$src_path")" >&2
        else
          echo "  it is a regular file (different inode), maybe it was a hard link that got broken? Diff:" >&2
          diff -u "$src_path" "$dest" >&2 || true
          echo
          echo "  consider: cp $dest $src_path && ln -f $src_path $dest" >&2
        fi
        exit 1
      fi
    fi
  fi
}

d() {
  local target_dir="$1"
  local source_dir="$2"
  mkdir -p ~/"$target_dir"
  # Replace find with a loop to get the desired output format
  while IFS= read -r -d '' src; do
    local base="${src##*/}"
    local dst="$HOME/$target_dir"
    [[ "$dst" != */ ]] && dst="$dst/"
    dst="${dst}${base}"
    if [[ -L "$dst" && "$(realpath "$dst")" == /nix/store/* ]]; then
      # Managed by Nix, skip
      continue
    fi
    if [[ ! -L "$dst" || ! "$dst" -ef "$src" ]]; then
      ln -sfnr "$src" "$dst"
      echo "soft linked $dst"
    fi
  done < <(find "$DIR/$source_dir" -maxdepth 1 -type f,l -print0)
}

# If this script runs before gpg had a chance to create ~/.gnupg/ itself,
# then it will have rwxr-xr-x instead of drwx------ which will cauge gpg to print:
# gpg: WARNING: unsafe permissions on homedir '/home/vorburger/.gnupg'
# Let's fix that like this:
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# TODO Simplify this by moving everything to the expected place in git already...
f .tool-versions dotfiles/.tool-versions
# TODO Fully remove Bash customizations, as interactive shell is Fish:
#   f .bashrc dotfiles/bashrc
d .bash.d/ dotfiles/bash.d/
f .bazelrc dotfiles/.bazelrc
f .inputrc dotfiles/.inputrc
f .nanorc  dotfiles/.nanorc
f .npmrc   dotfiles/.npmrc
# f .wakatime.cfg dotfiles/wakatime.cfg
f .tmux.conf dotfiles/.tmux.conf
f .gnupg/gpg.conf dotfiles/gpg.conf
f .gnupg/gpg-agent.conf dotfiles/gpg-agent.conf
f .gnupg/scdaemon.conf dotfiles/.gnupg/scdaemon.conf
f .gitconfig dotfiles/gitconfig
d .local/share/gh-triage/ dotfiles/.local/share/gh-triage/
d .local/share/applications/ dotfiles/desktop/
d .config/bat/ dotfiles/bat/
d .config/git/ dotfiles/git/
d .config/kitty/ dotfiles/kitty/
d .config/fish/ dotfiles/fish/
d .config/fish/completions/ dotfiles/fish/completions/
d .config/fish/conf.d/ dotfiles/fish/conf.d/
d .config/fish/functions/ dotfiles/fish/functions/
d .config/home-manager/ dotfiles/home-manager/
d .config/nix dotfiles/nix
d .config/autostart/ dotfiles/autostart/
f .config/starship.toml dotfiles/starship.toml
f .config/sway/config dotfiles/.config/sway/config
f .config/weston.ini dotfiles/.config/weston.ini
f .config/lsd/config.yaml dotfiles/lsd.yaml
f .m2/toolchains.xml dotfiles/m2/toolchains.xml
fh .gemini/policies/auto-saved.toml dotfiles/.gemini/policies/auto-saved.toml
f .gemini/GEMINI.md dotfiles/.gemini/GEMINI.md
f .gemini/antigravity-cli/settings.json dotfiles/.gemini/antigravity-cli/settings.json
f .config/Code/User/mcp.json dotfiles/code/mcp.json
f .config/Code/User/settings.json dotfiles/code/settings.json
f .config/Code/User/keybindings.json dotfiles/code/keybindings.json
f .config/Code/User/snippets/personal.code-snippets dotfiles/code/personal.code-snippets
f .config/Antigravity/User/settings.json dotfiles/code/settings.json
f .config/Antigravity/User/keybindings.json dotfiles/code/keybindings.json
f .config/Antigravity/User/snippets/personal.code-snippets dotfiles/code/personal.code-snippets
f .config/rygel.conf dotfiles/rygel.conf

# This is used by dotfiles/.gemini/GEMINI.md
if [[ ! "$HOME/.gemini/aifiles" -ef "$HOME/git/github.com/vorburger/aifiles" ]]; then
  ln -fs "$HOME/git/github.com/vorburger/aifiles" "$HOME/.gemini/"
  echo "soft linked $HOME/.gemini/aifiles"
fi

if [ "$(command -v desktop-file-validate)" ]; then
  desktop-file-validate ~/.local/share/applications/*.desktop
  # desktop-file-install --dir=~/.local/share/applications/ ~/.local/share/applications/*.desktop
  update-desktop-database ~/.local/share/applications
fi
