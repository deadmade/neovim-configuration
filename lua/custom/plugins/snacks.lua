return {
  'folke/snacks.nvim',
  enabled = require('nixCatsUtils').enableForCategory('core-snacks'),
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        { section = 'startup' },
      },
    },
    bigfile = { enabled = true },
    statuscolumn = { enabled = true },
    notifier = { enabled = true },
    lazygit = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        reverse = true,
      },
    },
  },
  keys = {
    { '<leader>lg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart find files' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find files' },
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent files' },
    { '<leader>dd', function() Snacks.picker.git_diff() end, desc = 'Git diff hunks' },
    { '<leader>tt', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
    { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
      end,
    })
  end,
}
