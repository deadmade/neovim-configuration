require("nixCatsUtils").setup({
	non_nix_value = true,
})

require("general.set")
require("general.keymaps")
require("general.autocommands")

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
	if require("nixCatsUtils").isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
		return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
	else
		return vim.fn.stdpath("config") .. "/lazy-lock.json"
	end
end
local lazyOptions = {
	lockfile = getlockfilepath(),
	-- nix supplies every plugin, so lazy never needs to build luarocks packages
	rocks = { enabled = false },
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
}

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
-- NOTE: nixCats: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), {
	{ import = "custom.plugins" },
}, lazyOptions)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
