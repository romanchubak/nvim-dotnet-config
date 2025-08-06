return {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup({
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            auto_restore = true,
            keys = {
                -- Will use Telescope if installed or a vim.ui.select picker otherwise
                --{ "<leader>ls", "<cmd>SessionSearch<CR>", desc = "Session search" },
                --{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
                --{ "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
            },
            opts = {
                session_lens = {
                    mappings = {
                        delete_session = { "i", "<C-D>" },
                        alternate_session = { "i", "<C-S>" },
                        copy_session = { "i", "<C-Y>" },
                    },

                    picker_opts = {
                        border = true,
                        layout_config = {
                            width = 0.8, -- Can set width and height as percent of window
                            height = 0.5,
                        },
                    },

                    load_on_setup = true,
                },
            },
            save_extra_cmds = {
                function()
                    local constants = require("core.constants")
                    local project = vim.fn.getreg(constants.ProjectRegister)
                    local framework = vim.fn.getreg(constants.FrameworkRegister)
                    vim.fn.setreg(constants.ProjectRegister, "")
                    vim.fn.setreg(constants.FrameworkRegister, "")
                    local restoreProject = "lua vim.fn.setreg('"
                        .. constants.ProjectRegister
                        .. "','"
                        .. project
                        .. "')"
                    local restoreFramework = "lua vim.fn.setreg('"
                        .. constants.FrameworkRegister
                        .. "','"
                        .. framework
                        .. "')"

                    return {
                        restoreProject,
                        restoreFramework,
                    }
                end,
            },
            pre_save_cmds = {
                function()
                    -- close decompiled or invalid buffers
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        local name = vim.api.nvim_buf_get_name(buf)
                        if name:match("%$metadata%$") and not vim.loop.fs_stat(name) then
                            vim.api.nvim_buf_delete(buf, { force = true })
                        end
                    end
                end,
            },
        })
        --vim.keymap.set("n", "<leader>ls", "<cmd>SessionSearch<CR>", { desc = "Session search" })
    end,
}
