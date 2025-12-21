return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            local utils = require('dap.utils')
            local rpc = require('dap.rpc')

            local function send_payload(client, payload)
                local msg = rpc.msg_with_content_length(vim.json.encode(payload))
                client.write(msg)
            end
            function RunHandshake(self, request_payload)
                local signResult = io.popen('node "path to the nvim config"\\nvim\\lua\\plugins\\sign.js ' ..
                    request_payload.arguments.value)
                if signResult == nil then
                    utils.notify('error while signing handshake', vim.log.levels.ERROR)
                    return
                end
                local signature = signResult:read("*a")
                signature = string.gsub(signature, '\n', '')
                local response = {
                    type = "response",
                    seq = 0,
                    command = "handshake",
                    request_seq = request_payload.seq,
                    success = true,
                    body = {
                        signature = signature
                    }
                }
                send_payload(self.client, response)
            end

            local function get_launch_settings()
                local projectName = vim.fn.getreg("s")
                if projectName ~= "" and not string.find(projectName:lower(), "test") then
                    local startUpProjectPath = vim.fn.getcwd() .. "\\" .. projectName
                    local constants = require("core.constants")
                    local project = vim.fn.getreg(constants.ProjectRegister)
                    local framework = vim.fn.getreg(constants.FrameworkRegister)
                    local cwd = vim.fn.getcwd()
                        .. "\\"
                        .. project
                        .. "\\bin\\Debug\\"
                        .. framework
                        .. "\\"


                    local file = startUpProjectPath .. "\\Properties\\launchSettings.json"
                    if vim.fn.filereadable(file) == 0 then
                        return { cwd = startUpProjectPath, env = {} }
                    end

                    -- vim.notify(file, vim.log.levels.INFO)

                    local data = vim.fn.json_decode(table.concat(vim.fn.readfile(file), "\n"))

                    -- vim.notify(vim.inspect(data), vim.log.levels.INFO)
                    local profiles = data.profiles or {}

                    -- Find the first profile with commandName == "Project"
                    local profile
                    for name, p in pairs(profiles) do
                        if p.commandName == "Project" then
                            profile = p
                            break
                        end
                    end

                    -- If no profile found, fallback to first available
                    if not profile then
                        local first_name = next(profiles)
                        profile = profiles[first_name] or {}
                    end

                    local env_vars = profile.environmentVariables or {}
                    if profile.applicationUrl then
                        env_vars["ASPNETCORE_URLS"] = profile.applicationUrl
                    end

                    return {
                        cwd = cwd,
                        env = env_vars,
                    }
                end
            end

            local dap = require("dap")
            local dapui = require("dapui")
            require("nvim-dap-virtual-text").setup()

            local netcoredbg_adapter = {
                type = "executable",
                command = "netcoredbg",
                args = { "--interpreter=vscode", '--engineLogging=1' },
            }

            -- dap.adapters.coreclr = netcoredbg_adapter
            dap.adapters.netcoredbg = netcoredbg_adapter
            local vsdbg_adapter = {
                id = 'coreclr',
                type = 'executable',
                command =
                "user dicrectory\\.vscode\\extensions\\ms-dotnettools.csharp-2.110.4-win32-x64\\.debugger\\x86_64\\vsdbg.exe", -- Note: Please include the actual path!
                args = {
                    "--interpreter=vscode",
                    -- "--engineLogging",
                    -- "--consoleLogging",
                },
                options = {
                    externalTerminal = true,
                },
                runInTerminal = true,
                reverse_request_handlers = {
                    handshake = RunHandshake,
                },
            }

            dap.adapters.coreclr = vsdbg_adapter
            -- dap.adapters.netcoredbg = vsdbg_adapter
            local vsdbgConfiguration = {
                type = "coreclr",
                name = "Launch",
                request = "launch",
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
                cwd = function()
                    return get_launch_settings().cwd or vim.fn.getcwd()
                end,
                env = function()
                    return get_launch_settings().env or {}
                end,
                args = {},
                -- cwd = vim.fn.getcwd(),
                clientID = 'vscode',
                clientName = 'Visual Studio Code',
                externalTerminal = true,
                columnsStartAt1 = true,
                linesStartAt1 = true,
                locale = "en",
                pathFormat = "path",
                externalConsole = true,
                console = "externalTerminal",
                justMyCode = true,
                stopAtEntry = true,

            }

            local netcoredbgConfiguration = {
                type = "netcoredbg",
                name = "launch - netcoredbg",
                request = "launch",
                justMyCode = true,
                stopAtEntry = true,
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
                cwd = function()
                    return get_launch_settings().cwd or vim.fn.getcwd()
                end,
                env = function()
                    return get_launch_settings().env or {}
                end,
            }
            dap.configurations.cs = { vsdbgConfiguration, netcoredbgConfiguration }

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
                        dap.run(vsdbgConfiguration)
                    end
                end
            end, { desc = "Start debugging" })
            local function get_pid_by_name(name)
                -- local command = 'powershell -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like \'*' ..
                --     name .. '.exe*\' } | Select-Object -ExpandProperty ProcessId"'
                -- print(command)
                -- local handle = io.popen(command)
                local handle = io.popen('powershell -Command "(Get-Process -Name \'' .. name .. '\').Id"')
                local result = handle:read("*a")
                handle:close()
                return result:gsub("%s+", "") -- trim whitespace
            end

            -- Keymap to attach DAP to Cricut.Catalog.Api.exe
            vim.keymap.set("n", "<leader>da", function()
                local project = vim.fn.getreg("s")
                local pid = get_pid_by_name(project)
                Snacks.notify(pid)
                if pid ~= "" then
                    dap.run({
                        type = "coreclr", -- for .NET debugging
                        request = "attach",
                        name = "Attach to " .. project,
                        processId = tonumber(pid),
                        -- processId = function()
                        --     -- Ask the user to type the PID manually
                        --     return tonumber(vim.fn.input("Enter PID to attach: "))
                        -- end,
                        justMyCode = false,
                    })
                    Snacks.notify("Attached to process with PID: " .. pid)
                else
                    Snacks.notify.error("Process not found!")
                end
            end, { desc = "DAP attach to Cricut.Catalog.Api" })

            vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
            vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Step over" })
            vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<F8>", dap.step_out, { desc = "Step Out" })
            vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<Leader>!", function()
                require("dapui").eval(nil, { enter = true })
            end, { desc = "Inspect Variable" })

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
                            -- { id = "repl",    size = 0.5 },
                            { id = "scopes", size = 0.5 },
                            -- { id = "console", size = 0.5 },
                        },
                        size = 0.25, -- 25% of total lines
                        position = "bottom",
                    },
                    -- {
                    -- 	elements = {
                    -- 		-- Elements can be strings or table with id and size keys.
                    -- 		{ id = "scopes", size = 0.25 },
                    -- 		"breakpoints",
                    -- 		"stacks",
                    -- 		"watches",
                    -- 	},
                    -- 	size = 40, -- 40 columns
                    -- 	position = "left",
                    -- },
                },
                controls = {
                    -- Requires Neovim nightly (or 0.8 when released)
                    enabled = true,
                    -- Display controls in this element
                    element = "scopes",
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
                -- vim.fn.system("komorebic minimize")
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

                -- text = "", -- nerdfonts icon here
                text = '🔴', -- nerdfonts icon here
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
