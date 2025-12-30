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

-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--     pattern = { "*.cs", "*.csproj" },
--     callback = function()
--         if vim.bo.modified then
--             print("changes saved")
--             vim.cmd("write")
--             vim.cmd("wall")
--         end
--     end,
-- })
--
-- vim.api.nvim_create_autocmd("WinEnter", {
-- 	callback = function()
-- 		if vim.bo.filetype == "cs" and vim.bo.buftype == "" and not vim.bo.modified then
-- 			vim.cmd("edit!") -- force reload discarding unsaved changes
-- 		end
-- 	end,
-- })

-- vim.api.nvim_create_autocmd({ "WinEnter" }, {
--     pattern = { "*.cs", "*.csproj" },
--     callback = function(args)
--         -- get all roslyn clients attached to this buffer
--         local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "roslyn" })
--         if not clients or vim.tbl_isempty(clients) then
--             return
--         end
--
--         for _, client in ipairs(clients) do
--             local params = vim.lsp.util.make_text_document_params(args.buf)
--             client:request("textDocument/diagnostic", params, function(err, result, ctx, _)
--                 if err then return end
--                 if result then
--                     vim.lsp.diagnostic.on_publish_diagnostics(nil, result, { bufnr = args.buf })
--                 end
--             end, args.buf)
--         end
--     end,
-- })

vim.o.updatetime = 500
-- Show diagnostic float automatically on the current line if there's an error
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        -- Check if there are errors on the current line
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local diagnostics = vim.diagnostic.get(0, { lnum = line})

        if #diagnostics > 0 then
            vim.diagnostic.open_float()
        end
    end,
})

