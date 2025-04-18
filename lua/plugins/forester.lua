return {
	"forester.nvim",
	dir = "~/.config/nvim/lua/local/forester.nvim/",
	dev = true,
	lazy = false,
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-lua/plenary.nvim" },
		{
			"echasnovski/mini.pairs",
			config = function()
				require("mini.pairs").setup()
			end,
			version = "*",
		},
	},
	-- -- maybe could be even lazier with these, but not working, because `forester` filetype is not registered yet
	-- ft = "tree",
	-- ft = "forester",
	config = function()
		-- can't run this because it treesitter might not be initialized
		-- vim.cmd.TSInstall "toml"

		-- this ensures that the treesitter is initialized, and toml is installed
		local configs = require("nvim-treesitter.configs")

		-- this ensures forester is initialized, makeing `forester` tree-sitter available
		require("forester").setup()

		-- installs the forester tree-sitter, so the syntax highlighting is available
		configs.setup({
			ensure_installed = { "toml", "forester" },
			sync_install = true,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.tree", -- Change this to match your desired file type or file pattern
			callback = function()
				if vim.bo.filetype == "forester" then -- Change "markdown" to your target filetype
					local save_cursor = vim.api.nvim_win_get_cursor(0) -- Save cursor position

					-- Get the whole buffer content
					local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					local text = table.concat(lines, "\n")

					-- Perform substitutions:
					-- Single-line replacements (if contained on one line)
					text = text:gsub("%$%$(.-)%$%$", "##{ %1 }") -- $$ x $$ -> ##{ x }
					text = text:gsub("%$(.-)%$", "#{ %1 }") -- $ x $ -> #{ x }

					-- Multi-line replacements (if spanning multiple lines)
					text = text:gsub("%$%$\n(.-)\n%$%$", "##{\n%1\n}") -- $$ x (newline) $$ -> ##{ x }
					text = text:gsub("%$\n(.-)\n%$", "#{\n%1\n}") -- $ x (newline) $ -> #{ x }

					-- Update buffer content
					vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(text, "\n"))

					-- Restore cursor position
					vim.api.nvim_win_set_cursor(0, save_cursor)
				end
			end,
		})
	end,
	keys = {
		{ "<localleader>n", "<cmd>Forester new<cr>", desc = "Forester - New" },
		{ "<localleader>b", "<cmd>Forester browse<cr>", desc = "Forester - Browse" },
		{ "<localleader>l", "<cmd>Forester link_new<cr>", desc = "Forester - Link New" },
		{ "<C-t>", "<cmd>Forester transclude_new<cr>", desc = "Forester - Transclude New" },
		{
			"<localleader>d",
			"<cmd>Forester transclude_template def<cr>",
			desc = "Forester - Transclude New Definition",
		},
		{ "<localleader>l", "<cmd>Forester transclude_template lemma<cr>", desc = "Forester - Transclude New Lemma" },
		{ "<localleader>t", "<cmd>Forester transclude_template thm<cr>", desc = "Forester - Transclude New Theorem" },
		{
			"<localleader>p",
			"<cmd>Forester transclude_template prop<cr>",
			desc = "Forester - Transclude New Proposition",
		},
		{
			"<localleader>T",
			"<cmd>Forester transclude_template_search<cr>",
			desc = "Forester - Transclude template new",
		},
	},
}
