# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A **Nix-based Neovim configuration** built on nixCats-nvim, deliberately kept **slim**. It is a
terminal editor for **config files and docs**. Real application development happens in another
editor, so do not add language toolchains, debuggers, git integrations, themes or IDE features
without being asked.

- **Nix** fetches and builds every plugin and tool; **lazy.nvim** only loads and configures them
  and never downloads anything (`wrapRc = true`, lazy rocks disabled in `init.lua`).
- The config is also exported as NixOS and home-manager modules (see *Nix modules* below).

## Commands

```bash
nix build .#nvim              # build the only package
nix run .#nvim                # run it (also: nix run .#nvim -- --version)
nix develop                   # dev shell with the package on PATH
nix flake check               # validate the flake (CI runs this)
nix flake update              # update inputs (a scheduled workflow also does this)
nix path-info -Sh .#nvim      # closure size — check before/after adding packages
```

There is no test suite and no bundled formatter or linter for this repo's own lua/nix. Validation
is:
1. `nix build .#nvim` and `nix run .#nvim -- --version` (exactly what CI does)
2. `:checkhealth`: provider warnings are expected (providers are disabled in
   `lua/general/set.lua`), but there should be no ERRORs.
3. Open a `.sh`, `.yaml`, `.toml` and `.md` file, confirm the LSP attaches
   (`:checkhealth vim.lsp`) and treesitter highlights.

## Architecture

Nix side:
- `categories.nix`: **what** goes in the package. Everything lives in the single `general`
  category: runtime binaries in `lspsAndRuntimeDeps`, plugins in `startupPlugins`, and the
  treesitter grammar list. Do not split it into more categories without being asked.
- `packages.nix`: the single `nvim` package (aliased `vim`, `vi`), which enables `general`.
  The names are counter-intuitive: `categories.nix` holds the contents, `packages.nix` holds the
  switches.
- `flake.nix`: wires both through nixCats' builders and exports the package, overlays and modules.

Lua side:
- `init.lua` loads `lua/general/` (options, keymaps, autocommands), then hands lazy.nvim the
  nix-provided plugin path via `nixCatsUtils.lazyCat` and imports `custom.plugins`.
- `lua/custom/plugins/`: one lazy spec per file. Lazy auto-imports the directory, so there is no
  manual `require`.
- `lua/nixCatsUtils/`: upstream template shim. Do not edit it.

A plugin needs **both** halves: its nixpkgs attribute in `categories.nix` and a spec in
`lua/custom/plugins/` gated on the category:

```lua
return {
  'author/plugin-name',
  enabled = require('nixCatsUtils').enableForCategory('general'),
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {},
}
```

The other nixCats helper used in the lua is
`require('nixCatsUtils').lazyAdd(non_nix, nix)` for build steps that only run without nix (e.g.
telescope-fzf-native's `build`). Check a nixpkgs attribute exists before building with
`nix eval --raw --impure --expr '(import <nixpkgs> {}).vimPlugins.<name>.name'`.

### Nix modules

`flake.nix` wraps nixCats' `mkNixosModules` / `mkHomeModules` in `withDefaultEditor`, which adds a
`nvim.defaultEditor` option (default `true`). When `nvim.enable` is set and `nvim.dontInstall` is
not, it sets `EDITOR`/`VISUAL` to `nvim` at `mkOverride 900`, so a user's plain assignment
wins. Setting `EDITOR` inside the wrapper (`environmentVariables` in `categories.nix`) only affects
nvim's own child processes.

## Where things go

- **LSP server:** the binary goes in `lspsAndRuntimeDeps.general` (`categories.nix`), and an
  entry goes in the `servers` table in `lua/custom/plugins/lsp.lua`. Keep the two in sync: a
  server listed without its binary fails when a matching file opens.
- **Formatter:** `formatters_by_ft` in `lua/custom/plugins/autoformat.lua`, plus the binary.
- **Treesitter grammar:** the explicit `nvim-treesitter.withPlugins` list in `categories.nix`.
  Never use `withAllGrammars`, which pulls in hundreds of grammars. nvim-treesitter's main branch
  no longer enables highlighting itself, so `lua/custom/plugins/treesitter.lua` starts it from a
  `FileType` autocmd.
- **Keymaps:** global ones in `lua/general/keymaps.lua`, LSP ones in the `LspAttach` autocmd in
  `lsp.lua`, plugin ones in that plugin's spec. Give every keymap a `desc` and add it to
  `lua/custom/plugins/which-key.lua`. Leader and local leader are both `<Space>`.

## Current scope

**LSP servers:** `bashls`, `taplo`, `marksman`, `yamlls`. Nix, lua and JSON files get treesitter
highlighting only.

**Plugins:** telescope (+fzf-native, ui-select), nvim-lspconfig, fidget, conform, blink.cmp,
mini.nvim (ai/surround/statusline), which-key, Comment.nvim, todo-comments, autoclose,
vim-sleuth. No colorscheme plugin; Neovim's built-in default theme is used.

**Deliberately absent**, do not re-add without being asked: nvim-dap, neo-tree, snacks.nvim,
lualine, obsidian.nvim, vimtex, nvim-cmp, mason, indent-blankline, nvim-autopairs, nvim-lint,
lazydev, direnv.vim, gitsigns, conflict-marker, lazygit, any colorscheme plugin (tokyonight),
hlchunk, the lua/nix/json LSPs and formatters (lua_ls, nixd, jsonls, stylua, nixfmt, nix-doc),
per-language package variants, and the rust/go/python/web/C/LaTeX toolchains.

## Style

Lua files are mixed: some use 2 spaces with single quotes, others (e.g. `init.lua`,
`telescope.lua`) use tabs with double quotes. Match the file you are editing.
Nix uses 2-space indentation.
