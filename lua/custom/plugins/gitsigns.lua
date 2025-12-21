return {
    'lewis6991/gitsigns.nvim',
    enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
    event = 'BufRead', -- Load only when opening a file
    cond = function()
        return vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1
      end,
    config = function()
        require('gitsigns').setup {
            signs = {
                add          = { text = '+' },
                change       = { text = '~' },
                delete       = { text = '-' },
                topdelete    = { text = '‾' },
                changedelete = { text = '+~' },
                untracked    = { text = '┆' },
            },
            signs_staged = {
                add          = { text = '+' },
                change       = { text = '~' },
                delete       = { text = '-' },
                topdelete    = { text = '‾' },
                changedelete = { text = '+~' },
                untracked    = { text = '┆' },
            },
            signs_staged_enable = true,
            signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true
            },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
                use_focus = true,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation between hunks
                map('n', ']h', function()
                    if vim.wo.diff then
                        return ']h'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Next Git [H]unk' })

                map('n', '[h', function()
                    if vim.wo.diff then
                        return '[h'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Previous Git [H]unk' })

                -- Actions
                map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
                map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
                map('v', '<leader>hs', function()
                    gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, { desc = '[H]unk [S]tage (Visual)' })
                map('v', '<leader>hr', function()
                    gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, { desc = '[H]unk [R]eset (Visual)' })

                map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage Buffer' })
                map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk [U]ndo Stage' })
                map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk [R]eset Buffer' })
                map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk [P]review' })
                map('n', '<leader>hb', function()
                    gs.blame_line({ full = true })
                end, { desc = '[H]unk [B]lame Line' })
                map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff This' })
                map('n', '<leader>hD', function()
                    gs.diffthis('~')
                end, { desc = '[H]unk [D]iff This (Cached)' })

                -- Toggles
                map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle Git [B]lame' })
                map('n', '<leader>td', gs.toggle_deleted, { desc = '[T]oggle [D]eleted' })

                -- Text object for hunks
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select Git Hunk' })
            end,
        }
    end,
}