local autocmd = vim.api.nvim_create_autocmd

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
    vim.hl.on_yank()
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
