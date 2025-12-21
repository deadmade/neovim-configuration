-- Code context breadcrumbs in the winbar
return {
  'SmiteshP/nvim-navic',
  enabled = require('nixCatsUtils').enableForCategory('ide-features'),
  dependencies = 'neovim/nvim-lspconfig',
  config = function()
    require('nvim-navic').setup({
      -- Icons for different symbol kinds
      icons = {
        File = ' ',
        Module = ' ',
        Namespace = ' ',
        Package = ' ',
        Class = ' ',
        Method = ' ',
        Property = ' ',
        Field = ' ',
        Constructor = ' ',
        Enum = ' ',
        Interface = ' ',
        Function = ' ',
        Variable = ' ',
        Constant = ' ',
        String = ' ',
        Number = ' ',
        Boolean = ' ',
        Array = ' ',
        Object = ' ',
        Key = ' ',
        Null = ' ',
        EnumMember = ' ',
        Struct = ' ',
        Event = ' ',
        Operator = ' ',
        TypeParameter = ' ',
      },

      -- Enable syntax highlighting
      highlight = true,

      -- Separator between symbols
      separator = ' > ',

      -- Limit the number of symbols shown
      depth_limit = 0,

      -- Limit the maximum depth shown for each type
      depth_limit_indicator = '..',

      -- Safe output - escape special characters
      safe_output = true,

      -- Automatically attach to LSP server
      lsp = {
        auto_attach = true,
        preference = nil,
      },

      -- Click support (requires nvim 0.8+)
      click = false,
    })

    -- Display navic in the winbar
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

    -- Only show winbar when navic is available
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
          vim.opt_local.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
      end,
    })
  end,
}
