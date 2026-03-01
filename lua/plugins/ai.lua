-- =============================================================================
-- AI: ThePrimeagen/99
-- =============================================================================
return {
	{
		"ThePrimeagen/99",
		keys = {
			{ "<leader>9v", mode = "v", desc = "AI: send visual selection" },
			{ "<leader>9s", mode = "v", desc = "AI: stop requests" },
		},
		config = function()
			require("99")
		end,
	},
}
