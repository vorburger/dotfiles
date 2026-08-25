# These aliases are Fish specific
# Common ones are in dotfiles/alias (bash specific in dotfiles/bash.d/alias.bash)

status is-interactive || exit

# see also bash.d/alias.bash
if type -q code && test -z "$SSH_CONNECTION"; or string match -q "$TERM_PROGRAM" "vscode"
    set -gx EDITOR "code --wait"
    alias e="code "
else
    alias e="nano "
    set -gx EDITOR nano
end

command -sq lsd && alias l="lsd "
command -sq lsd && alias ll="lsd -l "
command -sq lsd && alias lt="lsd --tree "

not type -q l && alias l="ls --group-directories-first --classify --hyperlink"
not type -q ll && alias ll="ls -l --group-directories-first --classify --hyperlink"

# Note dotfiles/ripgreprc.properties!
# https://github.com/BurntSushi/ripgrep/issues/86
alias less="less -R -q"
command -sq rg &&
  function f -d "RipGrep (with Paging)"
    rg -p $argv | less -R -q
  end

complete --command b --wraps bazel
complete --command g --wraps git
complete --command kubecolor --wraps kubectl
complete --command k --wraps kubecolor
complete --command m --wraps mvn

# see docs/podman.md
test -f /usr/bin/podman-remote && \
  complete --command podman --wraps podman-remote && \
  complete --command docker --wraps podman-remote
