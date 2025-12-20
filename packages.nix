inputs: let
  inherit (inputs.nixCats) utils;
in {
  nvim = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      aliases = [ "vim" "vi" ];
    };
    categories = {
      general = true;
      lua-dev = true;
      nix-dev = true;
      rust-dev = true;
      web-dev = true;
      python-dev = true;
      go-dev = true;
      systems-dev = true;
      writing = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # All specialized plugins enabled
      custom-obsidian = true;
      custom-vimtex = true;
      
      # All kickstart plugins enabled
      kickstart-debug = true;
      kickstart-lint = true;
      kickstart-autopairs = true;
      kickstart-gitsigns = true;
      kickstart-indent_line = true;
      have_nerd_font = true;
  };
  }
}
