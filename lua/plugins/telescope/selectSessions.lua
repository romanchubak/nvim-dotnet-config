local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local layout_strategies = require("telescope.pickers.layout_strategies")

local M = {}

local function GetSessionName(str)
    str = str:gsub("%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end)
    local cleaned = str:gsub("x%.vim$", "")
    return cleaned
end

local selectSessions = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()
    pickers
        .new({}, {
            prompt_title = "",
            results_title = "Select Sessions",
            finder = finders.new_oneshot_job(
                { "rg", "--files", "--glob", "*x.vim" },
                {
                    cwd = vim.fn.stdpath("data") .. "/sessions/",
                    entry_maker = function(entry)
                        local resultSession = GetSessionName(entry)

                        print(resultSession)
                        return {
                            value = resultSession,   -- original file name (used when selected)
                            display = resultSession, -- what is shown in the list
                            ordinal = resultSession, -- for sorting and filtering
                        }
                    end,
                } -- restrict search to working directory
            ),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)

                    local resultSession = selection.value
                    vim.cmd("SessionRestore " .. resultSession)
                    print("Selected session:" .. resultSession)
                end)
                return true
            end,
            previewer = false,
            prompt_prefix = " ", -- visually remove the prompt symbol
        })
        :find()
end

M.setup = function()
    vim.keymap.set("n", "<leader>ls", selectSessions)
end

M.SelectSessions = function()
    selectSessions()
end

return M
