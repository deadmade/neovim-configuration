return {
  {
    'folke/tokyonight.nvim',
    enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
    priority = 1000,
    init = function()
      vim.cmd.colorscheme('tokyonight-moon')
      vim.cmd.hi('Comment gui=none')
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  },
  {
    'rebelot/kanagawa.nvim',
    enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  },
  {
    'morhetz/gruvbox',
    enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  },
}
