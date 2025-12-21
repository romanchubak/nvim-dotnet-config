return {
    {
        "catppuccin/nvim",
        enabled = false,
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    {
        "folke/tokyonight.nvim",
        enabled = true,
        priority = 1000,
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent", -- nvim-tree, neo-tree, help, etc.
                floats   = "transparent", -- floating windows, LSP popups, telescope
            },
            on_highlights = function(h, c)
                -- core UI
                h.Normal                 = { fg = h.Normal.fg, bg = "none" }
                h.NormalNC               = { fg = h.NormalNC and h.NormalNC.fg or h.Normal.fg, bg = "none" }
                h.SignColumn             = { bg = "none" }
                h.LineNr                 = { bg = "none" }
                h.CursorLine             = { bg = "none" }
                h.CursorLineNr           = { bg = "none", bold = true }
                h.Folded                 = { bg = "none" }
                h.StatusLine             = { bg = "none" }
                h.StatusLineNC           = { bg = "none" }
                h.TabLine                = { bg = "none" }
                h.TabLineFill            = { bg = "none" }
                h.TabLineSel             = { bg = "none" }
                h.VertSplit              = { bg = "none" }
                h.EndOfBuffer            = { bg = "none" }

                -- popups & menus
                h.NormalFloat            = { bg = "none" }
                h.FloatBorder            = { bg = "none" }
                -- h.Pmenu                  = { bg = "none" }
                -- h.PmenuSel               = { bg = "none" }
                -- h.PmenuSbar              = { bg = "none" }
                -- h.PmenuThumb             = { bg = "none" }

                -- telescope (if you use it)
                h.TelescopeNormal        = { bg = "none" }
                h.TelescopeBorder        = { bg = "none" }
                h.TelescopePromptNormal  = { bg = "none" }
                h.TelescopePromptBorder  = { bg = "none" }
                h.TelescopeResultsNormal = { bg = "none" }
                h.TelescopeResultsBorder = { bg = "none" }

                -- which-key / noice / lazy UI (optional, comment out if not installed)
                h.WhichKeyFloat          = { bg = "none" }
                h.NoiceCmdlinePopup      = { bg = "none" }
                h.LazyNormal             = { bg = "none" }
                h.MasonNormal            = { bg = "none" }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
            -- optional: make floating windows slightly translucent via winblend
            vim.o.winblend = 0 -- set 10–20 for subtle translucency
            vim.o.pumblend = 0
        end,
    },
}
