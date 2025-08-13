local cmp = require("cmp")

local CmpLocalLLMHandler = {}

CmpLocalLLMHandler.Config = {
    BaseUrl = "http://localhost:1234/",
    Timeout = 30,
    ModelName = "deepseek-coder-v2-lite-instruct",
}
CmpLocalLLMHandler.HttpClient = {}
CmpLocalLLMHandler.Available = false

function CmpLocalLLMHandler.new(config)
    local self = setmetatable({}, { __index = CmpLocalLLMHandler })
    self.Config = self:MapConfig(config)
    local httpConfig = {
        baseUrl = self.Config.BaseUrl,
        timeout = self.Config.Timeout,
    }
    self.HttpClient = require("plugins.cmp-local-llm.HttpClient"):new(httpConfig)

    return self
end

function CmpLocalLLMHandler:MapConfig(config)
    if config ~= nil then
        if type(config.baseUrl) == "string" and config.baseUrl ~= "" then
            self.Config.BaseUrl = config.baseUrl
        end
        if type(config.modelName) == "string" and config.modelName ~= "" then
            self.Config.ModelName = config.modelName
        end
        if type(config.timeout) == "number" and config.timeout > 30 then
            self.Config.Timeout = config.timeout
        end
    end
end

function CmpLocalLLMHandler:Complete(params, callback)
    -- print(vim.inspect(params))
    --post request to local llm
    --create response for cmp
    -- print(vim.inspect(params))

    local maxLines = 1000
    local cursor = params.context.cursor
    local currentLine = params.context.cursor_line
    local lineBefore = vim.fn.strpart(currentLine, 0, math.max(cursor.col - 1, 0), true)
    local lineAfter =
        vim.fn.strpart(currentLine, math.max(cursor.col - 1, 0), vim.fn.strdisplaywidth(currentLine), true)

    local linesBefore = vim.api.nvim_buf_get_lines(0, math.max(0, cursor.line - maxLines), cursor.line, false)
    table.insert(linesBefore, lineBefore)
    local before = table.concat(linesBefore, "\n")

    local linesAfter = vim.api.nvim_buf_get_lines(0, cursor.line + 1, cursor.line + maxLines, false)
    table.insert(linesAfter, 1, lineAfter)
    local after = table.concat(linesAfter, "\n")
    local prefix = string.sub(params.context.cursor_before_line, params.offset)

    -- print(before)
    -- print("-------")
    -- print(after)

    local requestBody = {
        model = self.Config.ModelName,
        messages = {
            {
                role = "system",
                content = "You will receive:"
                    .. "<before> ... </before>  → the code before the cursor ."
                    .. "<after>  ... </after>   → the code after the cursor ."
                    .. "Your task:"
                    .. "- Predict the most likely text that should go between <before> and <after>."
                    .. " - Output only the raw completion text (no quotes, no markdown, no explanations)."
                    .. " - Keep completions short (usually 1–5 tokens or 1 line)."
                    .. " - Do not repeat the text in <before> or <after>."
                    .. " - Maintain the style, indentation, and language from <before>."
                    .. " - If the context is ambiguous, produce the most common and useful completion."
                    .. " - Continue from latest symbol before </before> ."
                    .. " - Use the latest symbol before </before> as a start symbol ."
                    .. " - it is C# with dotnet core."
                    .. " Examples: "
                    .. " <before>"
                    .. " local function greet(name)"
                    .. "     print('Hello, ' .."
                    .. " </before>"
                    .. " <after>"
                    .. " </after>"
                    .. " Completion:"
                    .. " name .. '!')"
                    .. " <before>"
                    .. " if user.is_logged_in then"
                    .. " </before>"
                    .. " <after>"
                    .. " </after>"
                    .. " Completion:"
                    .. " show_dashboard()"
                    .. " <before>"
                    .. " for i = 1, 10 do"
                    .. " </before>"
                    .. " <after>"
                    .. " end"
                    .. " </after>"
                    .. " Completion:"
                    .. " print(i)",
            },
            {
                role = "user",
                content = "<before>" .. before .. "</before>" .. "..." .. "<after>" .. after .. "</after>",
            },
        },
        temperature = 0.7,
        max_tokens = -1,
        stream = false,
    }

    local responseCallback = function(err, response)
        local items = {}

        if err then
            print(err)
            return
        end

        -- print(vim.inspect(response))
        if response and type(response.choices) == "table" then
            for _, choice in ipairs(response.choices) do
                if choice.message and choice.message.content then
                    local trimmed = choice.message.content:match("^%s*(.-)%s*$")

                    local result = prefix .. trimmed
                    local item = {
                        cmp = {
                            kind_hl_group = "CmpItemKind",
                            kind_text = "provider",
                        },
                        label = result,
                        documentation = {
                            kind = cmp.lsp.MarkupKind.Markdown,
                            value = "```" .. (vim.filetype.match({ buf = 0 }) or "") .. "\n" .. result .. "\n```",
                        },
                    }
                    table.insert(items, item)
                end
            end
        end

        callback({ items = items, isIncomplete = false, filterText = "" })
    end

    self.HttpClient:post("api/v0/chat/completions", requestBody, responseCallback)
end

function CmpLocalLLMHandler:IsAvailable()
    return self.Available
end

function CmpLocalLLMHandler:CheckAvailability()
    self.HttpClient:get("api/v0/models", function(err, response)
        if err then
            print(err)
            self.Available = false
            return
        end

        if response then
            if type(response.error) == "string" then
                print(response.error)
                self.Available = false
                return
            end
            if type(response.data) == "table" then
                for _, model in ipairs(response.data) do
                    if model.state == "loaded" and model.id == self.Config.ModelName then
                        self.Available = true
                        break
                    end
                end
            end
        end
    end)
end

function CmpLocalLLMHandler.setup(config)
    if cmp ~= nil then
        local cmpLocalLLMHandler = CmpLocalLLMHandler.new(config)

        local source = require("plugins.cmp-local-llm.source").new(cmpLocalLLMHandler)
        cmp.register_source("local-llm", source)
        cmpLocalLLMHandler:CheckAvailability()
    end
end

return CmpLocalLLMHandler
