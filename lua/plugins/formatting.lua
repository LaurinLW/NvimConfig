-- =============================================================================
-- Formatting & linting:
--   conform.nvim  — format-on-save (prettier, ruff, stylua, clang-format)
--   ESLint runs as a proper LSP server via eslint-lsp (configured in lsp.lua)
-- =============================================================================
return {

	-- Primary formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,

			-- Format on save for all supported types
			format_on_save = function(bufnr)
				local disable_ft = {}
				if disable_ft[vim.bo[bufnr].filetype] then
					return nil
				end
				return { timeout_ms = 2000, lsp_format = "fallback" }
			end,

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				htmlangular = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				yaml = { "prettier" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},

			formatters = {
				["clang-format"] = {
					prepend_args = { "--style=file", "--fallback-style=LLVM" },
				},
			},
		},
	},
}
