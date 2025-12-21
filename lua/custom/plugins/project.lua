-- Project management for Neovim
return {
  'ahmedkhalf/project.nvim',
  enabled = require('nixCatsUtils').enableForCategory('ide-features'),
  config = function()
    require('project_nvim').setup({
      -- Detection methods for project root
      detection_methods = { 'pattern', 'lsp' },

      -- Patterns to identify project root
      patterns = {
        '.git',
        '_darcs',
        '.hg',
        '.bzr',
        '.svn',
        'Makefile',
        'package.json',
        'flake.nix',
        'Cargo.toml',
        'go.mod',
        'pyproject.toml',
        'pom.xml',
      },

      -- Don't calculate root dir when opening a file from home directory
      exclude_dirs = { '~/' },

      -- Show hidden files in telescope
      show_hidden = false,

      -- Don't change directory silently
      silent_chdir = false,

      -- Path to store project history
      datapath = vim.fn.stdpath('data'),
    })

    -- Integrate with telescope if available
    pcall(function()
      require('telescope').load_extension('projects')
    end)

    -- Add telescope keybinding for project picker
    vim.keymap.set('n', '<leader>sp', function()
      require('telescope').extensions.projects.projects({})
    end, { desc = '[S]earch [P]rojects' })
  end,
}
