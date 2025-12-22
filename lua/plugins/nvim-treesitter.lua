return {
	"Corn207/ts-query-loader.nvim",
	version = "*", -- Choose latest stable version
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		ensure_installed = {
			"lua",
			"javascript",
			"html",
			"c_sharp",
			"bicep"
		},
	},
}
