return {
    "m4xshen/autoclose.nvim",
    enabled = require('nixCatsUtils').enableForCategory("general"),
    config = function()
        require'autoclose'.setup()
    end
}