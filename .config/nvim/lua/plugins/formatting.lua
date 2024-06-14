return {
  "conform.nvim",
  dependencies = {
    "LazyVim/LazyVim",
  },
  opts = {
    formatters_by_ft = {
      json = { { "biome", "prettierd", "prettier" } },
      jsonc = { { "biome", "prettierd", "prettier" } },
      javascript = { { "biome", "prettierd", "prettier" }, "rustywind" },
      javascriptreact = { { "biome", "prettierd", "prettier" }, "rustywind" },
      typescript = { { "biome", "prettierd", "prettier" }, "rustywind" },
      typescriptreact = { { "biome", "prettierd", "prettier" }, "rustywind" },

      vue = { { "prettierd", "prettier" }, "rustywind" },
    },
  },
}
