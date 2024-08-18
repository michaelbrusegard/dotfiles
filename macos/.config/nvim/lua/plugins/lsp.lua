return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = {
			-- Options for vim.diagnostic.config()
			diagnostic = {
				underline = true,
				update_in_insert = false,
				virtual_text = false,
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				virtual_lines = {
					only_current_line = true,
					highlight_whole_line = false,
				},
			},
			-- Add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
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
							tsserver = {
								globalPlugins = {
									{
										name = "@angular/language-server",
										location = require("util.lazy").get_pkg_path(
											"angular-language-server",
											"/node_modules/@angular/language-server"
										),
										enableForWorkspaceTypeScriptVersions = false,
									},
									{
										name = "@vue/typescript-plugin",
										location = require("util.lazy").get_pkg_path(
											"vue-language-server",
											"/node_modules/@vue/language-server"
										),
										languages = { "vue" },
										configNamespace = "typescript",
										enableForWorkspaceTypeScriptVersions = true,
									},
								},
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
				},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
					},
				},
				biome = {},
				tailwindcss = {
					filetypes_exclude = { "markdown" },
					filetypes_include = {},
				},
				angularls = {},
				volar = {
					init_options = {
						vue = {
							hybridMode = true,
						},
					},
				},
				dockerls = {},
				docker_compose_language_service = {},
				jdtls = {},
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				kotlin_language_server = {},
				omnisharp = {
					handlers = {
						["textDocument/definition"] = function(...)
							return require("omnisharp_extended").handler(...)
						end,
					},
					enable_roslyn_analyzers = true,
					organize_imports_on_format = true,
					enable_import_completion = true,
				},
				ruff = {
					cmd_env = { RUFF_TRACE = "messages" },
					init_options = {
						settings = {
							logLevel = "error",
						},
					},
				},
				basedpyright = {},
				taplo = {},
				texlab = {},
			},
			setup = {
				vtsls = function(_, opts)
					require("util.lsp").on_attach(function(client)
						client.commands["_typescript.moveToFileRefactoring"] = function(command)
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
					end, "vtsls")
					-- copy typescript settings to javascript
					opts.settings.javascript =
						vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
				end,
				tailwindcss = function(_, opts)
					local tw = require("lspconfig.server_configurations.tailwindcss")
					opts.filetypes = opts.filetypes or {}

					-- Add default filetypes
					vim.list_extend(opts.filetypes, tw.default_config.filetypes)

					-- Remove excluded filetypes
					opts.filetypes = vim.tbl_filter(function(ft)
						return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
					end, opts.filetypes)

					-- Additional settings for Phoenix projects
					opts.settings = {
						tailwindCSS = {
							includeLanguages = {
								elixir = "html-eex",
								eelixir = "html-eex",
								heex = "html-eex",
							},
						},
					}
					vim.list_extend(opts.filetypes, opts.filetypes_include or {})
				end,
				angularls = function()
					require("util.lsp").on_attach(function(client)
						client.server_capabilities.renameProvider = false
					end, "angularls")
				end,
				ruff = function()
					require("util.lsp").on_attach(function(client, _)
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end, "ruff")
				end,
			},
		},
		-- stylua: ignore
		config = function(_, opts)
			vim.diagnostic.config(opts.diagnostic)
			require("lspconfig.ui.windows").default_options.border = "rounded"

      require("util.lsp").on_attach(function(client, buffer)
					if client and client.supports_method("textDocument/inlayHint", { bufnr = buffer }) then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end

					if client and client.supports_method("textDocument/codeLens", { bufnr = buffer }) then
						vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
							buffer = buffer,
							callback = vim.lsp.codelens.refresh,
						})
					end

					vim.keymap.set("n", "<leader>ci", function() if vim.g.float_open then return end vim.g.float_open = true vim.cmd("LspInfo") end, { desc = "Lsp Info", buffer = buffer, silent = true })
					vim.keymap.set( "n", "gd", "<cmd>lua require('util.navigation').pick('lsp_definitions', { jump_to_single_result = true, ignore_current_line = true })<cr>", { desc = "Goto Definition", buffer = buffer, silent = true })
					vim.keymap.set( "n", "gr", "<cmd>lua require('util.navigation').pick('lsp_references', { jump_to_single_result = true, ignore_current_line = true })<cr>", { desc = "References", buffer = buffer, silent = true })
					vim.keymap.set( "n", "gI", "<cmd>lua require('util.navigation').pick('lsp_implementations', { jump_to_single_result = true, ignore_current_line = true })<cr>", { desc = "Goto Implementation", buffer = buffer, silent = true })
					vim.keymap.set( "n", "gy", "<cmd>lua require('util.navigation').pick('lsp_typedefs', { jump_to_single_result = true, ignore_current_line = true })<cr>", { desc = "Goto T[y]pe Definition", buffer = buffer, silent = true })
					vim.keymap.set( "n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration", buffer = buffer, silent = true })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = buffer, silent = true })
					vim.keymap.set( "n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = buffer, silent = true })
					vim.keymap.set( "i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = buffer, silent = true })
					vim.keymap.set( { "n", "x" }, "crr", vim.lsp.buf.code_action, { desc = "Code Action", buffer = buffer, silent = true })
					vim.keymap.set("n", "crn", "<cmd>lua require('live-rename').rename()<cr>", { desc = "Rename", buffer = buffer, silent = true })
					vim.keymap.set( { "n", "x" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens", buffer = buffer, silent = true })
					vim.keymap.set( "n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens", buffer = buffer, silent = true })
				end)

			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities(),
				opts.capabilities
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, opts.servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- Get all the servers that are available through mason-lspconfig
			local ensure_installed = {}
			for server, server_opts in pairs(opts.servers) do
				if server_opts then
					ensure_installed[#ensure_installed + 1] = server
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_deep_extend(
          "force",
          ensure_installed,
          require('util.lazy').opts("mason-lspconfig.nvim").ensure_installed or {}
				),
				handlers = { setup },
			})
		end,
	},
	-- Cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ui = {
				width = 0.85,
				height = 0.85,
				border = "rounded",
				icons = {
					package_installed = "●",
					package_pending = "➜",
					package_uninstalled = "○",
				},
				keymaps = {
					uninstall_package = "x",
					toggle_help = "?",
				},
			},

			ensure_installed = {
				"stylua",
				"shfmt",
				"black",
				"prettierd",
				"js-debug-adapter",
				"hadolint",
				"java-debug-adapter",
				"java-test",
				"ktlint",
				"markdownlint-cli2",
				"csharpier",
				"netcoredbg",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false,
	},
	{ "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
}
