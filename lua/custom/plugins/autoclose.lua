return {
    "m4xshen/autoclose.nvim",
    enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
    config = function()
        require'autoclose'.setup()
    end
}