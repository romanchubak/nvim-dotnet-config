return {
	"akinsho/toggleterm.nvim",
	-- event = "VeryLazy",
	-- cmd = "ToggleTerm",
	keys = {

		{ "<leader>tt", "<cmd>:1ToggleTerm direction=float<CR>", mode = { "n", "t" } },
		{ "<leader>ttd", "<cmd>:2ToggleTerm direction=horizontal size=20<CR>", mode = { "n", "t" } },
		{ "<leader>ttr", "<cmd>:3ToggleTerm direction=vertical size=100<CR>", mode = { "n", "t" } },
		{ "<leader>ttf", "<cmd>:4ToggleTerm direction=float<CR>", mode = { "n", "t" } },
		{ "<leader>fr", function() end, mode = { "n", "t" } },
		{ "<leader>db", function() end, mode = { "n", "t" } },
	},
	version = "*",
	config = function()
		require("toggleterm").setup({

			start_in_insert = true,
			terminal_mappings = true,
			-- direction = 'float',
			shell = "pwsh.exe -NoLogo -NoProfile",
			auto_scroll = true,
			-- persist_mode = true,
			persist_size = true,
			close_on_exit = true,
		})
		-- function _lazygit_toggle()
		-- local Terminal = require('toggleterm.terminal').Terminal
		-- local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })
		-- lazygit:toggle()
		-- end
		vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { noremap = true })
		-- vim.keymap.set({ 'n', 't' }, '<leader>gl', function() _lazygit_toggle() end)
		-- vim.keymap.set({ "n", "t" }, "<leader>gl", function()
		-- 	local terminal = require("toggleterm.terminal").Terminal
		-- 	local lazygit = terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
		-- 	lazygit:toggle()
		-- end, { desc = "LazyGit" })
		--
		-- vim.keymap.set({ "n", "t" }, "<leader>fr", function()
		-- 	local terminal = require("toggleterm.terminal").Terminal
		-- 	local scooter = terminal:new({ cmd = "scooter", hidden = true, direction = "float" })
		-- 	scooter:toggle()
		-- end, { desc = "Find and Replace" })
		vim.keymap.set({ "n", "t" }, "<leader>db", function()
			local terminal = require("toggleterm.terminal").Terminal
			local reg = vim.fn.getreg("s")

			if reg ~= "" then
				local dotnetbuild = terminal:new({
					hidden = true,
					direction = "horizontal",
					on_open = function(term)
						vim.api.nvim_chan_send(term.job_id, "dotnet build " .. reg)
					end,
					shell = "pwsh.exe -NoLogo -NoProfile",
				})
				dotnetbuild:toggle()
			else
				require("plugins.telescope.selectProject").SelectProject()
			end
		end, { desc = "Build Project" })
	end,
}
