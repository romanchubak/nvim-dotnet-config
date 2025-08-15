local function augroup(name)
	return vim.api.nvim_create_augroup("rchubak_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = { "*.cs", "*.csproj" },
	callback = function()
		if vim.bo.modified then
			print("changes saved")
			vim.cmd("write")
			vim.cmd("wall")
		end
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	callback = function()
		if vim.bo.filetype == "cs" and vim.bo.buftype == "" and not vim.bo.modified then
			vim.cmd("edit!") -- force reload discarding unsaved changes
		end
	end,
})

vim.o.updatetime = 300
-- Show diagnostic float automatically on the current line if there's an error
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local opts = {
			severity = vim.diagnostic.severity.ERROR, -- only errors
			focusable = false, -- don't focus the float
		}
		-- Check if there are errors on the current line
		local line = vim.api.nvim_win_get_cursor(0)[1] - 1
		local diagnostics = vim.diagnostic.get(0, { lnum = line, severity = vim.diagnostic.severity.ERROR })

		if #diagnostics > 0 then
			vim.diagnostic.open_float()
		end
	end,
})
