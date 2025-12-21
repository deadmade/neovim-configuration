-- Session management - automatically saves and restores sessions
return {
  'folke/persistence.nvim',
  enabled = require('nixCatsUtils').enableForCategory('ide-features'),
  event = 'BufReadPre',
  config = function()
    require('persistence').setup({
      -- Directory where session files are saved
      dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),

      -- Session options to save
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },

      -- Pre-save hook to clean up before saving session
      pre_save = nil,

      -- Save the session upon exiting Neovim
      save_empty = false,
    })

    -- Keybindings for session management
    vim.keymap.set('n', '<leader>qs', function()
      require('persistence').load()
    end, { desc = 'Restore [S]ession for Current Directory' })

    vim.keymap.set('n', '<leader>ql', function()
      require('persistence').load({ last = true })
    end, { desc = 'Restore [L]ast Session' })

    vim.keymap.set('n', '<leader>qd', function()
      require('persistence').stop()
    end, { desc = "[D]on't Save Current Session on Exit" })

    -- Auto-load session on startup if no files were opened
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('persistence_autoload', { clear = true }),
      callback = function()
        -- Only load the session if nvim was started with no arguments
        if vim.fn.argc(-1) == 0 then
          -- Don't load session if we're in alpha dashboard
          if vim.bo.filetype ~= 'alpha' then
            require('persistence').load()
          end
        end
      end,
      nested = true,
    })
  end,
}
