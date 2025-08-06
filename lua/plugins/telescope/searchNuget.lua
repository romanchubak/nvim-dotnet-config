local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local Job = require("plenary.job")

local M = {}

local search_nuget = function()
    -- Ask user for search term
    vim.ui.input({ prompt = "Search NuGet: " }, function(input)
        if not input or input == "" then
            return
        end

        -- Run dotnet search as a job
        Job:new({
            command = "dotnet",
            args = { "package", "search", input, "--format", "json" },
            on_exit = function(j)
                vim.schedule(function()
                    local json_result = table.concat(j:result(), "\n")
                    local decoded = vim.fn.json_decode(json_result)

                    if not decoded or not decoded.searchResult or #decoded.searchResult == 0 then
                        vim.schedule(function()
                            vim.notify("No packages found", vim.log.levels.INFO)
                        end)
                        return
                    end

                    local packages = decoded.searchResult[1].packages

                    local entries = {}
                    for _, pkg in ipairs(packages) do
                        -- Format for display
                        local line =
                            string.format("%s - %s - %d downloads", pkg.id, pkg.latestVersion, pkg.totalDownloads)
                        print(line)
                        table.insert(entries, { line = line, id = pkg.id })
                    end

                    -- Open Telescope picker
                    vim.schedule(function()
                        pickers
                            .new({}, {
                                prompt_title = "NuGet Packages",
                                finder = finders.new_table({
                                    results = entries,
                                    entry_maker = function(entry)
                                        return {
                                            value = entry,
                                            display = entry.line, -- what is shown in the Telescope UI
                                            ordinal = entry.line:lower(), -- used for fuzzy matching
                                        }
                                    end,
                                }),
                                sorter = conf.generic_sorter({}),
                                attach_mappings = function(prompt_bufnr, map)
                                    actions.select_default:replace(function()
                                        actions.close(prompt_bufnr)
                                        local selection = action_state.get_selected_entry()
                                        local pkg_id = selection.value.id
                                        print(pkg_id)
                                        local constants = require("core.constants")
                                        local project = vim.fn.getreg(constants.ProjectRegister)

                                        vim.fn.jobstart({ "dotnet", "package", "add", pkg_id, "--project", project }, {
                                            on_exit = function(_, code)
                                                if code == 0 then
                                                    vim.notify("Package '" .. pkg_id .. "' added.", vim.log.levels.INFO)
                                                else
                                                    vim.notify(
                                                        "Failed to add package: " .. pkg_id,
                                                        vim.log.levels.ERROR
                                                    )
                                                end
                                            end,
                                        })
                                    end)
                                    return true
                                end,
                            })
                            :find()
                    end)
                end)
            end,
        }):start()
    end)
end

M.setup = function()
    vim.keymap.set("n", "<leader>sn", search_nuget)
end

return M
