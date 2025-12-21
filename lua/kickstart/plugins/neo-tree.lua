-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  -- NOTE: nixCats: return true only if category is enabled, else false
  enabled = require('nixCatsUtils').enableForCategory("kickstart-neo-tree"),
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
      },
      git_status = {
        symbols = {
          added     = '',
          modified  = '',
          deleted   = '✖',
          renamed   = '',
          untracked = '',
          ignored   = '',
          unstaged  = '',
          staged    = '',
          conflict  = '',
        }
      },
    },
    window = {
      position = 'left',
      width = 30,
      mappings = {
        ['\\'] = 'close_window',
        ['<CR>'] = 'open',
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['<space>'] = 'toggle_node',
        ['a'] = 'add',
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['R'] = 'refresh',
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          'node_modules',
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
        },
      },
    },
  },
}
