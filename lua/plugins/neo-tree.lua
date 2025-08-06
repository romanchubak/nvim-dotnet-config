return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended
	},
	lazy = false, -- neo-tree will lazily load itself
	config = function()
		require("neo-tree").setup({
		})
		vim.keymap.set("n", "<leader>xf", ":Neotree filesystem reveal float toggle=true<CR>")
		vim.keymap.set("n", "<leader>xx", ":Neotree filesystem reveal left toggle=true<CR>")
		vim.keymap.set("n", "<leader>vf", ":Neotree float git_status toggle=true<CR>")
	end,
}
