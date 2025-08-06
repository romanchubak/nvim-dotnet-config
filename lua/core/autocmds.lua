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
