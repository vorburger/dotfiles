# ToDo

Remember to use _Ctrl-P_ (for fzf) and `f` (for rg=ripgrep; and _Ctrl-H_ in VSC) a lot! 😏

## Nix

Use AI to fix all this... Gemini, or Enola!

1. `$SSH_AUTH_SOCK`
1. `alias sh` to SSH home? But how to keep hostname secret - Age? SOPS?
1. `j` jump, what's missing? Anything more modern, in Fish?
1. Ctrl-P fails due to missing `fzf-file-widget` :(
1. `gemini` (with an alias), when https://github.com/NixOS/nixpkgs/issues/442213 is fixed
1. `cd dotfiles/home-manager && nix fmt`
1. `nix fmt` (in root)
1. Auto-order packages during format

## NeXT

- Generate a `keybindings.md` during the build, from `alias` and `functions` (IFF ours... how-to?)

- https://github.com/ndonfris/fish-lsp ?

- Extend `./test.sh` to also run:
  - dnf-install.sh on a Fedora container
  - Debian
  - ...

- Unify ubuntu-install.sh and debian-install.sh, by reading `/etc/lsb-release`

- shellcheck pre-commit and GitHub action, fix all errors

- Replace the massive copy/paste in the Bash shell scripts with a library of Shell functions (at least, if not something better)

- https://sw.kovidgoyal.net/kitty/kittens/hints/

- [DNF v5](https://www.zdnet.com/google-amp/article/how-to-install-dnf5-on-fedora-39-for-faster-application-installation-and-management/)? Try in container!

- fix SSH_AUTH_SOCK "bug" in dotfiles
  - Remember how https://github.com/vorburger/dotfiles/commit/36771f62ac2c31e40cbc9d72ca58adef00c263db
     was reverted on 2023-01-07, see https://github.com/vorburger/dotfiles/commit/6bafbde1afd456fca5d32761f09142584058bb97
  - Cannot "ssh localhsot" in GNOME Terminal instead of in Kitty
     because `SSH_AUTH_SOCKET` was set to `/run/user/1000/keyring/ssh` instead of `/home/vorburger/.ssh.agent` ...
  - Retrace what set this where!
  - Move `SSH_AUTH_SOCKET` magic from `bin/tmux-local`, `bin/tmux3` and `tmux-ssh` to... some place "earlier".
  - This is also why VSC Remote localhost fails... does that work now?
  - Do the VSC Beancount Extensions for LLnP work remotely now? Probably not, just like they don't from the laptop. Open issues.
  - This might fix the git-server login? Not sure, could be unrelated.

- https://docs.deno.com/runtime/manual/getting_started/setup_your_environment#fish-example

- Container, take 2?
  - VSC Container support? Works via Tunnels?
  - https://gitlab.gnome.org/chergert/prompt Container-friendly Terminal, for Toolbox

- https://github.com/vorburger/dotfiles/compare/jenv
  - https://github.com/jenv/jenv/issues/152
  - https://github.com/jenv/jenv/pull/169/files
  - https://github.com/jenv/jenv/pull/290/files
  - https://github.com/jenv/jenv/issues/301


- Make the (new) `f` alias (based on ripgrep) show matches in FZF; and open an editor on Enter (via `e`, i.e. `code` or `nano`)
  - https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interactive-ripgrep-launcher
  - https://github.com/tomrijndorp/vscode-finditfaster
  - https://github.com/gazorby/fifc

- https://github.com/gazorby/fish-abbreviation-tips/issues/27

- clean up bin/, mv ARCHIVE or rm; many scripts are un-used

- https://wiki.archlinux.org/title/Color_output_in_console

- https://magefile.org?

- JUST USE IT, to find gaps
  - initally NOT as toolbox, because that reads $HOME, but as sshd, with the systemd unit; with a GNOME Terminal Profile!
  - later [`useradd dotfiles`](https://github.com/vorburger/dotfiles#fedora-based-container-with-ssh)
  - develop using `podman machine`, for best isolation?
  - LATER toolbox, perhaps try without mounting $HOME? Create a bug, for discussion.

- set -x LC_ALL en_US.UTF-8, set -x LANG en_US.UTF-8; check Arch Wiki?

- make it (even?) easier to "power cycle" the container (script, doc)
  Perhaps a systemd unit "outside" could watch for a flag/tag file in a mounted directory,
  which restarts the container? (This overlaps a bit with `toolbox` systemd integration.)

- volume for persistent sshd hostkeys, to avoid StrictHostKeyChecking=no

- container: fish history should be preserved, mount ~/.local/share/fish/fish_history; see
  https://fishshell.com/docs/current/cmds/history.html#customizing-the-name-of-the-history-file

- container: ~/.ssh/known_hosts should be pre-initialized with github.com's:
  `ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts`

- README clean-up

- container: https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html ?
  This is better than --pull=newer, because it's more explicit. Also, newer isn't actually _newer_ but _different,_ which is a PITA during local development.

- Kitty NOK: container/ssh.sh says, and likely because of this TMUX then doesn't work:
    warning: Could not set up terminal.
    warning: TERM environment variable set to 'xterm-kitty'.
    warning: Check that this terminal type is supported on this system.
    warning: Using fallback terminal type 'ansi'.

- https://krew.sigs.k8s.io/plugins/

# GCE

- https://github.com/vorburger/dotfiles/blob/master/README.md#google-cloud-cos-vm-with-this-container-ssh-from-outside-into-container
  with $HOME/git persistence on an additional disk attached to the GCE VM,
  similar to https://github.com/vorburger/dotfiles/blob/master/README.md#local-dev

- https://cloud.google.com/artifact-registry/docs/configure-cloud-build#docker

# LATER

- finish full Toolbox support; see README.md
- toolbox: How does toolbox give accesss to podman.socket without requiring the chown?! It's a PITA, and would be nice to avoid, in an ideal world.

- give talk about this? 1. Blog,  2. Friends,  3. at Work? ("My Home Lab Data Center can be yours too!")
- ./container/build.sh must not depend on user presence SK touch to build,
  and uncomment test in container/build.sh, and unify or remove root ./test script.

- container clean-up: make container not use ~/git but store its files somewhere on / instead of anywhere in $HOME
- container: clone dotfiles to ~/git/ instead of ~/dev/ (but.. how? shouldn't git clone, because need local changes; must copy with .git)

- https://github.com/franciscolourenco/done

- https://github.com/meaningful-ooo/sponge

- clean up any remaining TODO (`findx TODO`)

- https://github.com/vorburger/Notes/blob/master/ToDo/shell-todo.txt

- https://github.com/vorburger/Notes/blob/master/ToDo/cloudshell-todo.md

- devshell: sl, fortune and cowsay + lolcat
  maybe every ... 13th ;) login?
  https://www.digitalocean.com/community/tutorials/top-10-linux-easter-eggs
  https://github.com/busyloop/lolcat
  https://opensource.com/article/18/12/linux-toy-lolcat
  https://www.tecmint.com/lolcat-command-to-output-rainbow-of-colors-in-linux-terminal/
