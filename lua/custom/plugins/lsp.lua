return {
  'neovim/nvim-lspconfig',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'j-hui/fidget.nvim', opts = {} },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
        },
      },
    },
  },
  config = function()
    -- blink.cmp registers its own capabilities via vim.lsp.config, so the
    -- defaults are all we need to extend here.
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local servers = {
      bashls = {},
      jsonls = {},
      taplo = {},
      marksman = {},
      yamlls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            diagnostics = {
              globals = { 'nixCats' },
              disable = { 'missing-fields' },
            },
          },
        },
      },
      nixd = {},
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', function()
          vim.lsp.buf.hover({ border = 'rounded' })
        end, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>vd', vim.diagnostic.open_float, '[V]iew [D]iagnostics')
        map('<leader>vrr', vim.lsp.buf.references, '[V]iew [R]eferences')
        map('<leader>vws', vim.lsp.buf.workspace_symbol, '[V]iew [W]orkspace [S]ymbols')
        map(']d', function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, 'Next [D]iagnostic')
        map('[d', function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, 'Previous [D]iagnostic')
        map('<C-h>', vim.lsp.buf.signature_help, 'Signature help', 'i')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        prefix = '●',
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
      },
    })

    vim.lsp.config('*', { capabilities = capabilities })
    for server_name, server in pairs(servers) do
      if next(server) ~= nil then
        vim.lsp.config(server_name, server)
      end
    end
    vim.lsp.enable(vim.tbl_keys(servers))
  end,
}
