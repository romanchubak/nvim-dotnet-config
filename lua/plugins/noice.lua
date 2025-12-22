return {
	"folke/noice.nvim",
	event = "VeryLazy",
	enabled = true,
	opts = {
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = false,        -- use a classic bottom cmdline for search
			command_palette = true,       -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = true,            -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true,        -- add a border to hover docs and signature help
		},
		messages = {
			enabled = false,
		},
		-- Notify style
		notify = {
			enabled = false,
		},
		lsp = {
			progress = {
				enabled = false,
			},
			override = {},
			hover = {
				enabled = false,
			},
			signature = {
				enabled = false,
			},
			message = {
				-- Messages shown by lsp servers
				enabled = false,
				view = "notify",
				opts = {},
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
	},
}
