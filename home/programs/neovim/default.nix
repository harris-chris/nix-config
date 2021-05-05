{ config, lib, pkgs, ... }:

let 
   plugins = pkgs.vimPlugins;

   myVimPlugins = with plugins; [
      coc-nvim
      coc-metals
      fzf-vim
      lightline-vim
      iceberg-vim
      multiple-cursors
      nerdcommenter
      nerdtree
      nerdtree-git-plugin
      vim-airline
      vim-airline-themes
      vim-bufkill
      vim-devicons
      vim-fish
      vim-nix
      vim-scala
   ];

   baseConfig = builtins.readFile ./config.vim;
   cocConfig = builtins.readFile ./coc.vim;
   cocSettings = builtins.toJSON (import ./coc-settings.nix);
   pluginsConfig = builtins.readFile ./plugins.vim;
   vimConfig = baseConfig + pluginsConfig + cocConfig;

in {
   programs.neovim = {
      enable        = true;
      extraConfig   = vimConfig;
      plugins       = myVimPlugins;
      withNodeJs    = true;
   };

   xdg.configFile = {
      "nvim/coc-settings.json".text = cocSettings;
   };
}
