{ config, pkgs, ... }:

let
  neovim-nightly = (import (builtins.fetchTarball {
    url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  }));

  popupcommands = pkgs.callPackage ./scripts/popupcommands.nix { inherit config pkgs; };
  popupcommands_confirm = pkgs.callPackage ./scripts/popupcommands_confirm.nix { inherit config pkgs; };
  unzip_sjis = pkgs.callPackage ./scripts/unzip_sjis.nix { inherit config pkgs; };

  defaultPkgs = with pkgs; [
    any-nix-shell
    arandr
    awscli2
    bolt
    ccls
    docker
    docker-compose
    diff-so-fancy
    exa
    fd
    gcc
    gimp
    jq
    julia-stable-bin
    haskell-language-server
    killall
    libreoffice
    libnotify
    lsof
    maim
    multilockscreen
    mysql-client
    ncpamixer
    neovim-remote
    niv
    nix-prefetch-scripts
    nmap
    nnn
    pass
    p7zip
    popupcommands
    popupcommands_confirm
    rnix-lsp
    signal-desktop
    spotify
    tmux
    tree
    which
    xclip
    zoom
  ];
  
  polybarPkgs = with pkgs; [
    font-awesome-ttf      # awesome fonts
    material-design-icons # fonts with glyphs
  ];

  scripts = pkgs.callPackage ./scripts/default.nix { inherit config pkgs; };

  xmonadPkgs = with pkgs; [
    nitrogen
    xcape
    xorg.xev
    xorg.xkbcomp
    xorg.xmodmap
    xorg.xrandr
  ];
in {
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = p: {
      fish-foreign-env = pkgs.fishPlugins.foreign-env;
    };
  };

  nixpkgs.overlays = [ neovim-nightly ];

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        font = "JetBrainsMono Nerd Font 8";
        line_height = 4;
        format = ''<b>%s</b>\n%b'';
      };
    };
  };

  home = {
    username = "chris";
    homeDirectory = "/home/chris";
    packages = defaultPkgs ++ polybarPkgs ++ scripts ++ xmonadPkgs;
    stateVersion = "21.03";

    sessionVariables = {
      DISPLAY = ":0";
      EDITOR = "nvr";
      JULIA_DEPOT_PATH = "/home/chris/.julia";
    };
  };

  programs = {
    bat.enable = true;
    gpg.enable = true;
    password-store.enable = true;
    password-store.package = pkgs.pass;
    password-store.settings = {
      PASSWORD_STORE_DIR = "/data/gpg";
      PASSWORD_STORE_KEY = "chrisharriscjh@gmail.com";
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      enableNixDirenvIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    htop = {
      enable = true;
      sortDescending = true;
      sortKey = "PERCENT_CPU";
    };

    ssh.enable = true;
  };


  imports = (import ./programs) ++ (import ./services);
}
