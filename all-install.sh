#!/usr/bin/env bash
set -euxo pipefail

# apt|dnf-install.sh has DNF RPM / APT DEB packages, this is everything else

DIR="$(realpath $(dirname "$0"))"

[ -s /usr/bin/nano ] || [ -s "$HOME"/bin/nano ] || "$(dirname "$0")"/install-nano.sh

# see https://github.com/jorgebucaran/fisher/issues/742
# and https://github.com/vorburger/dotfiles-reproduce-problem
# and https://github.com/orgs/community/discussions/35527
exec </dev/null

fish "$DIR"/fish-install.fish

# https://github.com/jorgebucaran/fisher
[ -s "$HOME"/.config/fish/functions/fisher.fish ] || ( \
  curl -sL https://git.io/fisher -o /tmp/fisher && \
  fish -c "source /tmp/fisher && fisher install jorgebucaran/fisher")

# https://github.com/tmux-plugins/tpm/blob/master/docs/automatic_tpm_installation.md
# Note: dotfiles/.tmux.conf also has code to install TPM if it's missing when tmux starts,
# but installing it here ensures all plugins are pre-installed before the first run.
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  if command -v tmux &> /dev/null; then
    ~/.tmux/plugins/tpm/bin/install_plugins
  else
    echo "Skipping tmux plugin installation because tmux is not installed."
  fi
fi

