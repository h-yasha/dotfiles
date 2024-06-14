return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "vim", "vimdoc" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
				},
			},
		})

		require("treesitter-context").setup({
			max_lines = 5,
		})
	end,
}
