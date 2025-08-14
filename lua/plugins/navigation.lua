return {
	{
		"folke/flash.nvim",
		-- event = "VeryLazy",
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "<leader>s", mode = { "n", "x", "o" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter" },
		},
	}
}
