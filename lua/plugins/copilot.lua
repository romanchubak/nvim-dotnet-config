return {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = false,
                auto_trigger = false,
                debounce = 75,
                keymap = {
                    accept = "<C-a>", -- Ctrl + Enter
                },
            },
            panel = { enabled = false },
            filetypes = {
                ["*"] = true,
            },
            copilot_node_command = "node", -- adapt if needed
        })
        vim.g.copilot_assume_mapped = true
    end,
}
