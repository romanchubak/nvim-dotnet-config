return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				padding = true,
				sticky = true,
				ignore = nil,
				toggler = { line = "<leader>/", block = "gbc" },
				opleader = { line = "<leader>/", block = "gb" },
				extra = { above = "gcO", below = "gco", eol = "gcA" },
				mappings = { basic = true, extra = false },
				pre_hook = nil,
				post_hook = nil,
			})
			local ft = require("Comment.ft")
			ft
				-- Set only line comment
				.set("lua", "-- %s")
			-- Or set both line and block commentstring
			--                .set("javascript", { "//%s", "/*%s*/" })
		end,
	},
}
