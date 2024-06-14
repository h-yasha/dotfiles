-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Package Manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- [[ Color Scheme ]]
-- vim.o.background = "light" -- or 'dark'
vim.cmd.colorscheme("tokyonight")

-- [[ Setting options ]]
vim.o.hlsearch = false
vim.wo.number = true
vim.opt.scrolloff = 8
vim.o.breakindent = true

vim.o.mouse = "a"

vim.o.clipboard = "unnamedplus"
vim.o.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim.undodir"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = "yes"
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true
vim.o.termbidi = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.g.tabstop = 4
vim.o.tabstop = 4

-- [[ Basic Keymaps ]]
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line(s) down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line(s) up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Move to next match and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Move to previous match and center" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Signs ]]
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
