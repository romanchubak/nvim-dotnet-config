return {
    "xiyaowong/transparent.nvim",
    config = function()
        require("transparent").setup({
            groups = {
                "Normal",
                "NormalNC",
                "Comment",
                "Constant",
                "Special",
                "Identifier",
                "Statement",
                "PreProc",
                "Type",
                "Underlined",
                "Todo",
                "String",
                "Function",
                "Conditional",
                "Repeat",
                "Operator",
                "Stucture",
                "LineNr",
                "NonText",
                "SignColumn",
                "CursorLine",
                "CursorLineNr",
                "StatusLine",
                "StatusLineNC",
                "EndOfBuffer",
            },
            extra_groups = {
                "NormalFloat",     -- floating windows like Telescope
                "FloatBorder",     -- borders of floating windows
                "TelescopeNormal", -- Telescope main window
                "TelescopeBorder", -- Telescope border
                "TelescopePromptNormal",
                "TelescopePromptBorder",
                "TelescopeResultsNormal",
                "TelescopeResultsBorder",
                "TelescopePreviewNormal",
                "TelescopePreviewBorder",
                "NeoTreeNormal", -- Neo-tree background
                "NeoTreeNormalNC",
                "TermNormal",    -- terminal background
                "TermNormalNC",
            },
        })
    end,
}
