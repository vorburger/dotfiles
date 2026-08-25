# Vorburger.ch's Dotfiles

## Installation

    mkdir -p ~/git/github.com/vorburger/
    cd ~/git/github.com/vorburger/
    git clone git@github.com:vorburger/dotfiles
    cd dotfiles

### NixOS

Use my [`nixfiles`](https://github.com/vorburger/nixfiles).

That uses this repo for user settings.

### Nix

For using the [Nix](https://nixos.org) package manager with these dotfiles on non-NixOS (above):

1. [Install the `nix` CLI](https://github.com/vorburger/LearningLinux/blob/develop/nix/docs/install.md)
1. Run `./nix-install.sh`

Without cloning, you can also just directly: `nix --extra-experimental-features "nix-command flakes" run nixpkgs#home-manager -- switch --flake github:vorburger/dotfiles?dir=dotfiles/home-manager`.

Now add packages etc. to [`home.nix`](dotfiles/home-manager/home.nix) with `hme`, then run [`hms`](dotfiles/fish/conf.d/alias.fish) to activate them. Use [`hmu`](bin/hmu) to upgrade Nix packages.

See [`home-manager`](dotfiles/home-manager) for more background.

### ArchLinux

    ./git-clone.sh
    ./pacman-install.sh
    ./pacman-install-gui.sh
    ./symlink.sh
    ./authorized_keys.sh

### ChromeOS

Set up these dotfiles (in a container) on a server, like below. Then just SSH into it,
using a [YubiKey with Secure Shell ChromeOS](https://chromium.googlesource.com/apps/libapps/+/HEAD/nassh/docs/hardware-keys.md).
Using locally in ChromeOS's Debian Linux on ARM arch hasn't been tested.

### Visual Studio Code

The Visual Studio Code (VSC) "Client" UI is installed by `dnf-install-gui.sh` (or manually from https://code.visualstudio.com).

Press _Ctrl-Shift-P_ to [Enable _Settings Sync_](https://code.visualstudio.com/docs/editor/settings-sync) (also [GitHub](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#settings-sync)) (and, if prompted, choose _[Merge](https://code.visualstudio.com/docs/editor/settings-sync#_merge-or-replace)_). (Use [Settings Sync: Show Synced Data](https://code.visualstudio.com/docs/editor/settings-sync#_restoring-data) to view Synced Machines etc.)

Each time after installing additional extensions, run [`bin/code-extensions-export.sh`](bin/code-extensions-export.sh) to export to [`extensions.txt`](dotfiles/code/extensions.txt).

If extensions somehow get lost, then run [`bin/code-extensions-install.sh`](bin/code-extensions-install.sh)

_TODO:_ `vsc --uninstall-extension` those that are not listed in `extensions.txt`.

#### VSC CLI Tunnel Service

The [VSC Server's](https://code.visualstudio.com/docs/remote/vscode-server) Tunnel is installed as a Service by [`code-install-cli-tunnel-service.sh`](code-install-cli-tunnel-service.sh).

### GitHub Codespaces

Enable _Settings Sync_ as described above.

Enable _Automatically install dotfiles_ from this repository in [your GitHub Settings](https://github.com/settings/codespaces).

To fix _Error loading webview: Error: Could not register service workers: NotSupportedError: Failed to register a ServiceWorker for scope ('...'): The user denied permission to use Service Worker_, [allow third-party cookies](https://stackoverflow.com/q/72498891/421602); e.g. on Chrome, add `[*.]github.dev` _Including third-party cookies_ on chrome://settings/cookies.

[Your GitHub Codespaces](https://github.com/codespaces) (only future, not existing) will be initialized by [bootstrap.sh](bootstrap.sh), as per [this list of file names](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles).

Check if it is still running with `tail -f /workspaces/.codespaces/.persistedshare/creation.log`. If NOK, or to update:

    cd /workspaces/.codespaces/.persistedshare/dotfiles/
    ./bootstrap.sh
    fish
    cd /workspaces/...

`git push` in `/workspaces/.codespaces/.persistedshare/dotfiles/` won't succeed while working in another repo; one way to still be able to push changes to dotfiles in this case is to [create a short-lived temporary personal access token](https://github.com/settings/tokens) **with Scope incl. Repo** and do `GITHUB_TOKEN=ghp_... git push`. [Here are other useful troubleshooting infos](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-dotfiles-for-codespaces). Testing during development is simplest by creating a codespace for this repo, and manually invoking `./bootstrap.sh`. ([My personal notes](https://github.com/vorburger/Notes/blob/master/Reference/github-codespaces.md) have some remaining TODOs.)

The `CODESPACES` [environment variable](https://docs.github.com/en/codespaces/developing-in-codespaces/default-environment-variables-for-your-codespace#list-of-default-environment-variables) should be used to skip anything long running that's not required in code spaces, e.g. the `nano` build.

### Fedora [Silverblue](https://silverblue.fedoraproject.org) & [CoreOS](https://github.com/vorburger/vorburger.ch-Notes/tree/develop/linux/coreos)

    mkdir ~/git/github.com/vorburger && cd ~/git/github.com/vorburger/
    git clone git@github.com:vorburger/dotfiles && cd dotfiles

    ./gnome-settings.sh
    ./ostree-install-gui.sh
    systemctl reboot
    rpm-ostree status

[My notes about Silverblue](https://github.com/vorburger/vorburger.ch-Notes/blob/develop/linux/silverblue.md) have debugging tips for _OSTree._

If the Silverblue workstation is intended to (also) be used as a server, remember _Settings > Power > Power Mode > Power Saving Options > Automatic Suspend._

Until the Toolbox Container works, use [the Fedora-based Container](#fedora-based-container-with-ssh) (see below). Copy [`kitty.conf`](dotfiles/kitty.conf) to `~/.config/kitty/kitty.conf`, and change `shell /home/vorburger/git/github.com/vorburger/dotfiles/container/ssh.sh /home/vorburger/dev/dotfiles/bin/tmux-ssh new -A -s MAKE`.

#### Toolbox Container (NEW)

    ./containers/build
    toolbox create --image gcr.io/vorburger/dotfiles-fedora:latest

    toolbox enter dotfiles-fedora-latest

#### Toolbox Container (OLD)

The [Toolbox](https://github.com/containers/toolbox)-based container doesn't actually quite work very nicely just yet... :-(

    ./toolbox.sh
    mux

These should later be more nicely integrated into the Toolbox container (not ~):

    ./symlink-toolbox.sh

Also, automatically start Toolbox in Fish instead of Bash...
and `./gnome-settings.sh` autostart Terminal Session TMUX, with Toolbox.
And run `~/.install-nano.sh` during `Dockerfile-toolbox`.

### Fedora Workstation

Unless you already have GitHub auth working, we may have a "chicken and egg" problem with [the YubiKey configuration](docs/yubikey.md), so it's simplest to start with an anon clone:

    mkdir -p ~/git/github.com/vorburger/
    cd ~/git/github.com/vorburger/
    git clone https://github.com/vorburger/dotfiles.git
    cd dotfiles

    sudo cp container/sshd/01-local.conf /etc/ssh/sshd_config.d/

    ./dnf-install-gui.sh
    ./authorized_keys.sh

If it all works, you can now open _Kitty_ (not _GNOME Terminal)_, [test the YubiKey](docs/yubikey.md), and then change the remote:

    git remote set-url origin git@github.com:vorburger/dotfiles

#### UHK

    ./etc.sh

Install _latest_ https://github.com/UltimateHackingKeyboard/agent/releases/,
and fix up path in [`UHK.desktop`](dotfiles/desktop/UHK.desktop).  Upgrade Firmware.
Remember to Export device configuration to [`keyboard/uhk/`](keyboard/uhk/UserConfiguration.json).

### Debian / Ubuntu Servers

    mkdir -p ~/git/github.com/vorburger/
    cd ~/git/github.com/vorburger/
    git clone git@github.com:vorburger/dotfiles
    cd dotfiles

    ./git-clone.sh
    ./debian-install.sh # or ./ubuntu-install.sh
    ./symlink.sh
    ./setup.sh
    ./authorized_keys.sh

### Fedora-based Container (with SSH)

This container includes SSH, based on [container/devshell](container/devshell),
so that one can login with an agent instead of keeping private keys in the container.

#### Production

It's better to run the container with _rootless_ Podman under a UID that doesn't have sudo root powers, so:

    sudo useradd dotfiles
    sudo -iu dotfiles
    loginctl enable-linger dotfiles
    # The following fixes "Failed to connect to bus: No medium found"
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    systemctl enable --now --user podman.socket
    systemctl --user status

Now put the [`systemd` Unit File](systemd/) into `~/.config/systemd/user/` and then run:
(Use simple copy/paste, or e.g. via `ln -rs systemd/dotfiles-fedora.service ~/.config/systemd/user/`.
 This pulls the container from `gcr.io/vorburger/dotfiles-fedora`!)

    systemctl --user enable dotfiles-fedora
    systemctl --user start  dotfiles-fedora
    systemctl --user status dotfiles-fedora
    journalctl --user -u dotfiles-fedora
    systemctl --user status

You can now SSH login on port 2222 similarly to how [`ssh.sh`](container/ssh.sh) does.
It's convenient to configure a terminal (Kitty or GNOME Terminal or whatever) to call
`ssh.sh /home/vorburger/dev/dotfiles/bin/tmux-ssh new -A -s MAKE`.

Restart the dotfiles container for user dotfiles from another user like this:

    sudo -u dotfiles XDG_RUNTIME_DIR=/run/user/$(id -u dotfiles) systemctl --user restart dotfiles-fedora

Remember that if making changes to systemd `*.service` files, while working as user dotfiles, you have to:

    systemctl --user daemon-reload
    systemctl --user restart dotfiles-fedora

Further information about all this is available e.g. on my CoreOS Notes about
[Containers with systemd](https://github.com/vorburger/vorburger.ch-Notes/blob/develop/linux/coreos/README.md#containers) and
[Additional Users](https://github.com/vorburger/vorburger.ch-Notes/blob/develop/linux/coreos/README.md#personal-user)
(both sections aren't really CoreOS specific).

#### Local Dev

    ./container/build.sh

We can it without actually using SSH, which useful for quick iterating during local development:

    podman run -it --rm gcr.io/vorburger/dotfiles-fedora:latest bash -c "su - --shell=/usr/bin/fish vorburger"

To run it (using the systemd user unit set up above) and SSH into it:

    ./container/run.sh
    ./container/ssh.sh

Once the container runs, you can also exec into it:

    podman exec -it dotfiles bash -c "su - vorburger && fish"

We can now work on this project in that container, like so:

    sudo chown vorburger:vorburger git/
    cd git
    git clone git@github.com:vorburger/dotfiles.git
    cd dotfiles

    sudo chown vorburger:vorburger /run/user/1000/podman/podman.sock
    ./container/build.sh
    exit
    ./container/run.sh
    ./container/ssh.sh

NB that this will modify the ownership of `/run/user/1000/podman/podman.sock` on the host filesystem,
not only in the container. As long as we don't need to use `podman-remote` on the host, that shouldn't cause problems.

#### Google Cloud COS VM with this container (SSH from outside into container)

[Set up a Cloud Build](cloudbuild.yaml), and then:

```
gcloud compute instances create-with-container dotfiles-fedora --project=vorburger --zone=europe-west6-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --maintenance-policy=MIGRATE --service-account=646827272154-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=projects/cos-cloud/global/images/cos-stable-93-16623-39-30 --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=dotfiles-fedora2 --container-image=gcr.io/vorburger/dotfiles-fedora --container-restart-policy=always --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=container-vm=cos-stable-93-16623-39-30
```

_TODO `gcloud beta compute disks create home --project=vorburger --type=pd-ssd --size=10GB --zone=europe-west6-a`,
and then mount that into the container (above) - and switch to **`symlink-homefree.sh`** that doesn't use $HOME in container._

To login to the dotfiles container:

    ssh-add -L # MUST show local key/s, NOT "The agent has no identities"
    ssh -p 2222 -A vorburger@1.2.3.4

To enable SSH login to the host, not container, typically only required to check the container:

    gcloud --project=vorburger compute project-info add-metadata --metadata enable-oslogin=TRUE
    gcloud --project=vorburger compute os-login ssh-keys add --key-file=/home/vorburger/.ssh/id_ecdsa_sk.pub
    ssh michael_vorburger@1.2.3.4

### Google Cloud Workstations

    ./google-cloud-workstation-install.sh

TODO: Set up CI to [pre-build](https://cloud.google.com/workstations/docs/customize-container-images) the [`Dockerfile-google-cloud-workstation`](Dockerfile-google-cloud-workstation).

### Google Cloud Shell

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_image=gcr.io/vorburger/dotfiles)

_TODO [See this (pending) question on StackOverflow](https://stackoverflow.com/questions/70612890/non-ephemeral-google-cloud-shell-with-custom-container-image) about Google Cloud Shell Custom Images always launched ephemeral; which makes it a No-Go for this project. (Simply running a dotfile devshell container on a GCE VM is much easier)._

https://shell.cloud.google.com, see https://cloud.google.com/shell, is handy (but limited to a `du -h ~` 5 GB `$HOME`..), especially with the web-based [Google Cloud Code](https://cloud.google.com/code), based on [Eclipse Theia](https://theia-ide.org) (also available on [Gitpod](https://www.gitpod.io)). To be able to connect to other servers from Google Cloud Shell, notably GitHub, login to it from a local Terminal like this (or use [SSH Web](#ssh-web)):

    gcloud cloud-shell ssh --ssh-flag="-A"

Alternatively, you COULD `ssh-keygen` and have something like the following in your `~/.ssh/config`, as per [this](https://github.com/aubort/google-cloud-shell-tutorial) or [this](https://vincentteo.com/2018/01/07/private-github-repos-google-cloud-shell/) guide, but security wise it's much better to keep your private SSH key e.g. a HSM YubiKey in your desktop/laptop, than having it on the cloud, so better don't this but use the approach above instead:

    Host github.com
        Hostname github.com
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/id_rsa

_TODO [See this (pending) question on StackOverflow](https://stackoverflow.com/questions/70612636/google-cloud-shell-ssh-with-customer-container-image) re. how to SSH login to Google Cloud Shell using a customer container image._

_TODO [See this (pending) question on StackOverflow](https://stackoverflow.com/questions/70608840/how-to-ssh-login-to-google-cloud-shell-using-an-existing-private-key-on-a-yubike) re. how to SSH login to Google Cloud Shell using an existing private key on a YubiKey security key._

To use the many configurations from this repo in Google Cloud Shell, simply use the big blue _"Open in Google Cloud Shell"_ above. This is [based on a customized image](https://cloud.google.com/shell/docs/customizing-container-image) available on [gcr.io/vorburger](https://gcr.io/vorburger). Here is how to "locally" build it for improvements to it:

    cd ~/git/github.com/vorburger/dotfiles/
    cloudshell env build-local
    cloudshell env run

Watch out for `Connection to localhost closed.` after `env run` - it means that the container
cannot be SSH into, just like when "gcr.io/cloudshell-image/custom-image-validation" failed on a build,
e.g. due to a newer TMUX having been installed, or e.g. an infinite loop by
`/etc/inputrc` doing an `$include /etc/inputrc` by `symlink-homefree.sh`.

## Use

### Versions

We use <https://asdf-vm.com> (with `.tool-versions`) to handle different Java versions and such; e.g. to test something with an ancient Java version:

    asdf plugin-add java
    asdf install java zulu-6.22.0.3
    asdf shell java zulu-6.22.0.3
    java -version
    asdf uninstall java zulu-6.22.0.3
    asdf plugin-remove java

To switch a project (directory) to a fixed version, and create the `.tool-versions` (which ASDF's Shell integration uses), do:

    asdf local java zulu-6.22.0.3

<https://sdkman.io> with `.sdkmanrc` (and _[sdkman-for-fish](https://github.com/reitzig/sdkman-for-fish))_ is similar,
but it has [less "SDKs"](https://sdkman.io/sdks) than `asdf` [has plugins](https://github.com/asdf-vm/asdf-plugins?tab=readme-ov-file#plugin-list), which are also visible with `asdf plugin-list-all`.

<https://www.jenv.be> with `.java-version` is another (older) one like these, but it manages JDK and `JAVA_HOME`, only.

## Security

### SSH Web

Browser-based [Secure Shell App](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?hl=en), based on https://hterm.org.

Connection Dialog SSH Arguments e.g. `-At -- /usr/bin/fish` or `-At -- /usr/bin/fish -c "~/bin/tmux3 new -A -s Cloud"`.

It's important to use absolute paths to the shell, because `ssh` won't read `PATH`.

### SSH for multiple GitHub accounts

    git config core.sshCommand "ssh -i ~/.ssh/id_ecdsa_sk"

possibly with `[includeIf "gitdir:~/work/"]` in `~/.gitconfig`, as per https://dev.to/arnellebalane/setting-up-multiple-github-accounts-the-nicer-way-1m5m.

### `ssh` 101

    sudo dnf install -y pwgen diceware ; pip install xkcdpass
    # Generate a password/passphrase
    pwgen -s -y 239 1
    diceware -n 24 -d " " --no-caps
    xkcdpass -n 24

    ssh-keygen -t ed25519 -C $(id -un)@$(hostname)
    cat ~/.ssh/id_ed25519.pub

Copy/paste `~/.ssh/id_ed25519.pub` into https://github.com/settings/keys.

Now `sudo dnf install seahorse` (GNOME's Passwords and Keys) and when prompted, tick the checkbox about "unlocking keyring when logging in".

    $ ssh git@github.com
    Enter passphrase for key '/home/vorburger/.ssh/id_ed25519':
    $ ssh git@github.com
    Enter passphrase for key '/home/vorburger/.ssh/id_ed25519':
    $ ssh-add -l
    Could not open a connection to your authentication agent.
    # Simply means that there is no SSH_AUTH_SOCK environment variable
    $ eval $(ssh-agent)
    Agent pid 1234
    $ echo $SSH_AUTH_SOCK
    /tmp/ssh-AqnT5yXiLt1X/agent.1234
    $ ssh-add -l
    The agent has no identities.
    $ ssh-add .ssh/id_ed25519
    Enter passphrase for .ssh/id_ed25519:
    $ ssh-add -l
    256 SHA256: ...
    $ ssh git@github.com
    # does not ask for passphrase anymore!

With how we'll set it up using a YubiKey and `gpgconf` (and Fish's [`SSH_AUTH_SOCK.fish`](dotfiles/fish/conf.d/SSH_AUTH_SOCK.fish)) in the next section we do not need to manually run `eval (ssh-agent)`.

### `ssh` (incl. `git`) Agent incl. Forwarding with YubiKey

As e.g. per https://github.com/drduh/YubiKey-Guide#replace-agents, we need to appropriately set
the `SSH_AUTH_SOCK` environment variable.  You could be tempted to do something like the following:

    echo "set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)" > ~/.config/fish/conf.d/SSH_AUTH_SOCK.fish

Doing this on a sever is not required, but doing this on a workstation prevents remote SSH login to the workstation.
Instead, the [`bin/tmux*`](bin/) scripts very nicely automate and correctly integrate this with TMUX:

    [you@desktop ~]$ tmux-local new -A -X -s MAKEx

    [you@laptop ~]$ ssh -At desktop -- tmux-ssh new -A -X -s MAKEx

You probably want to put the desktop command into a launch command for your Terminal,
and alias the laptop command in `~/.config/fish/conf.d/alias.fish`.

Remember to always use `ssh -A` to enable Agent Forwarding, as above.
We could alternatively use `ForwardAgent yes` in our `~/.ssh/config`, but as a security best practice,
always _only for a SINGLE Hostname__, never for all servers.

BTW: `RemoteForward` in `~/.ssh/config` is not actually required (at least with Fedora 30).

### `gpg` Agent Forwarding

See https://wiki.gnupg.org/AgentForwarding and related personal Notes.

## Manual Settings

### Fonts

TL;DR Ligatures in the Terminal and Editor and symbols in directory listings "just work"!

We (apparently...) need **BOTH** the (original)
[DNF `fira-code-fonts` package](https://github.com/tonsky/FiraCode/wiki/Linux-instructions#fedora)
(which is what makes Ligatures e.g. in the Kitty Terminal and Visual Studio code work)
*as well* as the (patched!) _[Fira Code (Nerd)](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)_
(which is what makes the fancy symbols used by `lsd` work).

This (monospaced) font is configured to be used in [`kitty.conf`](dotfiles/kitty/kitty.conf) and
[in VSC](dotfiles/code/settings.json). The _Fira Mono_ font, which isn't part of the
`fira-code-fonts` DNF package but comes with Fedora, is NOT actually used, here.

[`fonts-install.sh`](fonts-install.sh), called by [`dnf-install-gui.sh`](dnf-install-gui.sh)
scripts the installation of the the `ryanoasis/nerd-fonts` _FiraCode_ and [`dnf-install-gui.sh`](dnf-install.sh)
does `dnf install fira-code-fonts`.

### Dark Mode

Open `chrome://flags` and search for _"dark"_ and enable it.

### Terminals

From https://github.com/tonsky/FiraCode#terminal-support :

* [Kitty](https://sw.kovidgoyal.net/kitty) (at [kovidgoyal/kitty](https://github.com/kovidgoyal/kitty) on GitHub) is nicely minimalistic, no Settings UI.  It duplicates `tmux`, but never mind.  Very actively maintained, Fedora package à jour.
* [Hyper](https://hyper.is) looks interesting too, but more "bloated". Has RPM, but not Fedora packaged. [Font ligatures don't work in v3](https://github.com/vercel/hyper/issues/3607).
* [QTerminal](https://github.com/lxqt/qterminal) does not list `Fira Code` in File > Settings > Font, so nope.
* [Konsole](https://konsole.kde.org) drags KDE along, so no thanks.

https://github.com/topics/terminal-emulators has moar... ;-)

### Eclipse

Preferences > General > Appearance > Colors and Fonts: Basic Text Font = Fira Code 12.

### GNOME

    ./gnome-settings.sh

### Wakatime

`cp dofiles/wakatime.cfg ~/.wakatime.cfg` and edit it to replace [the placeholder `api_key`](dotfiles/wakatime.cfg) with the real one from https://wakatime.com/settings/account, and then verify heartbeat on https://wakatime.com/plugins/status after a few minutes.

_TODO_

1. Fix `api_key_vault_cmd`, see https://github.com/wakatime/vscode-wakatime/issues/374
1. Fix `api_key` in `import_cfg`, see https://github.com/wakatime/vscode-wakatime/issues/375. (When it works, then instead of above copy https://wakatime.com/settings/account into a `$HOME/.wakatime/wakatime_secret.cfg` imported in [`~/.wakatime.cfg`](dotfiles/wakatime.cfg) which contains `[settings]\napi_key = waka_...`)
1. [Remote VSC Support?](https://github.com/wakatime/wakatime-cli/blob/develop/TROUBLESHOOTING.md#ssh-configuration)

#### On Fedora Silverblue

1. Install [Brave Flatpack from FlatHub](https://flathub.org/apps/details/com.brave.Browser) (but [YK SK won't work](https://github.com/flathub/com.brave.Browser/issues/126)):

       flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
       flatpak install flathub com.brave.Browser

1. Install [Minecraft Flatpack from Flathub](https://flathub.org/apps/details/com.mojang.Minecraft)

1. In _Gnome Terminal's Preferences_, add a new Profile as below,
   BUT name it `toolbox` and as Command, use:
   `sh -c 'echo "Type mux..." && toolbox enter vorburger-toolbox'`

#### On Fedora Workstation

Launch `gnome-tweaks` and configure:

* _Appearance > Themes > **Legacy** Applications_ switch to _Adwaita-**dark**_ mode for night mode
* _Startup Applications_, `+` _Kitty_ and _Chrome/Firefox_.
  This puts (copies of, not symlinks to) `firefox.desktop` and `kitty.desktop` into `~/.config/autostart/`.
* Windows Focus on Hover

In _Gnome Terminal's Preferences_, add a new `tmux` Profile, and _Set as default_, with:

* Text _Custom Font_ `Fira Code Retina` Size 20. NB: [Fira Code's README](https://github.com/tonsky/FiraCode#terminal-support) lists GNOME Terminal as not supported, and the fancy Ligatures indeed don't work (like they do e.g. in Eclipse after changing the ), but I'm not actually seeing any real problems such as [issue #162](https://github.com/tonsky/FiraCode/issues/162), so it, just for consistency. (The alternative would be to just use `Fira Mono` from `mozilla-fira-mono-fonts` instead.)
* Scrolling disable _Show scrollbar_ and _Scroll on output_, but enable _Scroll on keystroke_, and _Limit scrollback to: 10'000 lines_
* Command: Replace initial title, Run a custom command instead of my shell: `mux`

Settings > Mouse & Touchpad : Touchpad > Natural Scrolling enabled  &&  Tap to Click.

Settings > Keyboard Shortcuts: Delete (Backspace) Alt-ESC to Switch Windows Directly
(because we use that in TMUX).

### Power Saving

See [power](docs/power.md) and [suspend](docs/suspend.md) docs.

**TODO** Test if the additional governors (conservative userspace powersave ondemand performance schedutil)
which should appear after _booting with the kernel parameter `intel_pstate=disable`_ help with increased battery life..

## Containers

### _"Podman-in-Podman"_

see [doc](docs/podman.md)

### Debian

    clear; time docker build -t vorburger-debian -f Dockerfile-debian . && docker run -it --hostname=debian --rm vorburger-debian

The `Dockerfile-debian-minimal` is used instead of `Dockerfile-debian` to rebuild faster with less for quick local iterative development.

### Toolbox

See the Silverblue section above for usage with Toolbox.

### Google Cloud Shell

See above for usage as a https://cloud.google.com/shell/docs/customizing-container-image.

To local build test, try: `time docker build -t vorburger-google-cloudshell -f Dockerfile .` but it fails with:
`Error: error creating build container: writing blob: adding layer with blob "sha256:73b906f329a9204f69c7efa86428158811067503ffa65431ca008c8015ce7871": Error processing tar file(exit status 1): potentially insufficient UIDs or GIDs available in user namespace (requested 150328:89939 for /tinkey.bat): Check /etc/subuid and /etc/subgid: lchown /tinkey.bat: invalid argument`

### Vorburger's _DeCe_ Cloudshell

Using https://github.com/vorburger/cloudshell for a customized web shell on http://localhost:8080 :

    docker build -t vorburger-cloud -f Dockerfile-dece-cloudshell .
    docker run --hostname=cloud -eUSER_ID=vorburger -eUSER_PWD=THEPWD --rm -p 8080:8080 vorburger-cloud
