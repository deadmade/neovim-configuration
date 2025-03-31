return {
  "zaldih/themery.nvim",
  lazy = false,
  config = function()
    require("themery").setup({
      themes = {{
        name = "Day",
        colorscheme = "kanagawa-lotus",
      },
      {
        name = "Night",
        colorscheme = "kanagawa-dragon",
      }},
    })
  end
}