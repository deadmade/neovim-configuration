inputs: let
  inherit (inputs.nixCats) utils;
in { pkgs, settings, categories, name, extra, mkPlugin, ... }@packageDef: {

  lspsAndRuntimeDeps = with pkgs; {
    # Core tools for all packages
    general = [
      ripgrep
      fd
      lazygit
    ];

    # Lua development (this config is written in lua)
    lua-dev = [
      lua-language-server
      stylua
    ];

    # Nix development
    nix-dev = [
      nix-doc
      nixd
      nixfmt
    ];

    # Everything else this editor is meant for: config files and docs
    config-langs = [
      bash-language-server
      yaml-language-server
      taplo # toml
      vscode-langservers-extracted # json / jsonls
      marksman # markdown
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

    core-plugins = [
      # Core editing
      vim-sleuth
      comment-nvim
      todo-comments-nvim
      which-key-nvim
      autoclose-nvim
      mini-nvim # mini.ai, mini.surround, mini.statusline

      # Telescope
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim

      # LSP, completion & formatting
      nvim-lspconfig
      lazydev-nvim
      fidget-nvim
      conform-nvim
      blink-cmp

      # UI
      tokyonight-nvim
      hlchunk-nvim

      # Git integration & conflict resolution
      gitsigns-nvim
      conflict-marker-vim

      # Treesitter, limited to the languages this editor actually opens
      (nvim-treesitter.withPlugins (p: with p; [
        nix
        lua
        bash
        yaml
        json
        toml
        markdown
        markdown_inline
        vim
        vimdoc
        query
        regex
        diff
        git_config
        gitcommit
        gitignore
        dockerfile
        ini
        ssh_config
      ]))
    ];

    # Nix-specific plugins
    nix-dev = [
      direnv-vim
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
    general = {
      EDITOR = "nvim";
    };
  };

  # If you know what these are, you can provide custom ones by category here.
  # If you dont, check this link out:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  extraWrapperArgs = {};

  # lists of the functions you would have passed to
  # python.withPackages or lua.withPackages
  extraPython3Packages = {};
  # populates $LUA_PATH and $LUA_CPATH
  extraLuaPackages = {};
}
