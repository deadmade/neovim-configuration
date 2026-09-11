# AGENTS.md - Coding Agent Guidelines

This document provides guidelines for AI coding agents working on this Neovim configuration codebase.

## Overview

This is a **Nix-based Neovim configuration** using the nixCats-nvim framework, deliberately kept
**slim**. It is a terminal editor for **config files and docs** — nix, lua, shell, yaml, json,
toml and markdown. Real application development happens in another editor; do not add language
toolchains, debuggers or IDE features for other languages without being asked.

It combines:
- **Nix Flakes** for reproducible package management (nix fetches and builds every plugin)
- **lazy.nvim** for plugin loading/configuration (it never downloads anything; `wrapRc = true`)
- LSP, treesitter, telescope and blink.cmp for the supported languages

**Architecture:**
- `flake.nix` - Flake definition, outputs, NixOS/home-manager modules
- `categories.nix` - **The plugin and LSP/tool lists**, grouped by category
- `packages.nix` - **The package definition** (`nvim`) and which categories it enables
- `lua/general/` - Core settings, keymaps, autocommands
- `lua/custom/plugins/` - One file per plugin; lazy auto-imports the whole directory
- `lua/nixCatsUtils/` - Nix integration shim (upstream template; do not edit)

Note the naming is counter-intuitive: `categories.nix` holds the package *contents*,
`packages.nix` holds the *category switches*.

## Build, Test, and Lint Commands

### Building and Running
```bash
nix build .#nvim          # build the only package
nix run .#nvim            # run it
nix develop               # dev shell with the package on PATH
nix flake check           # validate the flake
nix flake update          # update inputs
```

There is exactly **one** package, `nvim` (aliased `vim`, `vi`). Do not reintroduce per-language
package variants without being asked.

### Linting and Formatting
```bash
stylua lua/               # format lua (conform also does this on save)
nix flake check           # nix validation
```

### Testing
No test suite. Validation means:
1. `nix build .#nvim`
2. `nix run .#nvim -- --version`
3. `:checkhealth` — expect provider warnings (providers are disabled on purpose); no ERRORs
4. Open a `.nix`, `.lua`, `.sh`, `.yaml`, `.json`, `.toml` and `.md` file and confirm LSP
   attaches (`:checkhealth vim.lsp`) and treesitter highlights

Closure size is a feature. Check it with `nix path-info -Sh .#nvim` before and after changes
that add packages; it currently sits around **1.2 GiB**.

## Code Style Guidelines

### Lua Code Style

**Indentation and Formatting:**
- Use **2 spaces** for indentation (no tabs)
- Follow stylua defaults for formatting
- Max line length: Keep reasonable (~100-120 chars)

**Plugin Configuration Pattern:**
```lua
return { -- Brief description
  'author/plugin-name',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = { 'BufReadPre', 'BufNewFile' }, -- Lazy load on these events
  opts = {
    -- Options passed to setup()
  },
}
```

**Naming Conventions:**
- `snake_case` for variables and functions
- `kebab-case` for plugin categories: `core-plugins`, `config-langs`

**Comments:**
```lua
-- Single line comments use double dash
-- NOTE: Special annotations for important notes
-- TODO: For future work
```

### Nix Code Style

**Indentation:** 2 spaces. Group related functionality into categories.

## nixCats Integration Patterns

**Critical:** This config uses nixCats-nvim utilities throughout. Always use these patterns:

```lua
-- Enable plugin only if category is active
enabled = require('nixCatsUtils').enableForCategory('category-name')

-- Conditionally set values based on Nix vs non-Nix environment
-- First arg: non-Nix value, Second arg: Nix value (optional, defaults to nil)
build = require('nixCatsUtils').lazyAdd(':TSUpdate')

-- Query nixCats categories (available as a global)
if nixCats('have_nerd_font') then ... end
```

## File Organization

### Adding New Plugins

1. Create `lua/custom/plugins/myplugin.lua` returning a lazy spec (see pattern above).
   Lazy auto-imports the directory — **do not** add a manual `require` anywhere.
2. Add the plugin to `categories.nix` under `startupPlugins.core-plugins`.
3. Verify the nixpkgs attribute exists before building:
   `nix eval --raw --impure --expr '...vimPlugins.my-plugin.name'`

### Adding LSP Servers or Tools

1. Add the binary to `lspsAndRuntimeDeps` in `categories.nix` (usually `config-langs`).
2. Add an entry to the `servers` table in `lua/custom/plugins/lsp.lua`.
3. Formatters go in `formatters_by_ft` in `lua/custom/plugins/autoformat.lua`.

### Modifying Keymaps

- Global keymaps: `lua/general/keymaps.lua`
- Plugin-specific keymaps: within that plugin's config file
- LSP keymaps: the `LspAttach` autocmd in `lua/custom/plugins/lsp.lua`
- Add a `desc` to every keymap, and document it in `lua/custom/plugins/which-key.lua`

## Current Contents

**LSP servers:** `bashls`, `jsonls`, `taplo`, `marksman`, `yamlls`, `lua_ls`, `nixd`

**Treesitter:** an explicit grammar list in `categories.nix` (~19 languages), **not**
`withAllGrammars` — that pulled in 326 grammars. nvim-treesitter's main branch no longer enables
highlighting itself, so `lua/custom/plugins/treesitter.lua` starts it from a `FileType` autocmd.

**Plugins:** telescope (+fzf-native, ui-select), nvim-lspconfig, lazydev, fidget, conform,
blink.cmp, tokyonight, mini.nvim (ai/surround/statusline), hlchunk, gitsigns, conflict-marker,
which-key, Comment.nvim, todo-comments, autoclose, vim-sleuth, direnv.vim.

**Deliberately absent** — do not re-add without being asked: nvim-dap, neo-tree, snacks.nvim,
lualine, obsidian.nvim, vimtex, nvim-cmp, mason, indent-blankline, nvim-autopairs, nvim-lint,
and the rust/go/python/web/C/LaTeX toolchains.

## Leader Key

Leader and local leader are both `<Space>`.

## GitHub Actions CI

`.github/workflows/test-packages.yml` builds `.#nvim` and runs `nix flake check` on push/PR.
