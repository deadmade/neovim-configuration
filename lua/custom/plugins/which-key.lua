return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = 'VimEnter',
  config = function()
    require('which-key').setup()

    -- Document all keybindings for discoverability
    require('which-key').add {
      -- Leader key groups
      { '<leader>c', group = '[C]ode' },
      { '<leader>ca', desc = '[C]ode [A]ction' },
      { '<leader>c_', hidden = true },

      { '<leader>d', group = '[D]ocument' },
      { '<leader>ds', desc = '[D]ocument [S]ymbols' },
      { '<leader>d_', hidden = true },

      { '<leader>r', group = '[R]ename' },
      { '<leader>rn', desc = '[R]e[n]ame' },
      { '<leader>r_', hidden = true },

      { '<leader>s', group = '[S]earch' },
      { '<leader>sh', desc = '[S]earch [H]elp' },
      { '<leader>sk', desc = '[S]earch [K]eymaps' },
      { '<leader>sf', desc = '[S]earch [F]iles' },
      { '<leader>ss', desc = '[S]earch [S]elect Telescope' },
      { '<leader>sw', desc = '[S]earch current [W]ord' },
      { '<leader>sg', desc = '[S]earch by [G]rep' },
      { '<leader>sd', desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', desc = '[S]earch [R]esume' },
      { '<leader>s.', desc = '[S]earch Recent Files ("." for repeat)' },
      { '<leader>s/', desc = '[S]earch in Open Files' },
      { '<leader>sn', desc = '[S]earch [N]eovim files' },
      { '<leader>s_', hidden = true },

      { '<leader>t', group = '[T]oggle' },
      { '<leader>th', desc = '[T]oggle Inlay [H]ints' },
      { '<leader>tb', desc = '[T]oggle Git [B]lame' },
      { '<leader>td', desc = '[T]oggle [D]eleted' },
      { '<leader>t_', hidden = true },

      { '<leader>w', group = '[W]orkspace/[W]indow' },
      { '<leader>ws', desc = '[W]orkspace [S]ymbols' },
      { '<leader>w|', desc = 'Split vertical' },
      { '<leader>w-', desc = 'Split horizontal' },
      { '<leader>w_', hidden = true },

      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>hs', desc = '[H]unk [S]tage' },
      { '<leader>hr', desc = '[H]unk [R]eset' },
      { '<leader>hS', desc = '[H]unk [S]tage Buffer' },
      { '<leader>hu', desc = '[H]unk [U]ndo Stage' },
      { '<leader>hR', desc = '[H]unk [R]eset Buffer' },
      { '<leader>hp', desc = '[H]unk [P]review' },
      { '<leader>hb', desc = '[H]unk [B]lame Line' },
      { '<leader>hd', desc = '[H]unk [D]iff This' },
      { '<leader>hD', desc = '[H]unk [D]iff This (cached)' },
      { '<leader>h_', hidden = true },

      -- Direct leader mappings
      { '<leader>D', desc = 'Type [D]efinition' },
      { '<leader>q', desc = 'Open diagnostic [Q]uickfix list' },
      { '<leader>f', desc = '[F]ormat Buffer' },
      { '<leader>lg', desc = 'Lazygit' },
      { '<leader>m', desc = 'Run make' },
      { '<leader>y', desc = 'Yank to system clipboard', mode = { 'n', 'v' } },
      { '<leader>Y', desc = 'Yank line to system clipboard' },
      { '<leader>p', desc = 'Paste without yanking replaced text', mode = 'x' },
      { '<leader>j', desc = 'Previous location item' },
      { '<leader>k', desc = 'Next location item' },
      { '<leader>vd', desc = '[V]iew [D]iagnostics' },
      { '<leader>vrr', desc = '[V]iew [R]eferences' },
      { '<leader>vws', desc = '[V]iew [W]orkspace [S]ymbols' },
      { '<leader>zig', desc = 'LSP restart' },
      { '<leader><leader>', desc = '[ ] Find Existing Buffers' },
      { '<leader>/', desc = '[/] Fuzzily Search in Current Buffer' },

      -- Goto mappings
      { 'g', group = '[G]oto' },
      { 'gd', desc = '[G]oto [D]efinition' },
      { 'gr', desc = '[G]oto [R]eferences' },
      { 'gI', desc = '[G]oto [I]mplementation' },
      { 'gD', desc = '[G]oto [D]eclaration' },

      -- Other direct mappings
      { 'K', desc = 'Hover Documentation' },

      -- Diagnostic navigation
      { '[d', desc = 'Go to Previous [D]iagnostic Message' },
      { ']d', desc = 'Go to Next [D]iagnostic Message' },

      -- Quickfix / hunk navigation
      { '[q', desc = 'Previous quickfix item' },
      { ']q', desc = 'Next quickfix item' },
      { '[h', desc = 'Go to Previous Git [H]unk' },
      { ']h', desc = 'Go to Next Git [H]unk' },

      -- Window navigation
      { '<C-h>', desc = 'Move Focus to Left Window' },
      { '<C-l>', desc = 'Move Focus to Right Window' },
      { '<C-j>', desc = 'Move Focus to Lower Window' },
      { '<C-k>', desc = 'Move Focus to Upper Window' },

      -- Comment mappings
      {
        mode = { 'n', 'v' },
        { 'gc', desc = 'Toggle Comment' },
        { 'gcc', desc = 'Toggle Line Comment' },
      },

      -- Mini.surround text objects (informational)
      {
        mode = { 'n', 'v' },
        { 'sa', desc = '[S]urround [A]dd' },
        { 'sd', desc = '[S]urround [D]elete' },
        { 'sr', desc = '[S]urround [R]eplace' },
      },
    }
  end,
}
