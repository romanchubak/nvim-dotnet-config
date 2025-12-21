return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nsidorenco/neotest-vstest"
            -- "nvim-treesitter/nvim-treesitter",
            -- "Issafalcon/neotest-dotnet",
        },
        version = "5.9.0",
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-vstest")({
                        sdk_path = "C:\\Program Files\\dotnet\\sdk\\9.0.304",
                        dap_settings = {
                            type = "netcoredbg",
                        },
                        -- If multiple solutions exists the adapter will ask you to choose one.
                        -- If you have a different heuristic for choosing a solution you can provide a function here.
                        solution_selector = function(solutions)
                            return nil -- return the solution you want to use or nil to let the adapter choose.
                        end
                    }),
                    -- require("neotest-dotnet")({
                    --     -- sdk_path = "/usr/local/dotnet/sdk/9.0.101/",
                    --     dap = {
                    --         -- Extra arguments for nvim-dap configuration
                    --         -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                    --         args = { justMyCode = false },
                    --         -- Enter the name of your dap adapter, the default value is netcoredbg
                    --         adapter_name = "netcoredbg",
                    --     },
                    -- }),
                },
                log_level = "debug",
            })

            vim.keymap.set("n", "<leader>ta", function()
                require("neotest").summary.toggle()
            end, { desc = "Tests Summary" })
            -- in summary window "r" -means run
            -- in summary window "d" -means debug
            vim.keymap.set("n", "<leader>tr", function()
                require("neotest").run.run()
            end, { desc = "Test Run" })

            vim.keymap.set("n", "<leader>td", function()
                require("neotest").run.run({ strategy = "dap" })
            end, { desc = "Test Debug" })
            vim.keymap.set("n", "<leader>tf", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, { desc = "Tests Output Panel" })

            vim.keymap.set("n", "<leader>to", function()
                require("neotest").output_panel.toggle()
            end, { desc = "Tests Output Panel" })

            vim.keymap.set("n", "<leader>ts", function()
                require("neotest").run.stop()
            end, { desc = "Tests Stop" })
        end,
    },
}
