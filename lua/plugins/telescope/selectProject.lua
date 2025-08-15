local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local layout_strategies = require("telescope.pickers.layout_strategies")
local constants = require("core.constants")

local M = {}

local GetProjectName = function(csproj_path)
	if csproj_path and csproj_path ~= "" then
		local result = vim.split(csproj_path, "\\")
		return result
	end
	return nil
end

local SetupProject = function(csproj_path)
	if csproj_path and csproj_path ~= "" then
		local result = GetProjectName(csproj_path)

		vim.fn.setreg(constants.ProjectRegister, result[1])
		print('Saved to '..constants.ProjectRegister..': ' .. result[1])
	end
end

local function GetTargetFramework(csproj_path)
	if csproj_path and csproj_path ~= "" then
		for line in io.lines(csproj_path) do
			local framework = line:match("<TargetFramework>(.-)</TargetFramework>")
			if framework then
				return framework
			end
		end
	end
	return nil
end

local SetupFramework = function(csproj_path)
	if csproj_path and csproj_path ~= "" then
        local framework = GetTargetFramework(csproj_path)

		vim.fn.setreg(constants.FrameworkRegister, framework)
		print('Saved to '..constants.FrameworkRegister..': ' .. framework)
	end
end

local search_projects = function(opts)
	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()
	if vim.bo.filetype == "cs" then
		pickers
			.new({}, {
				prompt_title = "",
				results_title = "Select Startup Project",
				finder = finders.new_oneshot_job(
					{ "rg", "--files", "--glob", "*.csproj" },
					{ cwd = vim.fn.getcwd() } -- restrict search to working directory
				),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)

						-- Save project to "s register
						SetupProject(selection[1])
                        SetupFramework(selection[1])
					end)
					return true
				end,
				previewer = false,
				prompt_prefix = " ", -- visually remove the prompt symbol
			})
			:find()
	end
end

M.setup = function()
	vim.keymap.set("n", "<leader>sp", search_projects)
end

M.SelectProject = function()
	search_projects()
end

return M
