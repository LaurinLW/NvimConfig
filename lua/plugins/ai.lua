-- =============================================================================
-- AI: ThePrimeagen/99
-- =============================================================================
return {
	{
		"ThePrimeagen/99",
		config = function()
			local _99 = require("99")
			_99.setup({
				provider = _99.Providers.OpenCodeProvider,
				model = "opencode/minimax-m2.5-free",
				logger = {
					level = _99.DEBUG,
					path = "/tmp/99.nvim.debug",
					print_on_error = true,
				},
			})
			vim.keymap.set("v", "<leader>9v", function()
				_99.visual()
			end)
			vim.keymap.set("n", "<leader>9l", function()
				_99.view_logs()
			end)
		end,
	},
}
