#!/usr/bin/env bash
# Script to show a tmux window list in a popup and switch to the selected one.

# tmux display-popup runs commands via non-interactive /bin/sh -> bash, which
# does not source interactive shell PATHs (Fish's 00-PATH.fish or ~/.fzf.bash).
# Ensure user-local fzf / Nix binaries are in PATH so fzf doesn't fail and
# immediately close the `display-popup -E` window.
export PATH="$HOME/.nix-profile/bin:$HOME/.fzf/bin:$HOME/.local/bin:$PATH"

# The format includes the index, name, current path, command, and title.
# We use #{window_index} because tmux format strings expect single #.
# We use tab characters (\t) as delimiters so we can align columns nicely.
FORMAT="#{window_index}: #{window_name}	[#{b:pane_current_path}]	(#{pane_current_command})	\"#{pane_title}\""

# list-windows (without -a) lists windows in the current session.
# We pipe the output to column -t to create an aligned table,
# and then use fzf to let the user select one.
# fzf is used for fuzzy searching.
selected=$(tmux list-windows -F "$FORMAT" | column -t -s $'\t' | fzf --reverse --header 'Jump to window' --pointer '▶')

if [ -n "$selected" ]; then
    # Extract the window index (before the first colon)
    index=$(echo "$selected" | cut -d: -f1)
    # Switch to the selected window index in the current session
    tmux select-window -t "$index"
fi
