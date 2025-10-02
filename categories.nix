inputs: let
  inherit (inputs.nixCats) utils;
in { pkgs, settings, categories, name, extra, mkPlugin, ... }@packageDef: {

  lspsAndRuntimeDeps = with pkgs; {
    # Core tools for all packages
    general = [
      universal-ctags
      ripgrep
      fd
      stdenv.cc.cc
    ];
    
    # Lua development (always included for nvim config)
    lua-dev = [
      lua-language-server
      stylua
    ];
    
    # Nix development
    nix-dev = [
      nix-doc
      nixd
    ];
    
    # Rust development
    rust-dev = [
      rust-analyzer
    ];
    
    # Web development
    web-dev = [
      nodejs
      typescript
    ];
    
    # Python development
    python-dev = [
      pyright
    ];
    
    # Go development
    go-dev = [
      go
      gopls
      delve
    ];
    
    # Systems programming
    systems-dev = [
      clang-tools
    ];
    
    # Writing/Documentation
    writing = [
      ltex-ls
      marksman
    ];
    
    # Legacy categories (for kickstart compatibility)
    kickstart-debug = [
      delve
    ];
    kickstart-lint = [
      markdownlint-cli
    ];
  };

  # This is for plugins that will load at startup without using packadd:
  startupPlugins = with pkgs.vimPlugins; {
    # Base plugins for all packages
    general = [
      lazy-nvim
      plenary-nvim
      nvim-web-devicons
    ];
    
    # Core plugins loaded by all packages
    core-plugins = [
      # Core editing
      vim-sleuth
      comment-nvim
      which-key-nvim
      autoclose-nvim
      
      # Telescope
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      
      # LSP & Completion
      nvim-lspconfig
      lazydev-nvim
      fidget-nvim
      conform-nvim
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-nvim-lsp
      cmp-path
      
      # UI & Themes
      tokyonight-nvim
      todo-comments-nvim
      mini-nvim
      lualine-nvim
      hlchunk-nvim
      
      # Base treesitter with essential grammars
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        lua
        vim
        vimdoc
        query
        markdown
        markdown_inline
      ]))
      
      # Git integration & conflict resolution
      gitsigns-nvim
      conflict-marker-vim
    ];
    
    # Lua development (always included)
    lua-dev = [
      # Lua-specific plugins if needed
    ];
    
    # Nix-specific plugins
    nix-dev = [
      (nvim-treesitter.withPlugins (plugins: with plugins; [ nix ]))
    ];
    
    # Rust-specific plugins
    rust-dev = [
      (nvim-treesitter.withPlugins (plugins: with plugins; [ rust toml ]))
    ];
    
    # Web development plugins
    web-dev = [
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        javascript
        typescript
        tsx
        html
        css
        json
        yaml
      ]))
    ];
    
    # Python plugins
    python-dev = [
      (nvim-treesitter.withPlugins (plugins: with plugins; [ python ]))
    ];
    
    # Go plugins
    go-dev = [
      nvim-dap-go
      (nvim-treesitter.withPlugins (plugins: with plugins; [ go gomod gowork ]))
    ];
    
    # Systems programming
    systems-dev = [
      (nvim-treesitter.withPlugins (plugins: with plugins; [ c cpp cmake make ]))
    ];
    
    # Writing plugins
    writing = [
      vimtex
      obsidian-nvim
      (nvim-treesitter.withPlugins (plugins: with plugins; [ 
        markdown 
        latex
        bibtex
      ]))
    ];
    
    # Git integration
    git-integration = [
      gitsigns-nvim
    ];
    
    # Debug support
    kickstart-debug = [
      nvim-dap
      nvim-dap-ui
      nvim-dap-go
      nvim-nio
    ];
    
    # Additional features
    kickstart-autopairs = [
      nvim-autopairs
    ];
    
    kickstart-lint = [
      nvim-lint
    ];
    
    kickstart-indent_line = [
      indent-blankline-nvim
    ];
    
    kickstart-neo-tree = [
      neo-tree-nvim
      nui-nvim
      # nixCats will filter out duplicate packages
      # so you can put dependencies with stuff even if they're
      # also somewhere else
      nvim-web-devicons
      plenary-nvim
    ];
  };

  # not loaded automatically at startup.
  # use with packadd and an autocommand in config to achieve lazy loading
  # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
  # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
  # I just put them all in startupPlugins. I could have put them all in here instead.
  optionalPlugins = {};

  # shared libraries to be added to LD_LIBRARY_PATH
  # variable available to nvim runtime
  sharedLibraries = {
    general = with pkgs; [
      # libgit2
    ];
  };

  # environmentVariables:
  # this section is for environmentVariables that should be available
  # at RUN TIME for plugins. Will be available to path within neovim terminal
  environmentVariables = {
    test = {
      CATTESTVAR = "It worked!";
    };
    EDITOR = "nvim";
  };

  # If you know what these are, you can provide custom ones by category here.
  # If you dont, check this link out:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  extraWrapperArgs = {
    test = [
      '' --set CATTESTVAR2 "It worked again!"''
    ];
  };

  # lists of the functions you would have passed to
  # python.withPackages or lua.withPackages

  # get the path to this python environment
  # in your lua config via
  # vim.g.python3_host_prog
  # or run from nvim terminal via :!<packagename>-python3
  extraPython3Packages = {
    python-dev = (ps: with ps; [ debugpy ]);
    test = (_:[]);
  };
  # populates $LUA_PATH and $LUA_CPATH
  extraLuaPackages = {
    test = [ (_:[]) ];
  };
}