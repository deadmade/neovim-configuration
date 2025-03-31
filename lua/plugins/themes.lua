return {
  "zaldih/themery.nvim",
  lazy = false,
  config = function()
    require("themery").setup({
      themes = {"gruvbox", "ayu", "tokyonight", "catppuccin"}, -- Your list of installed colorschemes.
      livePreview = true }) -- Apply theme while picking. Default to true.    
  end
}