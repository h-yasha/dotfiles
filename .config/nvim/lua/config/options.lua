-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.clipboard = "unnamedplus"

vim.opt.scrolloff = 8

vim.wo.signcolumn = "yes"
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.g.tabstop = 4
vim.o.tabstop = 4

-- vim.o.completeopt = "menuone,noselect"

vim.o.termbidi = true

-- Yank with WSL
local clip = "/mnt/c/Windows/System32/clip.exe"

if vim.fn.executable(clip) then
  local opts = {
    callback = function()
      if vim.v.event.operator ~= "y" then
        return
      end
      vim.fn.system(clip, vim.fn.getreg(0))
    end,
  }

  opts.group = vim.api.nvim_create_augroup("WSLYank", {})
  vim.api.nvim_create_autocmd("TextYankPost", { group = opts.group, callback = opts.callback })
end
