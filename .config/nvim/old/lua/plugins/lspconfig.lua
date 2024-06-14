local lsp = require("lazyvim.util.lsp")

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",

		"b0o/SchemaStore.nvim",
	},
	config = function()
		require("mason").setup()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local schema_store = require("schemastore")

		local mason_registry = require("mason-registry")

		local servers = {
			jsonls = {
				settings = {
					json = {
						schemas = schema_store.json.schemas(),
						validate = { enable = true },
					},
				},
			},
			yamlls = {
				settings = {
					yaml = {
						schemaStore = { enable = false },
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			},
			tsserver = {
				enabled = false,
			},
			vtsls = {
				-- explicitly add default filetypes, so that we can extend
				-- them in related extras
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"vue",
				},
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
						globalPlugins = {
							name = "@vue/typescript-plugin",
							location = "",
							languages = { "vue" },
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
				keys = {
					{
						"gD",
						function()
							local params = vim.lsp.util.make_position_params()
							lsp.execute({
								command = "typescript.goToSourceDefinition",
								arguments = { params.textDocument.uri, params.position },
								open = true,
							})
						end,
						desc = "Goto Source Definition",
					},
					{
						"gR",
						function()
							lsp.execute({
								command = "typescript.findAllFileReferences",
								arguments = { vim.uri_from_bufnr(0) },
								open = true,
							})
						end,
						desc = "File References",
					},
					{
						"<leader>co",
						lsp.action["source.organizeImports"],
						desc = "Organize Imports",
					},
					{
						"<leader>cM",
						lsp.action["source.addMissingImports.ts"],
						desc = "Add missing imports",
					},
					{
						"<leader>cu",
						lsp.action["source.removeUnused.ts"],
						desc = "Remove unused imports",
					},
					{
						"<leader>cD",
						lsp.action["source.fixAll.ts"],
						desc = "Fix all diagnostics",
					},
					{
						"<leader>cV",
						function()
							lsp.execute({ command = "typescript.selectTypeScriptVersion" })
						end,
						desc = "Select TS workspace version",
					},
				},
			},
		}

		local vtsls_handler = function(client)
			client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
				---@type string, string, lsp.Range
				local action, uri, range = unpack(command.arguments)

				local function move(newf)
					client.request("workspace/executeCommand", {
						command = command.command,
						arguments = { action, uri, range, newf },
					})
				end

				local fname = vim.uri_to_fname(uri)
				client.request("workspace/executeCommand", {
					command = "typescript.tsserverRequest",
					arguments = {
						"getMoveToRefactoringFileSuggestions",
						{
							file = fname,
							startLine = range.start.line + 1,
							startOffset = range.start.character + 1,
							endLine = range["end"].line + 1,
							endOffset = range["end"].character + 1,
						},
					},
				}, function(_, result)
					---@type string[]
					local files = result.body.files
					table.insert(files, 1, "Enter new path...")
					vim.ui.select(files, {
						prompt = "Select move destination:",
						format_item = function(f)
							return vim.fn.fnamemodify(f, ":~:.")
						end,
					}, function(f)
						if f and f:find("^Enter new path") then
							vim.ui.input({
								prompt = "Enter move destination:",
								default = vim.fn.fnamemodify(fname, ":h") .. "/",
								completion = "file",
							}, function(newf)
								return newf and move(newf)
							end)
						elseif f then
							move(f)
						end
					end)
				end)
			end
		end

		local have_neodev, neodev = pcall(require, "neodev")
		if have_neodev then
			neodev.setup()
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		local have_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if have_cmp_nvim_lsp then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		-- TODO: maybe include only if ufo/fold support in available?
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local have_telescope_builtin, telescope_builtin = pcall(require, "telescope.builtin")

		mason_lspconfig.setup({
			ensure_installed = {
				"jsonls",
				"yamlls",
				"tsserver",
				"vtsls",
				"volar",
			},
		})
		mason_lspconfig.setup_handlers({
			function(server_name)
				if server_name == "tsserver" then
					return true
				end

				local server = servers[server_name] or {}
				lspconfig[server_name].setup({
					capabilities = capabilities,
					settings = server.settings or nil,
					filetypes = server.filetypes or nil,
					init_options = server.init_options or nil,
					on_attach = function(client, bufnr)
						if server_name == "vtsls" then
							vtsls_handler(client)
						end

						local nmap = function(keys, func, desc)
							if desc then
								desc = "LSP: " .. desc
							end

							vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
						end

						-- [[ Set Keymaps ]]
						nmap("K", vim.lsp.buf.hover, "Hover Documentation")
						nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
						nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
						nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
						nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
						nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
						nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
						nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

						if have_telescope_builtin then
							nmap("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
							nmap("<leader>ds", telescope_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
							nmap("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
						end
					end,
				})
			end,
		})
	end,
}
