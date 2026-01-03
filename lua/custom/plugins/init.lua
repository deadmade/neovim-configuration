-- You can add your own custom.plugins. here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	--require 'custom.plugins..ltex',
	require("custom.plugins.vim-sleuth"),
	require("custom.plugins.comment"),
	require("custom.plugins.obsidian"),

	require("custom.plugins.gitsigns"),
	require("custom.plugins.conflict-marker"),
	require("custom.plugins.lualine"),
	require("custom.plugins.autoclose"),

	require("custom.plugins.which-key"),
	require("custom.plugins.telescope"),
	require("custom.plugins.lsp"),
	require("custom.plugins.autoformat"),
	require("custom.plugins.autocompletion"),
	require("custom.plugins.themes"),

	require("custom.plugins.treesitter"),
	require("custom.plugins.smalltools"),
	require("custom.plugins.vimtex"),
  	require("custom.plugins.hlchunk"), 

	-- IDE Features
	require("custom.plugins.alpha"),
	require("custom.plugins.navic"),
	require("custom.plugins.persistence"),
	require("custom.plugins.project"),
}