# https://github.com/junegunn/fzf#using-git
# if [ ! $(command -v fzf) ]; then
if [ ! -d ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi
~/.fzf/bin/fzf --version

# Go NOT like this, because this assumes we have an older golang system package, which is confusing:
#   go get golang.org/dl/go1.15.8
#   eval $(go1.15.8 env GOROOT)
# https://golang.org/doc/install
if [ ! "$(command -v go)" ]; then
  curl -fsSL https://golang.org/dl/go1.24.0.linux-amd64.tar.gz -o /tmp/go.tgz
  sudo tar -C /usr/local -xzf /tmp/go.tgz
  sudo ln -s /usr/local/go/bin/go* /usr/local/bin/
fi
go version

# https://github.com/apache/maven-mvnd/
# TODO Fix broken installation on GitHub Codespaces (but I currently don't use it anyway)
# mkdir -p $HOME/.m2/ $HOME/bin/
# [ -s $HOME/bin/mvnd ] || "$(dirname "$0")"/install-github.sh apache/maven-mvnd 0.8.0 maven-mvnd-0.8.0-linux-amd64 mvnd && \
#   mv /tmp/install-github/apache/maven-mvnd/mvnd-0.8.0-linux-amd64 $HOME/bin/ && \
#   ln -s $HOME/bin/mvnd-0.8.0-linux-amd64/bin/mvnd $HOME/bin
# [ -s $HOME/.m2/mvnd.properties ] || echo "java.home=/etc/alternatives/java_sdk/" >$HOME/.m2/mvnd.properties

# GO_BIN_PATH may not match GOPATH (it could be unset)
GO_BIN_PATH=$(go env GOPATH)/bin

# ===============================================================================================================================

# Like in apt-install.sh, most of these tools don't need to be pre-installed into GitHub Codespaces, or only via prebuilt Dev Container:
if [[ -z "${CODESPACES:-}" ]]; then

  # https://github.com/bazelbuild/buildtools/tree/master/buildifier
  [ -s "$GO_BIN_PATH"/buildifier ] || go install github.com/bazelbuild/buildtools/buildifier@latest

  # https://github.com/bazelbuild/buildtools/blob/master/buildozer/README.md
  [ -s "$GO_BIN_PATH"/buildozer ] || go install github.com/bazelbuild/buildtools/buildozer@latest

  # https://github.com/bazelbuild/bazel-watcher
  # npm install -g @bazel/ibazel

  # https://github.com/yoheimuta/protolint
  [ -s "$GO_BIN_PATH"/protolint ] || go install github.com/yoheimuta/protolint/cmd/protolint@latest

  # https://github.com/mikefarah/yq#go-get
  [ -s "$GO_BIN_PATH"/yq ] || go install github.com/mikefarah/yq/v4@latest

  # https://github.com/hidetatz/kubecolor (WAS https://github.com/dty1er/kubecolor)
  # ALSO https://github.com/kubecolor/kubecolor/; see https://github.com/hidetatz/kubecolor/issues/95
  # (also https://github.com/hidetatz/kubecolor/issues/101 and https://github.com/hidetatz/kubecolor/issues/113)
  [ -s "$GO_BIN_PATH"/kubecolor ] || go install github.com/hidetatz/kubecolor/cmd/kubecolor@latest

  # https://github.com/yannh/kubeconform#Installation
  [ -s "$GO_BIN_PATH"/kubeconform ] || go install github.com/yannh/kubeconform/cmd/kubeconform@latest

  # TODO Add Rust to home.nix ?
  # https://rustup.rs (AKA cargo)
  # [ -s "$HOME"/.rustup/settings.toml ] || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # https://github.com/cargo-bins/cargo-binstall (AKA cargo binstall)
  # [ -s "$HOME/.cargo/bin/cargo-binstall" ] || curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
  # ? source "$HOME/.bashrc"

  # https://github.com/evanlucas/fish-kubectl-completions
  # TODO remove when https://github.com/kubernetes/kubectl/issues/576 is available
  # see https://github.com/evanlucas/fish-kubectl-completions/issues/33
  [ -s "$HOME"/.config/fish/completions/kubectl.fish ] || fish -c "fisher install evanlucas/fish-kubectl-completions"

  # https://github.com/lgathy/google-cloud-sdk-fish-completion for gcloud
  [ -s "$HOME"/.config/fish/completions/gcloud.fish ] || fish -c "fisher install lgathy/google-cloud-sdk-fish-completion"

  # ToDo: https://github.com/edc/bass ?

  # https://asdf-vm.com/guide/getting-started.html
  # dotfiles/fish/conf.d/asdf.fish has the Fish shell related initialization
  [ -d "$HOME"/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
  [ -s "$HOME"/.config/fish/completions/asdf.fish ] || ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

  ~/.asdf/bin/asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git

  # TODO Manage *all* Java installations with ASDF instead of DNF?!
  # ~/.asdf/bin/asdf plugin-add java https://github.com/halcyon/asdf-java.git

  # https://www.jbang.dev/documentation/guide/latest/installation.html
  curl -Ls https://sh.jbang.dev | bash -s - app setup
  # NB: ~/.jbang/bin must be added to PATH for this to work. That script does that for Bash;
  # for Fish, we're doing this in dotfiles/fish/config.fish;
  # see https://github.com/jbangdev/jbang/issues/2189.
fi

# ===============================================================================================================================
# Here come the tools minimally required tools that we *DO* want to install in all Codespaces
# (Some of the above, and other tools, could still be installed via prebuilt Dev Container on a per-project basis.)

# https://github.com/PatrickF1/fzf.fish
# TODO https://github.com/PatrickF1/fzf.fish/discussions/111 how to TMUX?
# TODO https://github.com/PatrickF1/fzf.fish/discussions/112 how to hide . files/dirs?
# TODO [ -s $HOME/.config/fish/functions/__fzf* ] || ...
[ -s "$HOME"/.config/fish/conf.d/fzf.fish ] || fish -c "fisher install PatrickF1/fzf.fish"

# https://github.com/jorgebucaran/autopair.fish
[ -s "$HOME"/.config/fish/conf.d/autopair.fish ] || fish -c "fisher install jorgebucaran/autopair.fish"

# https://github.com/Gazorby/fish-abbreviation-tips
[ -s "$HOME"/.config/fish/conf.d/abbr_tips.fish ] || fish -c "fisher install gazorby/fish-abbreviation-tips"

# https://github.com/nickeb96/puffer-fish for ... to ../.. and !! to inline previous command and !$ prev. arg
[ -s "$HOME"/.config/fish/conf.d/puffer_fish_key_bindings.fish ] || fish -c "fisher install nickeb96/puffer-fish"

fish -c "fisher update"

# PS: ADD ALL fisher generated fish functions to .gitignore instead of committing them!

# To install Python related stuff, use project-specific virtual environments;
# see my https://github.com/vorburger/Notes/blob/master/Reference/python.md,
# and note dotfiles/fish/functions/venv.fish
