return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({
					async = true,
				})
				vim.cmd("Sleuth")
			end,
			mode = { "n", "v" },
			desc = "Format",
		},
		{
			"<leader>cf",
			function()
				require("conform").format({ formatters = { "injected" } })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
		{
			"<leader>cc",
			function()
				require("conform").format({
					formatters = { "prettier" },
					timeout_ms = 5000,
				})
			end,
			mode = { "n", "v" },
			desc = "format with prettier",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			luau = { "stylua" },

			sh = { "shfmt" },

			sql = { "sql_formatter" },

			css = { { "dprint", "prettierd", "prettier" } },
			html = { { "dprint", "prettierd", "prettier" }, "rustywind" },

			json = { { "dprint", "biome", "prettierd", "prettier" } },
			jsonc = { { "dprint", "biome", "prettierd", "prettier" } },
			javascript = { { "dprint", "biome", "prettierd", "prettier" }, "rustywind" },
			javascriptreact = { { "dprint", "biome", "prettierd", "prettier" }, "rustywind" },
			typescript = { { "dprint", "biome", "prettierd", "prettier" }, "rustywind" },
			typescriptreact = { { "dprint", "biome", "prettierd", "prettier" }, "rustywind" },

			svelte = { { "dprint", "prettierd", "prettier" }, "rustywind" },
			vue = { { "biome", "dprint", "prettierd", "prettier" }, "rustywind" },

			yaml = { { "dprint", "prettierd", "prettier" } },

			toml = { "taplo" },

			rust = { "rustfmt" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = false,
		},
		---@type table<string,table>
		formatters = {
			injected = {
				options = { ignore_errors = false },
			},
			sql_formatter = {
				args = {
					"--config",
					vim.fs.joinpath(vim.fn.stdpath("config"), "config/formatters/sql-formatter.json"),
				},
			},
			dprint = {
				condition = function(ctx)
					return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
				end,
			},
			biome = {
				condition = function(ctx)
					return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
				end,
			},
			rustywind = {
				condition = function(ctx)
					return vim.fs.find({ vim.fn.glob("tailwind.config.*") }, { path = ctx.filename, upward = true })[1]
				end,
			},
		},
	},
	config = function(_, opts)
		opts.formatters = opts.formatters or {}
		for name, formatter in pairs(opts.formatters) do
			if type(formatter) == "table" then
				local ok, defaults = pcall(require, "conform.formatters." .. name)
				if ok and type(defaults) == "table" then
					opts.formatters[name] = vim.tbl_deep_extend("force", {}, defaults, formatter)
				end
			end
		end

		require("conform").setup(opts)
	end,
}
