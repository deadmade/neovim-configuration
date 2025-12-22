-- Alpha is a fast and customizable greeter/dashboard
return {
  'goolord/alpha-nvim',
  enabled = require('nixCatsUtils').enableForCategory('ide-features'),
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Only show dashboard if no files were opened
    if vim.fn.argc(-1) ~= 0 then
      return
    end

    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    -- Set header
    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                                     ',
      '                   [ IDE Mode ]                      ',
      '                                                     ',
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button('f', '  Find File', ':Telescope find_files<CR>'),
      dashboard.button('r', '  Recent Files', ':Telescope oldfiles<CR>'),
      dashboard.button('p', '  Find Project', ':Telescope projects<CR>'),
      dashboard.button('g', '  Find Text', ':Telescope live_grep<CR>'),
      dashboard.button('n', '  New File', ':ene <BAR> startinsert<CR>'),
      dashboard.button('s', '  Restore Session', [[<cmd>lua require('persistence').load()<CR>]]),
      dashboard.button('c', '  Configuration', ':e $MYVIMRC<CR>'),
      dashboard.button('l', '  Lazy Plugin Manager', ':Lazy<CR>'),
      dashboard.button('q', '  Quit', ':qa<CR>'),
    }

    -- Set footer
    local function footer()
      local total_plugins = #vim.tbl_keys(require('lazy').plugins())
      local datetime = os.date(' %Y-%m-%d   %H:%M:%S')
      local version = vim.version()
      local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch

      return {
        '',
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        '',
        '  Tip: Press Space to see all keybindings',
        '  Tip: Press \\ to toggle file explorer',
        '  Tip: Press <leader>sh to search help topics',
        '',
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        '',
        datetime .. '   ' .. total_plugins .. ' plugins' .. nvim_version_info,
      }
    end

    dashboard.section.footer.val = footer()

    -- Set highlight groups
    dashboard.section.header.opts.hl = 'Include'
    dashboard.section.buttons.opts.hl = 'Keyword'
    dashboard.section.footer.opts.hl = 'Type'

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

    -- Close alpha when entering a different buffer
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function()
        vim.api.nvim_create_autocmd('BufEnter', {
          pattern = '*',
          callback = function()
            if vim.bo.filetype ~= 'alpha' then
              require('alpha').close()
            end
          end,
        })
      end,
    })
  end,
}
