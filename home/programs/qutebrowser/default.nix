let 

in {
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        "<Ctrl-h>" = "tab-prev";
        "<Ctrl-l>" = "tab-next";
        "<Shift-r>" = "reload";
        "<Shift-h>" = "back";
      };
    };
    searchEngines = {
      DEFAULT = "https://www.google.com/search?hl=en&q={}";
      nixsearch = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query={}";
      gh = "https://github.com/search?q={}";
    };
    extraConfig = ''
      c.fonts.default_size = '10pt' 
      c.fileselect.handler = 'external'
      c.fileselect.single_file.command = ["alacritty", "-e", "nnn", "-p", "{}"]
      c.fileselect.multiple_files.command = ["alacritty", "-e", "nnn", "-p", "{}"]
      c.fileselect.folder.command = ["alacritty", "-e", "nnn", "-p", "{}"]
      config.load_autoconfig(False) 
    '';
  };
}
