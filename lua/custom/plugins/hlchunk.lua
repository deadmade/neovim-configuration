return {
	"shellRaining/hlchunk.nvim",
	enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				-- ...
			},
			indent = {
				enable = true,
				-- ...
			},
		})
	end,
}
