vim.keymap.set('n', '<leader>ss', ':nohlsearch<CR>')


vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split", silent = true  })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split", silent = true  })
vim.keymap.set("n", "<C-c>", "<C-w>c", { desc = "Close split" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("x", "<leader>p", "\"_dP", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>p", "\"_dP", { noremap = true, silent = true })


vim.keymap.set({ 'n', 't' }, '<C-A-h>', ':vertical res +2^M<CR>', { desc = "Resize split to left", silent = true })
vim.keymap.set({ 'n', 't' }, '<C-A-l>', ':vertical res -2^M<CR>', { desc = "Resize split to right", silent = true })
vim.keymap.set({ 'n', 't' }, '<C-A-k>', ':resize -2<CR>', { desc = "Resize split to up", silent = true })
vim.keymap.set({ 'n', 't' }, '<C-A-j>', ':resize +2<CR>', { desc = "Resize split to down", silent = true })

--Ctrl-o — Go back in jump list
--Ctrl-i — Go forwardvim.keymap.set("x", "<leader>p", "\"_dP")


-- quickfix
vim.keymap.set('n', 'qn', '<cmd>cnext<CR>', { desc = "Quickfix next", silent = true })
vim.keymap.set('n', 'qp', '<cmd>cprev<CR>', { desc = "Quickfix prev", silent = true })
