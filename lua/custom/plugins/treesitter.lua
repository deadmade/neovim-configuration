return {
  'nvim-treesitter/nvim-treesitter',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = { 'BufReadPre', 'BufNewFile' },
  build = require('nixCatsUtils').lazyAdd(':TSUpdate'),
  main = 'nvim-treesitter',
  opts = {},
}
