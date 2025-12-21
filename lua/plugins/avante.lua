return {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        -- add any opts here
        -- this file can contain specific instructions for your project
        -- for example
        provider = "copilot",
        providers = {
            copilot = {
                model = "gpt-4o", -- or gpt-4o-mini, gpt-4o-reasoning, etc.
                reasoning = { enabled = true },
            },
        },
        planning = { enabled = true },
        agent = { enabled = true },
        behaviour = {
            ---@type "popup" | "inline_buttons"
            confirmation_ui_style = "inline_buttons",
            --- Whether to automatically open files and navigate to lines when ACP agent makes edits
            ---@type boolean
            acp_follow_agent_locations = true,
        },
        instructions_file = "avante.md",
        suggestion = {
            enabled = false,
        },
    },
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false", -- for windows
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-mini/mini.pick",         -- for file_selector provider mini.pick
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",      -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
