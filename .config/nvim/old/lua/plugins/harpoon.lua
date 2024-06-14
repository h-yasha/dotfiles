return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local have_telescope, telescope = pcall(require, "telescope")
		if have_telescope then
			telescope.load_extension("harpoon")
		end

		vim.keymap.set("n", "<leader>H", require("harpoon.mark").add_file, { desc = "Harpoon This" })
		vim.keymap.set("n", "<leader>h", require("harpoon.ui").toggle_quick_menu, { desc = "Open [H]arpoon Menu" })

		vim.keymap.set("n", "<a-->", require("harpoon.ui").nav_prev, { desc = "Harpoon Previous" })
		vim.keymap.set("n", "<a-=>", require("harpoon.ui").nav_next, { desc = "Harpoon Next" })

		vim.keymap.set("n", "<a-1>", function()
			require("harpoon.ui").nav_file(1)
		end)
		vim.keymap.set("n", "<a-2>", function()
			require("harpoon.ui").nav_file(2)
		end)
		vim.keymap.set("n", "<a-3>", function()
			require("harpoon.ui").nav_file(3)
		end)
		vim.keymap.set("n", "<a-4>", function()
			require("harpoon.ui").nav_file(4)
		end)
		vim.keymap.set("n", "<a-5>", function()
			require("harpoon.ui").nav_file(5)
		end)
		vim.keymap.set("n", "<a-6>", function()
			require("harpoon.ui").nav_file(6)
		end)
	end,
}
