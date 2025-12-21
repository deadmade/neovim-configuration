# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration managed entirely through Nix using the nixCats framework. The configuration uses lazy.nvim for plugin management but leverages Nix for LSP servers, formatters, and plugin dependencies rather than Mason.

## Build and Development Commands

- **Build the configuration**: `nix build`
- **Run Neovim**: `nix run` or use the `result` symlink after building
- **Enter development shell**: `nix develop`
- **Update dependencies**: `nix flake update`

## Architecture

### Nix Configuration Layer

The configuration is split across three key Nix files:

- **`flake.nix`**: Main entry point defining inputs (nixCats, nixpkgs, neovim-nightly-overlay) and outputs. Exports packages, overlays, and NixOS/home-manager modules.
- **`packages.nix`**: Defines package variants (e.g., "nvim") with enabled categories. This is where you control which feature sets are enabled.
- **`categories.nix`**: Maps categories to their dependencies. Contains:
  - `lspsAndRuntimeDeps`: LSP servers, formatters, linters (installed via Nix, not Mason)
  - `startupPlugins`: Vim plugins loaded via Nix
  - `optionalPlugins`: Lazy-loaded plugins (though lazy.nvim handles actual loading)
  - `sharedLibraries`: Libraries added to LD_LIBRARY_PATH
  - `environmentVariables`: Runtime environment variables
  - `extraPython3Packages`: Python packages for Neovim's Python provider

### Lua Configuration Layer

- **`init.lua`**: Entry point that:
  - Sets up nixCatsUtils
  - Loads general configuration from `lua/general/`
  - Configures lazy.nvim with nixCats integration using `nixCatsUtils.lazyCat.setup()`
  - Imports plugins from `lua/custom/plugins/`

- **`lua/general/`**: Core Neovim settings
  - `set.lua`: Basic options (leader key, line numbers, clipboard, etc.)
  - `keymaps.lua`: General key mappings
  - `autocommands.lua`: Autocommands

- **`lua/custom/plugins/`**: Plugin configurations as lazy.nvim specs
  - Each file returns a lazy.nvim plugin spec table
  - Use `enabled = require('nixCatsUtils').enableForCategory("category-name")` to conditionally load based on Nix categories

- **`lua/kickstart/plugins/`**: Optional kickstart.nvim-derived plugins

### nixCats Integration Pattern

The configuration uses nixCatsUtils for environment detection and conditional loading:

```lua
-- Check if running under Nix
if require('nixCatsUtils').isNixCats then
  -- Nix-specific code
else
  -- Fallback for non-Nix environments
end

-- Conditional plugin enabling based on category
enabled = require('nixCatsUtils').enableForCategory("category-name")

-- Choose value based on environment
require('nixCatsUtils').lazyAdd(non_nix_value, nix_value)
```

### Category System

Categories in `packages.nix` control which LSPs, plugins, and tools are available:

- **Language-specific**: `lua-dev`, `nix-dev`, `rust-dev`, `web-dev`, `python-dev`, `go-dev`, `systems-dev`
- **Features**: `git-integration`, `text-editing`, `ui-enhancements`, `writing`
- **Core**: `general` (always enabled), `core-plugins` (base plugin set)
- **Kickstart**: `kickstart-debug`, `kickstart-lint`, `kickstart-autopairs`, `kickstart-gitsigns`, `kickstart-indent_line`

## Adding New Functionality

### Adding a Language Server

1. Add the LSP package to `lspsAndRuntimeDeps` in `categories.nix` under appropriate category
2. Add treesitter grammar to `startupPlugins` in same category if needed
3. Configure the server in `lua/custom/plugins/lsp.lua` in the `servers` table
4. Enable the category in `packages.nix` for your package variant

### Adding a Plugin

1. Add the plugin to `startupPlugins` in `categories.nix` under appropriate category
2. Create a new file in `lua/custom/plugins/` with the plugin spec
3. Use `enabled = require('nixCatsUtils').enableForCategory("category-name")` if it should be conditional
4. Enable the category in `packages.nix` if not already enabled

### Adding a Tool (formatter/linter)

1. Add the package to `lspsAndRuntimeDeps` in `categories.nix`
2. Configure it in the appropriate plugin (e.g., `autoformat.lua` for formatters, `lua/kickstart/plugins/lint.lua` for linters)

## Code Style

- **Indentation**: 2 spaces (see `init.lua:83`)
- **String quotes**: Single quotes preferred
- **Naming**: snake_case for local variables and functions
- **Formatting**: Stylua for Lua code (format on save enabled except for C/C++)
- **Manual formatting**: `<leader>f`

## Key LSP Configuration Notes

- **Mason is disabled under Nix**: The configuration detects `require('nixCatsUtils').isNixCats` and uses `vim.lsp.config` directly instead of Mason
- **nixd is used for Nix LSP** when running under Nix (not available in Mason)
- **LSP setup is in two paths**:
  - Nix path: Directly configures `vim.lsp.config[server_name]`
  - Non-Nix path: Uses Mason handlers

## Important Patterns

### Conditional Loading

Always use nixCatsUtils for environment-aware configuration:

```lua
-- For Mason and similar tools
enabled = require('nixCatsUtils').lazyAdd(true, false)

-- For checking environment in config
if require('nixCatsUtils').isNixCats then
  -- Use Nix-provided tools
else
  -- Use Mason/standalone tools
end
```

### Plugin Specs

Plugin files in `lua/custom/plugins/` should return a table:

```lua
return {
  'plugin/name',
  enabled = require('nixCatsUtils').enableForCategory("category-name"),
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Plugin configuration
  end,
}
```

### Treesitter Integration

Treesitter plugins are added with grammars in `categories.nix`:

```lua
(nvim-treesitter.withPlugins (plugins: with plugins; [
  grammar1
  grammar2
]))
```

## Special Considerations

- **No Mason under Nix**: All LSPs, formatters, and tools come from Nix packages
- **Lazy-lock.json location**: Determined by `getlockfilepath()` in `init.lua` - uses unwrapped config path under Nix, otherwise standard config path
- **Nerd Font detection**: Uses `nixCats("have_nerd_font")` instead of hardcoding
- **direnv integration**: `.envrc` file enables automatic nix environment loading with direnv
