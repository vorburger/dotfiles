set DOTFILES (dirname (realpath (status --current-filename)))/../../..

# https://bun.sh
set -gx BUN_INSTALL "$HOME/.bun"

command -q go && set _GOPATH (go env GOPATH)

fish_add_path $HOME/.nix-profile/bin $DOTFILES/bin $HOME/bin $HOME/.local/bin $_GOPATH/bin $HOME/.cargo/bin $HOME/.krew/bin $HOME/.npm/bin $BUN_INSTALL/bin
# NOT $PWD/node_modules/.bin, see https://github.com/vorburger/Notes/blob/master/Reference/javascript.md#pnpm
