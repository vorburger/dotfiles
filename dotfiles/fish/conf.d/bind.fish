status is-interactive || exit

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
