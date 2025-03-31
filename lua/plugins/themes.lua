return {
  "zaldih/themery.nvim",
  lazy = false,
  config = function()
    require("themery").setup({
      themes = { "tokyonight", "gruvbox", "ayu", "catppuccin", "kanagawa-lotus", "kanagawa-dragon"}, -- Your list of installed colorschemes.
      livePreview = true }) -- Apply theme while picking. Default to true.    
  end
}