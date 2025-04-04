return {
    "lervag/vimtex",
    event = 'BufRead',  -- Load only when opening a file
    cond = function()
      -- Check if the file is a LaTeX file or if the current directory is part of a LaTeX project
      return vim.fn.expand('%:e') == 'tex'
  end,
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "okular"
    end
  }