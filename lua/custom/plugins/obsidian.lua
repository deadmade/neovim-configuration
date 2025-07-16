return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	cond = function()
		-- Check if the file is a LaTeX file or if the current directory is part of a LaTeX project
		return vim.fn.expand("%:e") == "md"
	end,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "notes",
				-- Path to your Obsidian vault.
				path = "/home/deadmade/Tinf2023-LessonSummaries",
				-- Optional, if you want to use a different file extension for your notes.
				extension = ".md",
			},
		},
		completion = {
			-- Enable completion with nvim-cmp.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},

		ui = {
			enable = false,
		},

		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
			name = "telescope.nvim",
			-- Optional, configure key mappings for the picker. These are the defaults.
			-- Not all pickers support alltrue mappings.
			note_mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
			tag_mappings = {
				-- Add tag(s) to current note.
				tag_note = "<C-x>",
				-- Insert a tag at the current location.
				insert_tag = "<C-l>",
			},
		},

		legacy_commands = false,true

		disable_frontmatter = true, -- Disable metadata frontmatter
		note_id_func = function(title)
			-- Use the title as the filename instead of generating an ID
			return title:gsub(" ", "_"):lower()
		end,
	},
}
