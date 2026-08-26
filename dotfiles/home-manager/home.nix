{
  config,
  pkgs,
  lib,
  username ? "vorburger",
  homeDirectory ? "/home/${username}",
  ...
}:

{
  home = {
    inherit username homeDirectory;

    packages = with pkgs; [
      bat
      btop
      comma
      delta
      direnv
      file
      fish
      frogmouth
      fzf
      # gemini-cli evolves so fast, it's easier to update via NPM than Nix
      git
      glow
      google-cloud-sdk
      gws
      htop
      jq
      jujutsu
      lazygit
      lsd
      nh
      psmisc
      uv
      sops
      starship
      tig
      tmux
      trashy
      nil
      nixfmt
      nixd
      nixos-install-tools
      nixos-rebuild
      #nodejs_24
      #maven

      rpl
      ripgrep
      wipe

      (pkgs.writeShellScriptBin "force-suspend" ''
        ${pkgs.systemd}/bin/systemctl suspend -i
      '')

      # TODO Install UI packages, but how-to only if on a machine with GUI?
      # kitty
      wl-clipboard
      # wofi-emoji (?)

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    ];

    activation.activate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # On Fedora/generic Linux, Nix's openssh fails because it tries to read Fedora's
      # /etc/crypto-policies/back-ends/openssh.config which contains RedHat-specific patches.
      SSH_CMD=${if lib.pathExists "/etc/NIXOS" then "${pkgs.openssh}/bin/ssh" else "ssh"}
      GIT_CMD=${pkgs.git}/bin/git $DRY_RUN_CMD ${../../git-clone.sh}
      if [ -f "$HOME/git/github.com/vorburger/dotfiles/symlink.sh" ]; then
        $DRY_RUN_CMD "$HOME/git/github.com/vorburger/dotfiles/symlink.sh"
      else
        echo "Warning: symlink.sh not found, skipping..."
      fi

      # Automatically install tmux plugins via TPM if missing and online
      if [ ! -d "$HOME/.tmux/plugins/tmux-resurrect" ] && getent hosts github.com &>/dev/null; then
        if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        fi
        export PATH="${pkgs.tmux}/bin:${pkgs.git}/bin:${pkgs.gawk}/bin:${pkgs.gnused}/bin:${pkgs.gnugrep}/bin:$PATH"
        $DRY_RUN_CMD "$HOME/.tmux/plugins/tpm/bin/install_plugins"
      fi
    '';

    activation.gh-triage = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.gh}/bin/gh extension install k1LoW/gh-triage || true
    '';

    file = {
      ".local/share/applications/force-suspend.desktop".text = ''
        [Desktop Entry]
        Name=Force Suspend
        Comment=Suspend the system ignoring inhibitors
        Exec=force-suspend
        Icon=system-suspend
        Type=Application
        Categories=System;Settings;
        Terminal=false
      '';

      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/vorburger/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      EDITOR = "nano";
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.05"; # Please read the comment before changing.
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global = {
      warn_timeout = "30s";
      hide_env_diff = true;
    };
    silent = true;
  };
  programs.autojump.enable = true;
  programs.fish.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableFishIntegration = true;
  programs.gh.enable = true;
  programs.home-manager.enable = true; # Lets Home Manager install and manage itself.
  programs.nix-index.enable = true;

  xdg.enable = true;
  targets.genericLinux.enable = !lib.pathExists "/etc/NIXOS";

  systemd.user.services.gh-triage = {
    Unit = {
      Description = "Run gh triage";
      Documentation = "https://github.com/k1LoW/gh-triage";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.gh}/bin/gh triage";
    };
  };

  systemd.user.timers.gh-triage = {
    Unit = {
      Description = "Run gh triage hourly";
    };
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
