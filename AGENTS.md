# AGENTS.md - Coding Agent Guidelines

## Build/Development Commands
- **Build**: `nix build` (builds the Neovim configuration)
- **Development shell**: `nix develop` (enters development environment)
- **Run Neovim**: `nix run` or build and use the resulting symlink
- **Update flake**: `nix flake update` (updates dependencies)

## Code Style Guidelines

### Lua Configuration
- Use 2-space indentation (tabs converted to spaces, see init.lua:83)
- Single quotes for strings preferred
- Snake_case for local variables and functions
- Follow existing nixCats patterns for conditional loading
- Use `require('nixCatsUtils').lazyAdd(non_nix_value, nix_value)` for conditional plugin enabling

### Structure Conventions
- Plugin configs go in `lua/custom/plugins/`
- General settings in `lua/general/` (set.lua, keymaps.lua, autocommands.lua)
- Use lazy loading with events like `{ 'BufReadPre', 'BufNewFile' }`
- Nix-managed dependencies over Mason when possible

### Formatting
- Stylua for Lua formatting (`lua = { 'stylua' }` in conform config)
- Format on save enabled (except for C/C++)
- Use `<leader>f` for manual formatting

### Error Handling
- Use nixCats utilities for environment detection
- Graceful fallbacks for non-Nix environments
- Prefer explicit error messages in plugin configurations