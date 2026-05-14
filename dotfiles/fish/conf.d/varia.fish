set DOTFILES (dirname (realpath (status --current-filename)))/../../..

command -q go && set _GOPATH (go env GOPATH)
fish_add_path $HOME/.nix-profile/bin $DOTFILES/bin $HOME/bin $HOME/.local/bin $_GOPATH/bin $HOME/.cargo/bin $HOME/.krew/bin $HOME/.npm/bin
# NOT $PWD/node_modules/.bin, see https://github.com/vorburger/Notes/blob/master/Reference/javascript.md#pnpm

command -q starship && starship init fish | source

# https://github.com/sharkdp/bat#man
# NOT https://github.com/eth-p/bat-extras/blob/master/doc/batman.md
# For alternatives, see https://wiki.archlinux.org/title/Color_output_in_console#man
test -f /usr/bin/bat && set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'" && set -gx MANROFFOPT -c
test -f /usr/bin/batcat && set -gx MANPAGER "sh -c 'col -bx | batcat -l man -p'" && set -gx MANROFFOPT -c

# Keyboard bindings
# fish_key_reader is great to find the appropriate keyboard escape sequence! See
# https://fishshell.com/docs/current/cmds/bind.html#special-input-functions, also
# https://fishshell.com/docs/current/#escaping-characters is useful; note
# "bind" shows all current bindings, and eg. "bind \cP" shows Ctrl-P's.

# Use word instead of backward-kill-path-component to match .inputrc
bind \b backward-kill-word
# Kitty Ctrl-Backspace (with modern keyboard protocol)
if test (string split . $FISH_VERSION)[1] -ge 4
    bind ctrl-backspace backward-kill-word
else
    bind "\e[127;5u" backward-kill-word
end

# Ctrl-P for FZF, same as default Ctrl-T - for consistency with VSC
bind \cp fzf-file-widget

# https://bun.sh
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
