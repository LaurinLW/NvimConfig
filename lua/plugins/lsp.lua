-- =============================================================================
-- LSP: nvim-lspconfig + mason + mason-lspconfig + fidget + blink.cmp
--      Language servers: lua, html, css, angular, graphql, typescript,
--                        python (basedpyright, ruff), c/c++ (clangd)
-- =============================================================================
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			-- blink.cmp provides extra LSP capabilities
			"saghen/blink.cmp",
		},
		config = function()
			-- -----------------------------------------------------------------------
			-- On-attach: buffer-local LSP keymaps
			-- -----------------------------------------------------------------------
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- These override the global ones set in init.lua and use Telescope
					-- pickers (set in telescope.lua's LspAttach autocmd).
					-- Additional bindings not covered by telescope:
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")

					map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd folder")
					map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove folder")
					map("<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[W]orkspace [L]ist folders")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(e)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = e.buf })
							end,
						})
					end

					-- Inlay hints toggle
					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- -----------------------------------------------------------------------
			-- Extra capabilities from blink.cmp
			-- -----------------------------------------------------------------------
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- -----------------------------------------------------------------------
			-- Server configurations
			-- -----------------------------------------------------------------------
			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

			local servers = {
				lua_ls = {
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
							then
								return
							end
						end
						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
						})
					end,
					settings = { Lua = {} },
				},

				html = {},
				cssls = {},
				graphql = {},
				angularls = {},
				ts_ls = {},

				-- ESLint LSP: diagnostics + code actions for JS/TS (replaces none-ls eslint_d)
				eslint = {
					filetypes = {
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
					},
					settings = {
						format = false, -- prettier handles formatting
					},
					on_attach = function(_, bufnr)
						-- Auto-fix on save
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
				},

				basedpyright = {
					settings = {
			-- Ruff: fast Python linter + formatter as LSP (diagnostics, code actions, import sort)
			ruff = {},

			basedpyright = {
							analysis = {
								typeCheckingMode = "basic",
								reportMissingTypeStubs = false,
								diagnosticMode = "workspace",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				},

				clangd = {
					cmd = {
						mason_bin .. "/clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--pch-storage=memory",
					},
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern(
							"compile_commands.json",
							".clangd",
							"CMakeLists.txt",
							"Makefile",
							".git"
						)(fname)
					end,
				},
			}

			-- -----------------------------------------------------------------------
			-- Mason: ensure tools are installed
			-- -----------------------------------------------------------------------
			local ensure_installed = {
				-- LSP servers
				"lua-language-server",
				"html-lsp",
				"css-lsp",
				"graphql-language-service-cli",
				"angular-language-server",
				"typescript-language-server",
				"basedpyright",
				"clangd",
				-- Formatters / linters (used by formatting.lua)
				"prettier",
				"black",
				"ruff",
				"stylua",
				"clang-format",
				"eslint-lsp",
			}

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- -----------------------------------------------------------------------
			-- Enable servers via nvim-lspconfig
			-- -----------------------------------------------------------------------
			for name, config in pairs(servers) do
				config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end
		end,
	},

	-- Completion engine: blink.cmp with LuaSnip + friendly-snippets
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
		},
		opts = {
			keymap = {
				preset = "default",
				-- keep familiar C-p/C-n
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-d>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 300 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},
}
