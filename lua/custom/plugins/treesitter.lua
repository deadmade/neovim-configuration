return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = { 'BufReadPre', 'BufNewFile' },
  build = require('nixCatsUtils').lazyAdd(':TSUpdate'),
  main = 'nvim-treesitter',
  opts = {},
  config = function(_, opts)
    require('nvim-treesitter').setup(opts)

    -- NOTE: nvim-treesitter's main branch dropped the old `highlight = { enable = true }`
    -- option along with configs.lua -- nothing turns highlighting on by itself any more.
    -- Start it per buffer for every filetype we actually shipped a parser for.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-highlight', { clear = true }),
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match)
        if lang then
          pcall(vim.treesitter.start, event.buf, lang)
        end
      end,
    })
  end,
}
