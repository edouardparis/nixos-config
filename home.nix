{
pkgs,
...
}: {
  home.stateVersion = "23.05";
  home.username = "edouard";
  home.homeDirectory = "/home/edouard";
  # let Home manager manage itself
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    iamb
    xdg-utils
    git
    vim
    wget
    curl
    pass
    yubikey-manager
    # utils
    jq
    ripgrep
    starship
    fzf
    zoxide
    htop
    pavucontrol
    # fonts
    unifont
    noto-fonts-emoji
    # dejavu_fonts
    (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
    # browsers
    google-chrome
    # chat
    signal-desktop
    vlc

    # for sway
    nautilus
    kitty
    swaylock
    swayidle
    wl-clipboard
    mako
    wofi
    waybar
    grim
    slurp

    #
    tmux
    screenfetch

    #presentation
    marp-cli
    drawio
    mupdf

    #build-essentials
    gcc
    glibc
    binutils

    wireguard-tools

    # programming
    gnumake
    pkg-config
    openssl
    cmake
    python3
    rustup
    go

    wayland
    qt5.qtwayland
    qt5.qtbase
    qemu
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      menu = "wofi --show run";
      modifier = "Mod4";
      terminal = "ghostty";
      window.titlebar = false;
      gaps = {
        horizontal = 0;
        vertical = 0;
        smartGaps = true;
      };
      workspaceOutputAssign = [
        {
          output = "eDP-1";
          workspace = "1";
        }
        {
          output = "DP-3";
          workspace = "2";
        }
      ];
    };
    extraConfig = ''
      input "type:keyboard" {
        xkb_layout us
        xkb_variant intl
      }
    '';
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_rsa_yubikey.pub";
      };
      clevercloud = {
        hostname = "*.clever-cloud.com";
        identityFile = "~/.ssh/id_rsa_yubikey.pub";
      };
      edouardparis = {
        hostname = "*.edouard.paris";
        identityFile = "~/.ssh/id_rsa_yubikey.pub";
      };
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableBashIntegration = true;
    font = {
      name = "FiraCode";
    };
    extraConfig = ''
      confirm_os_window_close -1
    '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "$HOME/go/bin:$HOME/.cargo/bin:$PATH";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    SDL_VIDEODRIVER = "wayland";

    # needs qt5.qtwayland in systemPackages
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/${pkgs.qt5.qtbase.qtPluginPrefix}";
    QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      jrnl = "cd ~/Documents/journal && nix run github:edouardparis/jrnl";
      oldvim = "nix run github:edouardparis/neovim-flake";
      gs = "git status";
      gco = "git checkout $(git for-each-ref refs/heads/ --format='%(refname:short)' | fzf)";
      gcb = "git checkout -b";
      gcam = "git commit -a -m";
      gacam = "git add . & git commit -a -m";
      passp = "PASSWORD_STORE_DIR=~/.password-personal pass";
    };
    initExtra = ''
      [[ -f ~/.profile ]] && . ~/.profile

      . /etc/profiles/per-user/edouard/share/bash-completion/completions/pass
      _passp() {
        # trailing / is required for the password-store dir.
        PASSWORD_STORE_DIR=~/.password-personal _pass
      }
      complete -o filenames -F _passp passp
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      set -g mouse on

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };

  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;

  programs.git = {
    enable = true;
    userName = "edouardparis";
    userEmail = "m@edouard.paris";
    signing = {
      key = "5B63F3B97699C7EEF3B040B19B7F629A53E77B83";
    };
    extraConfig = {
      core.editor = "vim";
    };
  };

  programs.firefox = {
    enable = true;
    profiles.edouard = {
      name = "edouard";
      isDefault = true;
      search = {
        force = true;
        default = "DuckDuckGo";
      };
      settings = {
        "browser.tabs.warnOnCloseOtherTabs" = false;
      };
      userChrome = ''
           #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
        opacity: 0;
             pointer-events: none;
           }
           #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
             visibility: collapse !important;
           }
           #titlebar {
             appearance: none !important;
             height: 0px;
           }

           #titlebar > #toolbar-menubar {
             margin-top: 0px;
           }

           #TabsToolbar {
             min-width: 0 !important;
             min-height: 0 !important;
           }
      '';
    };
  };
  xdg.configFile = {
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
  };
}
