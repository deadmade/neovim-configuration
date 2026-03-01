return {
  'nvim-treesitter/nvim-treesitter',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = { 'BufReadPre', 'BufNewFile' },
  build = require('nixCatsUtils').lazyAdd(':TSUpdate'),
  opts = {
    ensure_installed = require('nixCatsUtils').lazyAdd({}),
    auto_install = require('nixCatsUtils').lazyAdd(true, false),
    sync_install = false,
    indent = {
      enable = true,
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
