inputs: let
  inherit (inputs.nixCats) utils;
in {
  # Base editor with core features
  nvim = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      aliases = [ "vim" "vi" ];
    };
    categories = {
      general = true;
      lua-dev = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # Default kickstart plugins
      kickstart-autopairs = true;
      kickstart-gitsigns = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # Disable specialized plugins in base
      custom-obsidian = false;
      custom-vimtex = false;
      
      have_nerd_font = true;
    };
  };

  # Nix development
  nvim-nix = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      # aliases = [ "nvim-nix" ];  # Remove alias to avoid symlink conflicts
    };
    categories = {
      general = true;
      lua-dev = true;
      nix-dev = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # Disable non-relevant plugins
      custom-obsidian = false;
      custom-vimtex = false;
      
      have_nerd_font = true;
    };
  };

  # Rust development
  nvim-rust = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      # aliases = [ "nvim-rs" ];  # Remove alias to avoid symlink conflicts
    };
    categories = {
      general = true;
      lua-dev = true;
      rust-dev = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # Disable non-relevant plugins
      custom-obsidian = false;
      custom-vimtex = false;
      
      kickstart-debug = true;
      have_nerd_font = true;
    };
  };

  # Web development (JS/TS/React/etc)
  nvim-web = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      # aliases = [ "nvim-web" ];  # Remove alias to avoid symlink conflicts
    };
    categories = {
      general = true;
      lua-dev = true;
      web-dev = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # Disable non-relevant plugins
      custom-obsidian = false;
      custom-vimtex = false;
      
      kickstart-debug = true;
      kickstart-lint = true;
      have_nerd_font = true;
    };
  };

  # Python development
  nvim-python = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      # aliases = [ "nvim-py" ];  # Remove alias to avoid symlink conflicts
    };
    categories = {
      general = true;
      lua-dev = true;
      python-dev = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # Disable non-relevant plugins
      custom-obsidian = false;
      custom-vimtex = false;
      
      kickstart-debug = true;
      kickstart-lint = true;
      have_nerd_font = true;
    };
  };

  # Go development
  nvim-go = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      # aliases = [ "nvim-go" ];  # Remove alias to avoid symlink conflicts
    };
    categories = {
      general = true;
      lua-dev = true;
      go-dev = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # Disable non-relevant plugins
      custom-obsidian = false;
      custom-vimtex = false;
      
      kickstart-debug = true;
      have_nerd_font = true;
    };
  };

  # Writing (Markdown/LaTeX/Documentation)
  nvim-writing = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      # aliases = [ "nvim-md" ];  # Remove alias to avoid symlink conflicts
    };
    categories = {
      general = true;
      lua-dev = true;
      writing = true;
      
      # Core editing features
      git-integration = true;
      text-editing = true;
      ui-enhancements = true;
      
      # All core custom plugins in one category
      core-plugins = true;
      
      # Enable writing-specific plugins
      custom-obsidian = true;
      custom-vimtex = true;
      
      kickstart-lint = true;
      have_nerd_font = true;
    };
  };

  # Full-featured version (everything)
  nvim-full = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      # aliases = [ "nvim-full" ];  # Remove alias to avoid symlink conflicts
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
  };
}
