-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {            -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document all keybindings for discoverability
    require('which-key').add {
      -- Leader key groups
      { '<leader>c',  group = '[C]ode' },
      { '<leader>ca', desc = '[C]ode [A]ction' },
      { '<leader>c_', hidden = true },

      { '<leader>d',  group = '[D]ocument' },
      { '<leader>ds', desc = '[D]ocument [S]ymbols' },
      { '<leader>d_', hidden = true },

      { '<leader>r',  group = '[R]ename' },
      { '<leader>rn', desc = '[R]e[n]ame' },
      { '<leader>r_', hidden = true },

      { '<leader>s',  group = '[S]earch' },
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
      { '<leader>sp', desc = '[S]earch [P]rojects' },
      { '<leader>s_', hidden = true },

      { '<leader>t',  group = '[T]oggle' },
      { '<leader>th', desc = '[T]oggle Inlay [H]ints' },
      { '<leader>tb', desc = '[T]oggle Git [B]lame' },
      { '<leader>td', desc = '[T]oggle [D]eleted' },
      { '<leader>t_', hidden = true },

      { '<leader>w',  group = '[W]orkspace' },
      { '<leader>ws', desc = '[W]orkspace [S]ymbols' },
      { '<leader>w_', hidden = true },

      { '<leader>q',  group = '[Q]uit/Session' },
      { '<leader>qs', desc = 'Restore [S]ession' },
      { '<leader>ql', desc = 'Restore [L]ast Session' },
      { '<leader>qd', desc = "[D]on't Save Current Session" },
      { '<leader>q_', hidden = true },

      { '<leader>h',  group = 'Git [H]unk', mode = { 'n', 'v' } },
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

      -- Non-leader keybindings
      { '<leader>D',   desc = 'Type [D]efinition' },
      { '<leader>e',   desc = 'Toggle file explorer' },
      { '<leader>vd',  desc = '[V]iew [D]iagnostics' },
      { '<leader>vrr', desc = '[V]iew [R]eferences' },
      { '<leader>vws', desc = '[V]iew [W]orkspace [S]ymbols' },
      { '<leader>f',   desc = '[F]ormat Buffer' },
      { '<leader>ff',  desc = 'Find files' },
      { '<leader>fb',  desc = 'Find buffers' },
      { '<leader>fg',  desc = 'Live grep' },
      { '<leader>fr',  desc = 'Recent files' },
      { '<leader>lg',  desc = 'Lazygit' },
      { '<leader>b',   desc = 'Debug: Toggle [B]reakpoint' },
      { '<leader>B',   desc = 'Debug: Set Conditional [B]reakpoint' },
      { '<leader><leader>', desc = '[ ] Find Existing Buffers' },
      { '<leader>/',   desc = '[/] Fuzzily Search in Current Buffer' },

      -- Goto mappings
      { 'g', group = '[G]oto' },
      { 'gd', desc = '[G]oto [D]efinition' },
      { 'gr', desc = '[G]oto [R]eferences' },
      { 'gI', desc = '[G]oto [I]mplementation' },
      { 'gD', desc = '[G]oto [D]eclaration' },

      -- Other direct mappings
      { 'K', desc = 'Hover Documentation' },
      { '\\', desc = 'Toggle File Explorer (Neo-tree)' },

      -- Diagnostic navigation
      { '[d', desc = 'Go to Previous [D]iagnostic Message' },
      { ']d', desc = 'Go to Next [D]iagnostic Message' },

      -- Hunk navigation
      { '[h', desc = 'Go to Previous Git [H]unk' },
      { ']h', desc = 'Go to Next Git [H]unk' },

      -- Window navigation
      { '<C-h>', desc = 'Move Focus to Left Window' },
      { '<C-l>', desc = 'Move Focus to Right Window' },
      { '<C-j>', desc = 'Move Focus to Lower Window' },
      { '<C-k>', desc = 'Move Focus to Upper Window' },

      -- F-key debug mappings
      { '<F5>', desc = 'Debug: Start/Continue' },
      { '<F1>', desc = 'Debug: Step Into' },
      { '<F2>', desc = 'Debug: Step Over' },
      { '<F3>', desc = 'Debug: Step Out' },
      { '<F7>', desc = 'Debug: See Last Session Result' },

      -- Comment mappings (visual mode)
      { mode = { 'n', 'v' },
        { 'gc', desc = 'Toggle Comment' },
        { 'gcc', desc = 'Toggle Line Comment' },
      },

      -- Mini.surround text objects (informational)
      { mode = { 'n', 'v' },
        { 'sa', desc = '[S]urround [A]dd' },
        { 'sd', desc = '[S]urround [D]elete' },
        { 'sr', desc = '[S]urround [R]eplace' },
      },
    }
  end
}
