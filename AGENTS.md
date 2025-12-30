# AGENTS.md - Coding Agent Guidelines

This document provides guidelines for AI coding agents working on this Neovim configuration codebase.

## Overview

This is a **NixOS-based Neovim configuration** using the nixCats-nvim framework. It combines:
- **Nix Flakes** for reproducible package management
- **lazy.nvim** for plugin management (configured through Nix)
- **LSP, treesitter, telescope** for IDE-like features
- Modular Lua configuration split across multiple files

**Architecture:**
- `flake.nix` - Main flake definition and build configuration
- `packages.nix` - Plugin and LSP tool definitions by category
- `categories.nix` - Feature categories for different package variants
- `lua/general/` - Core Neovim settings, keymaps, autocommands
- `lua/custom/plugins/` - Custom plugin configurations
- `lua/kickstart/plugins/` - Kickstart.nvim plugin configurations
- `lua/nixCatsUtils/` - Nix integration utilities

## Build, Test, and Lint Commands

### Building and Running
```bash
# Build the default package
nix build .#nvim

# Run Neovim directly
nix run .#nvim

# Build language-specific variants
nix build .#nvim-rust
nix build .#nvim-web
nix build .#nvim-python
nix build .#nvim-go
nix build .#nvim-writing
nix build .#nvim-full

# Enter development shell
nix develop
```

### Testing and Validation
```bash
# Validate flake structure and all packages
nix flake check

# Test specific package builds (from CI workflow)
nix build .#nvim-rust --no-link
nix run .#nvim-rust -- --version

# Show available flake outputs
nix flake show

# Update flake inputs
nix flake update
```

### Linting and Formatting
```bash
# Format Lua code with stylua (must be in environment)
stylua lua/

# Format specific file
stylua lua/custom/plugins/lsp.lua

# Check Nix syntax
nix flake check
```

### Running Single Tests
This is a configuration project without a traditional test suite. Testing involves:
1. Building specific package variants (see above)
2. Running `nvim --version` to verify build
3. Opening Neovim and checking `:checkhealth` for issues
4. Testing specific features manually (LSP, telescope, etc.)

## Code Style Guidelines

### Lua Code Style

**Indentation and Formatting:**
- Use **2 spaces** for indentation (no tabs)
- Follow stylua defaults for formatting
- Max line length: Keep reasonable (~100-120 chars)

**Imports and Requires:**
```lua
-- Use require() for modules
local telescope = require('telescope')
local utils = require('nixCatsUtils')

-- Plugin specs return a table
return {
  'plugin/name',
  enabled = require('nixCatsUtils').enableForCategory("category-name"),
  dependencies = { 'other/plugin' },
  config = function()
    -- Configuration here
  end,
}
```

**Naming Conventions:**
- `snake_case` for variables and functions: `local my_variable = "value"`
- `kebab-case` for plugin categories: `"core-plugins"`, `"rust-dev"`
- `PascalCase` not commonly used in Lua configs

**Comments:**
```lua
-- Single line comments use double dash
-- NOTE: Special annotations for important notes
-- TODO: For future work
-- HACK: For workarounds
-- FIX: For known issues

-- Multi-line explanations use multiple single-line comments
-- like this, rather than block comments
```

**Plugin Configuration Pattern:**
```lua
return { -- Brief description
  'author/plugin-name',
  enabled = require('nixCatsUtils').enableForCategory("category"),
  event = { 'BufReadPre', 'BufNewFile' }, -- Lazy load on these events
  dependencies = {
    'dependency/plugin',
  },
  opts = {
    -- Options passed to setup()
  },
  config = function()
    -- Custom configuration logic
    require('plugin-name').setup({})
  end,
}
```

### Nix Code Style

**Indentation:** 2 spaces
**Attribute sets:** Use clear, descriptive names
**Categories:** Group related functionality (e.g., `rust-dev`, `web-dev`)

```nix
# Example from packages.nix
rust-dev = [
  rust-analyzer
];

# Example from categories.nix
categories = {
  rust-dev = true;
  web-dev = true;
};
```

### Error Handling

- Use `vim.notify()` for user-facing messages
- Check for nil before accessing nested tables
- Use `pcall()` for operations that might fail:
```lua
local ok, module = pcall(require, 'optional-module')
if ok then
  module.setup()
end
```

## nixCats Integration Patterns

**Critical:** This config uses nixCats-nvim utilities throughout. Always use these patterns:

```lua
-- Enable plugin only if category is active
enabled = require('nixCatsUtils').enableForCategory("category-name")

-- Conditionally set values based on Nix vs non-Nix environment
-- First arg: non-Nix value, Second arg: Nix value (optional, defaults to nil)
ensure_installed = require('nixCatsUtils').lazyAdd({ "parser1", "parser2" })
auto_install = require('nixCatsUtils').lazyAdd(true, false)

-- Check if running under Nix
if require('nixCatsUtils').isNixCats then
  -- Nix-specific logic
end

-- Query nixCats categories (available as global)
if nixCats("have_nerd_font") then
  -- Use nerd font icons
end
```

## File Organization

### Adding New Plugins

1. Create new file in `lua/custom/plugins/myplugin.lua`
2. Export plugin spec following the pattern above
3. Import in `lua/custom/plugins/init.lua`:
   ```lua
   require("custom.plugins.myplugin"),
   ```
4. Add plugin to `packages.nix` under appropriate category:
   ```nix
   startupPlugins = {
     my-category = [
       pkgs.vimPlugins.my-plugin
     ];
   };
   ```
5. Enable category in `categories.nix` if needed

### Adding LSP Servers or Tools

1. Add to `lspsAndRuntimeDeps` in `packages.nix`:
   ```nix
   my-category = [
     my-language-server
     my-formatter
   ];
   ```
2. Configure LSP in `lua/custom/plugins/lsp.lua`
3. Configure formatter in `lua/custom/plugins/autoformat.lua`

### Modifying Keymaps

- Global keymaps: `lua/general/keymaps.lua`
- Plugin-specific keymaps: Within the plugin's config file
- LSP keymaps: In `lua/custom/plugins/lsp.lua` LspAttach autocmd

## Common Patterns

**Lazy Loading:**
- Use `event = { 'BufReadPre', 'BufNewFile' }` for file-editing plugins
- Use `event = "VimEnter"` for UI plugins that should load at startup
- Use `cmd = "CommandName"` for command-triggered plugins
- Use `ft = "filetype"` for filetype-specific plugins

**Leader Key:**
- Leader key is `<Space>`
- Local leader is also `<Space>`
- Use descriptive `desc` in all keymaps for which-key integration

**Autocommands:**
- Create augroups with `clear = true` to avoid duplicates
- Use descriptive group names: `'kickstart-lsp-attach'`

## Best Practices

1. **Always test with Nix:** Run `nix build` after changes
2. **Use nixCats utilities:** Don't bypass the nixCats integration layer
3. **Keep plugins modular:** One plugin per file in `lua/custom/plugins/`
4. **Document categories:** Update both `packages.nix` and `categories.nix` together
5. **Lazy load when possible:** Improves startup time significantly
6. **Follow existing patterns:** Match the style of existing plugin configs
7. **Test incrementally:** Build after each significant change
8. **Use descriptive commit messages:** Focus on "why" not just "what"

## GitHub Actions CI

The `.github/workflows/test-packages.yml` workflow tests all package variants on push/PR.
Ensure your changes don't break any of the package builds before committing.
