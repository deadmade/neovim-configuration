local autocmd = vim.api.nvim_create_autocmd

local function save_theme(theme)
  local path = vim.fn.stdpath('data') .. '/last_theme.txt'
  local file = io.open(path, 'w')
  if file then
    file:write(theme)
    file:close()
  else
    vim.notify('Error saving theme', vim.log.levels.ERROR)
  end
end

local function load_theme()
  local path = vim.fn.stdpath('data') .. '/last_theme.txt'
  local file = io.open(path, 'r')
  if not file then
    return nil
  end

  local theme = file:read('*l')
  file:close()
  if theme and #theme > 0 then
    return vim.trim(theme)
  end
  return nil
end

autocmd('VimEnter', {
  callback = function()
    local last_theme = load_theme()
    if not last_theme then
      return
    end

    local ok = pcall(vim.cmd.colorscheme, last_theme)
    if not ok then
      vim.notify('Colorscheme not found: ' .. last_theme, vim.log.levels.WARN)
      return
    end

    vim.defer_fn(function()
      local lualine_ok, lualine = pcall(require, 'lualine')
      if lualine_ok then
        lualine.setup(lualine.get_config())
        vim.cmd('redrawstatus')
      end
    end, 50)
  end,
})

autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    local theme = vim.g.colors_name
    if not theme then
      return
    end

    save_theme(theme)

    local ok, lualine = pcall(require, 'lualine')
    if ok then
      lualine.refresh()
    end
  end,
})

autocmd('LspAttach', {
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if client and client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

autocmd('FileType', {
  pattern = 'c',
  callback = function()
    vim.opt_local.wrap = false
  end,
})

autocmd('FileType', {
  pattern = { 'c', 'cpp', 'h' },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local function get_hl(name)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
      return ok and hl or {}
    end

    local bg = get_hl('Normal').bg or '#000000'
    local bg_alt = get_hl('Visual').bg or '#1e1e2e'
    local green = get_hl('String').fg or '#a6e3a1'
    local red = get_hl('Error').fg or '#f38ba8'

    vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { fg = bg_alt, bg = bg })
    vim.api.nvim_set_hl(0, 'SnacksPicker', { bg = bg })
    vim.api.nvim_set_hl(0, 'SnacksPickerPreview', { bg = bg })
    vim.api.nvim_set_hl(0, 'SnacksPickerPreviewTitle', { fg = bg, bg = green })
    vim.api.nvim_set_hl(0, 'SnacksPickerInputSearch', { fg = red, bg = bg })
    vim.api.nvim_set_hl(0, 'SnacksPickerListBorder', { fg = bg, bg = bg })
    vim.api.nvim_set_hl(0, 'SnacksPickerList', { bg = bg })
    vim.api.nvim_set_hl(0, 'SnacksPickerListTitle', { fg = bg, bg = bg })
  end,
})
