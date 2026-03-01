return {
  'neovim/nvim-lspconfig',
  enabled = require('nixCatsUtils').enableForCategory('core-plugins'),
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    {
      'williamboman/mason.nvim',
      enabled = require('nixCatsUtils').lazyAdd(true, false),
      config = true,
    },
    {
      'williamboman/mason-lspconfig.nvim',
      enabled = require('nixCatsUtils').lazyAdd(true, false),
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      enabled = require('nixCatsUtils').lazyAdd(true, false),
    },
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
    local lspconfig = require('lspconfig')
    local util = require('lspconfig.util')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      clangd = {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--completion-style=detailed',
          '--fallback-style=file',
          '--all-scopes-completion=false',
        },
        init_options = {
          fallbackFlags = { '-std=c99' },
          useDefaultFallbackStyle = false,
        },
        root_dir = util.root_pattern('CMakeLists.txt', '.git'),
      },
      gopls = {},
      pyright = {
        settings = {
          python = {
            checkOnType = false,
            diagnostics = false,
            inlayHints = false,
            smartCompletion = true,
          },
        },
      },
      rust_analyzer = {
        settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            check = { command = 'clippy' },
            diagnostics = { enable = true },
          },
        },
      },
      marksman = {},
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = 'latexmk',
              args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
              onSave = true,
            },
          },
        },
      },
      ltex = {
        filetypes = { 'markdown', 'text', 'tex' },
        settings = {
          ltex = {
            language = 'de',
            additionalLanguages = { 'en-US' },
            additionalRules = {
              enablePickyRules = true,
              languageModel = 'n-gram',
              motherTongue = 'de',
            },
          },
        },
      },
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
    }

    if require('nixCatsUtils').isNixCats then
      servers.nixd = {}
    else
      servers.nil_ls = {
        settings = {
          ['nil'] = {
            formatting = {
              command = { 'nixfmt' },
            },
          },
        },
      }
    end

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
        map(']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')
        map('[d', vim.diagnostic.goto_prev, 'Previous [D]iagnostic')
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

    if require('nixCatsUtils').isNixCats then
      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        lspconfig[server_name].setup(server)
      end
      return
    end

    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { 'stylua' })
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
      },
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
  end,
}
