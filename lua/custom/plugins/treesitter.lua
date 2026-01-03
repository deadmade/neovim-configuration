return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
	event = { "BufReadPre", "BufNewFile" }, -- Load only when opening a file
	build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
	opts = {
		-- NOTE: nixCats: use lazyAdd to only set these 2 options if nix wasnt involved.
		-- because nix already ensured they were installed.
		-- NOTE: Nix provides ALL grammars via withAllGrammars in categories.nix
		-- Non-Nix users get auto-install enabled for on-demand grammar installation
		ensure_installed = require("nixCatsUtils").lazyAdd({}),
		auto_install = require("nixCatsUtils").lazyAdd(true, false),

		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
			disable = { "latex" }, -- Remove this if you want to use vim regex highlighting for Ruby
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	config = function(_, opts)
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		-- Note: With the new nvim-treesitter API, prefer_git is no longer needed
		-- Nix handles all parser installation, so this setting is not applicable
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter").setup(opts)

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}

