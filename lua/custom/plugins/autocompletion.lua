return { -- Completion
  'saghen/blink.cmp',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = 'InsertEnter',
  opts = {
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    sources = { default = { 'lsp', 'path', 'buffer' } },
    -- nixpkgs ships the prebuilt rust fuzzy matcher, so no build step is needed
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
  },
}
