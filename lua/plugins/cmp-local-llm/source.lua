local source = {}

source.Client = {}
--- Return the name of your source (shown in completion menu)
function source:get_debug_name()
	return "Local LLM Source"
end

--- Called by nvim-cmp to check if completion is available in the current context
---@param params cmp.SourceContext
function source:is_available(params)
	if self.Client ~= nil then
		return self.Client:IsAvailable()
	end
	return false
end

--- Return the keyword pattern used to trigger completion
function source:get_keyword_pattern()
	return [[\k\+]] -- Words made of letters/numbers/underscore
end

--- The main completion function
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: cmp.SourceCompletionResponse)
function source:complete(params, callback)
	if self.Client ~= nil and type(self.Client.Complete) == "function" then
		self.Client:Complete(params, callback)
	end
end

--- Optional: resolve more info about the selected item
function source:resolve(completion_item, callback)
	completion_item.detail = "Extra detail about " .. completion_item.label
	callback(completion_item)
end

--- Optional: run when the item is accepted
function source:execute(completion_item, callback)
	callback(completion_item)
end

-- Factory function for nvim-cmp
---@param client plugins.cmp-local-llm.CmpLocalLLMHandler
local M = {}
function M.new(client)
	local self = setmetatable({}, { __index = source })
	self.Client = client

	return self
end

return M
