return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-s>"] = "select_vertical",
                        },
                        n = {
                            ["<C-s>"] = "select_vertical",
                        },
                    },
                    file_ignore_patterns = {
                        "%.git",
                        "bin",
                        "obj",
                    },
                },
                pickers = {
                    buffers = {
                        mappings = {
                            i = {},
                            n = {
                                ["dd"] = "delete_buffer",
                            },
                        },
                    },
                },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
            vim.keymap.set("n", "<leader>km", "<cmd>Telescope keymaps<CR>", { desc = "Telescope: Show keymaps" })
            vim.keymap.set("n", "<leader>gi", function()
                require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
            end, { desc = "Go To imlementations in vsplit" })
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                pickers = {
                    find_files = { theme = "ivy" },
                    buffers = { theme = "ivy" },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
            require("plugins.telescope.selectProject").setup()
            require("plugins.telescope.selectSessions").setup()
            require("plugins.telescope.searchNuget").setup()
        end,
    },
}
