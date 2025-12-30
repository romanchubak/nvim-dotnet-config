return {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",  -- required
        "sindrets/diffview.nvim", -- optional - Diff integration

        -- Only one of these is needed.
        "ibhagwan/fzf-lua",    -- optional
        "nvim-mini/mini.pick", -- optional
        "folke/snacks.nvim",
    },
    cmd = "Neogit",
    keys = {
        { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
        { "<leader>gl", "<cmd>Neogit Log<cr>", desc = "Show Neogit Log" },
        { "<leader>df", "<cmd>DiffviewOpen<cr>", desc = "Show Diff View" },
    }
}
