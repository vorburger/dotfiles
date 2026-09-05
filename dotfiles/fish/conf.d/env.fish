# https://fishshell.com/docs/current/cmds/set.html
# documents the different between -Ux (universal + ENV) and -gx (global + ENV);
# use U for stuff you will "never" change and g for things you may temporarily change.

# NB: PATH is set in 00-PATH.fish

set DOTFILES (dirname (realpath (status --current-filename)))/../../..

if test ! -n "$JAVA_HOME"
   and test -d /etc/alternatives/java_sdk/
        set -gx JAVA_HOME (realpath /etc/alternatives/java_sdk/)
        # See https://github.com/bazelbuild/bazel/issues/26449 re. realpath
end

# see docs/podman.md
# (This must come before the below so that this works in-container.)
if test -f /usr/bin/podman-remote
    set -gx CONTAINER_HOST unix://run/user/1000/podman/podman.sock
end

# https://buildpacks.io/docs/app-developer-guide/building-on-podman/
if test -f /usr/bin/podman
    set -gx DOCKER_HOST unix://(podman info -f "{{.Host.RemoteSocket.Path}}")
end

# https://github.com/junegunn/fzf#respecting-gitignore
# This makes FZF use ripgrep, which filters .gitignore, etc.
set -gx RIPGREP_CONFIG_PATH $DOTFILES/dotfiles/ripgreprc.properties
set -gx FZF_DEFAULT_COMMAND "rg --files"
# This makes Ctrl-T FZF's Fish integration use the above
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND \$dir"

# Set ANDROID_HOME, see
# https://developer.android.com/tools/variables#android_home;
# but only if it's not already set, and if we're not in a Codespace,
# where a Dev Container Feature will set it to something else,
# and only if its path actually exists.
if test ! -n "$ANDROID_HOME"
    and test ! -n "$CODESPACES"
    and test -d /home/vorburger/Android
        set -gx ANDROID_HOME /home/vorburger/Android
end

if test -n "$ANDROID_HOME"
    and not test -d "$ANDROID_HOME"
        set -e ANDROID_HOME
end

# https://github.com/sharkdp/bat#man
# NOT https://github.com/eth-p/bat-extras/blob/master/doc/batman.md
# For alternatives, see https://wiki.archlinux.org/title/Color_output_in_console#man
if command -q bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT -c
else if command -q batcat
    set -gx MANPAGER "sh -c 'col -bx | batcat -l man -p'"
    set -gx MANROFFOPT -c
end
