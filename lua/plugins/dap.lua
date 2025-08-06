return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            local netcoredbg_adapter = {
                type = "executable",
                command = "netcoredbg",
                args = { "--interpreter=vscode" },
            }

            dap.adapters.coreclr = netcoredbg_adapter
            dap.adapters.netcoredbg = netcoredbg_adapter

            local debugRunConfiguration = {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                stopAtEntry = true, -- ← Add this
                program = function()
                    local constants = require("core.constants")
                    local project = vim.fn.getreg(constants.ProjectRegister)
                    local framework = vim.fn.getreg(constants.FrameworkRegister)
                    local pathToDll = vim.fn.getcwd()
                        .. "\\"
                        .. project
                        .. "\\bin\\Debug\\"
                        .. framework
                        .. "\\"
                        .. project
                        .. ".dll"
                    print(pathToDll)
                    return pathToDll
                end,
                exceptionBreakpoints = {},
                console = "integratedTerminal",
            }
            dap.configurations.cs = { debugRunConfiguration }

            dap.defaults.fallback.exception_breakpoints = { "raised" }
            dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
            vim.keymap.set("n", "<leader>ds", function()
                dapui.close()
                dap.terminate()
            end, { desc = "DAP: Terminate Debugging" })

            vim.keymap.set("n", "<leader>dd", function()
                local reg = vim.fn.getreg("s")

                if vim.bo.filetype == "cs" then
                    if reg == "" then
                        require("plugins.telescope.selectProject").SelectProject()
                    else
                        -- If already set, you can just start DAP
                        dap.run(debugRunConfiguration)
                    end
                end
            end, { desc = "Start debugging" })
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
            vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })

            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    -- Use a table to apply multiple mappings
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                -- Use this to override mappings for specific elements
                element_mappings = {
                    -- Example:
                    -- stacks = {
                    --   open = "<CR>",
                    --   expand = "o",
                    -- }
                },
                -- Expand lines larger than the window
                expand_lines = vim.fn.has("nvim-0.7") == 1,
                -- Layouts define sections of the screen to place windows.
                -- The position can be "left", "right", "top" or "bottom".
                -- The size specifies the height/width depending on position. It can be an Int
                -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
                -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
                -- Elements are the elements shown in the layout (in order).
                -- Layouts are opened in order so that earlier layouts take priority in window sizing.
                layouts = {
                    {
                        elements = {
                            -- Elements can be strings or table with id and size keys.
                            { id = "scopes", size = 0.25 },
                            "breakpoints",
                            "stacks",
                            "watches",
                        },
                        size = 40, -- 40 columns
                        position = "left",
                    },
                    {
                        elements = {
                            "repl",
                            "console",
                        },
                        size = 0.25, -- 25% of total lines
                        position = "bottom",
                    },
                },
                controls = {
                    -- Requires Neovim nightly (or 0.8 when released)
                    enabled = true,
                    -- Display controls in this element
                    element = "repl",
                    icons = {
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "↻",
                        terminate = "□",
                    },
                },
                floating = {
                    max_height = nil,  -- These can be integers or a float between 0 and 1.
                    max_width = nil,   -- Floats will be treated as percentage of your screen.
                    border = "single", -- Border style. Can be "single", "double" or "rounded"
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
                render = {
                    max_type_length = nil, -- Can be integer or nil.
                    max_value_lines = 100, -- Can be integer or nil.
                },
            })

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
                vim.fn.system("komorebic minimize")
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
            vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
            vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
            vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })

            vim.fn.sign_define("DapBreakpoint", {

                text = "", -- nerdfonts icon here
                -- text = '🔴', -- nerdfonts icon here
                texthl = "DapBreakpointSymbol",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            })

            vim.fn.sign_define("DapStopped", {
                text = "", -- nerdfonts icon here
                texthl = "yellow",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            })
            vim.fn.sign_define("DapBreakpointRejected", {
                text = "", -- nerdfonts icon here
                texthl = "DapStoppedSymbol",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            })
        end,
    },
}
