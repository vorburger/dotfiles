status is-interactive || exit

if type -q code && test -z "$SSH_CONNECTION"; or string match -q "$TERM_PROGRAM" "vscode"
    set -gx EDITOR "code --wait"
    alias e="code "
else
    alias e="nano "
    set -gx EDITOR nano
end

alias cpc="wl-copy <"
# alias d="cd "
alias d="nano "
alias n="nix "
alias m="mvn "
alias p="pnpm "
alias r="./gradlew "
alias gt="gradle test"
alias gti="gradle integrationTest"
alias k="kubecolor "
alias jb="jbang "
alias 'j!'="jbang "
alias b="frogmouth"
alias bz="bazelisk "
alias bazel="bazelisk "
# This ^^^ is required just because completions/bazel.fish uses bazel not bazelisk.

# AI
alias a="gemini"

# Enola
# alias enola=~/git/github.com/enola-dev/enola/bazel-bin/java/dev/enola/cli/enola
alias z="~/git/github.com/enola-dev/enola/bazel-bin/java/dev/enola/cli/enola ai"
alias zc="~/git/github.com/enola-dev/enola/bazel-bin/java/dev/enola/cli/enola ai --http-scheme --agents=https://raw.githubusercontent.com/enola-dev/git-commit-message-agent/refs/heads/main/git-commit-message.agent.yaml --in='Make it so!'"

# https://github.com/vorburger/dotfiles/blob/master/README.md#google-cloud-shell
alias cloud="gcloud cloud-shell ssh --ssh-flag=-A"

# Git
# Gemini! ;) alias g="git "
alias g="gemini"
alias gr="gemini --resume"
alias gp="gemini --yolo --prompt "
# alias gl="git ls"
alias gl="tig"
# alias gll="git ll"
alias gll="lazygit"
# alias glll="git lll"
alias glg="git lg"
alias gst="git status"
alias gd="git diff"
alias gdh="git diff HEAD"
alias ga="git add"
alias gc="git commit -m "
alias gca="git commit --amend"
alias gaca="git add . && git commit --amend --no-edit"
alias gacap="git add . && git commit --amend --no-edit && git push --force-with-lease vorburger"
alias gco="git checkout "
alias gcob="git checkout -b "
alias gpu="git push "
alias gpv="git push vorburger"
alias gpl="git pull "
alias gpf="git push --force-with-lease vorburger"
alias grm="git rebase main"
alias gsy="git pull --rebase && git push"
alias gsh="git show HEAD"
alias gss="git stash"
alias gsp="git stash pop"
# see fish/conf.d/git.fish (and ../bin/g*) for more Git tools

# Nix!
# NB: Just always use "t" instead of these...
#   alias nfc="nix-fast-build --flake .#checks.x86_64-linux"
#   alias nfcq="nix flake check --no-build"
#   alias nt="nix run .#test"
alias nr="nix run"
alias nl="nix log"
# nrp is in dotfiles/fish/functions/nix.fish
alias hm="home-manager"
alias hme="home-manager edit"
# alias hms="home-manager switch"
alias hms="nh home switch --diff always --ask"
# hmu is in bin/

command -sq lsd && alias l="lsd "
command -sq lsd && alias ll="lsd -l "
command -sq lsd && alias lt="lsd --tree "

not type -q l && alias l="ls --group-directories-first --classify --hyperlink"
not type -q ll && alias ll="ls -l --group-directories-first --classify --hyperlink"

# Note dotfiles/ripgreprc.properties!
# https://github.com/BurntSushi/ripgrep/issues/86
alias less="less -R -q"

complete --command b --wraps bazel
complete --command g --wraps git
complete --command kubecolor --wraps kubectl
complete --command k --wraps kubecolor
complete --command m --wraps mvn

# see docs/podman.md
test -f /usr/bin/podman-remote && \
  complete --command podman --wraps podman-remote && \
  complete --command docker --wraps podman-remote
