{ config, pkgs, ... }:

let
  popupcommands = pkgs.callPackage ./scripts/popupcommands.nix { inherit config pkgs; };
  popupcommands_confirm = pkgs.callPackage ./scripts/popupcommands_confirm.nix { inherit config pkgs; };
  unzip_sjis = pkgs.callPackage ./scripts/unzip_sjis.nix { inherit config pkgs; };

  defaultPkgs = with pkgs; [
    any-nix-shell
    arandr
    bolt
    exa
    fd
    gimp
    jq
    julia153
    libreoffice
    libnotify
    maim
    multilockscreen
    ncpamixer
    neovim-remote
    niv
    nix-prefetch-scripts
    nnn
    pass
    p7zip
    popupcommands
    popupcommands_confirm
    rnix-lsp
    rofi-pass
    signal-desktop
    spotify
    tree
    which
    xclip
    zoom
  ];

  julia_pkgs = import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify                
      name = "my-old-revision";                                                 
      url = "https://github.com/NixOS/nixpkgs/";                       
      ref = "refs/heads/nixpkgs-unstable";                     
      rev = "bed08131cd29a85f19716d9351940bdc34834492";                                           
  }) {};                                                                           
  julia153 = julia_pkgs.julia;
  
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
      EDITOR = "nvim";
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
