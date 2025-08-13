local async_curl_request = function(opts, callback)
    local method = (opts.method or "GET"):upper()
    local url = opts.url
    local data = opts.data
    local headers = opts.headers or {}
    local timeout = opts.timeout or 30

    if not url or url == "" then
        callback("Invalid URL", nil)
        return
    end

    -- Build curl command
    local cmd = { "curl", "-s", "-X", method, "--max-time", tostring(timeout) }

    -- Add headers
    for _, header in ipairs(headers) do
        table.insert(cmd, "-H")
        table.insert(cmd, header)
    end

    -- Add POST data if method is POST
    if method == "POST" and data then
        table.insert(cmd, "-d")
        table.insert(cmd, vim.fn.json_encode(data))
    end

    -- Add URL last
    table.insert(cmd, url)
    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                local json_text = table.concat(data, "\n")
                local ok, decoded = pcall(vim.fn.json_decode, json_text)
                if ok then
                    callback(nil, decoded)
                else
                    callback("JSON decode error", nil)
                end
            end
        end,
        on_stderr = function(_, data)
            local is_not_empty_string_table = function(tbl)
                return type(tbl) == "table" and #tbl > 0 and tbl[1] ~= ""
            end
            if data and is_not_empty_string_table(data) then
                local err = table.concat(data, "\n")
                callback(err, nil)
            end
        end,
        on_exit = function(_, code)
            if code ~= 0 then
                callback("curl exited with code " .. code, nil)
            end
        end,
    })
end

-- Module table
local HttpClient = {}

-- Default config
HttpClient.Config = {
    BaseUrl = "",
    Headers = {},
    Timeout = 30, -- seconds
}

-- Constructor
function HttpClient:new(config)
    local self = setmetatable({}, { __index = HttpClient })
    if config ~= nil then
        if type(config.baseUrl) == "string" and config.baseUrl ~= "" then
            self.Config.BaseUrl = config.baseUrl
        end
        if type(config.timeout) == "number" and config.timeout > 30 then
            self.Config.Timeout = config.timeout
        end
    end
    return self
end

-- GET method
function HttpClient:get(endpoint, callback)
    async_curl_request({
        method = "GET",
        url = self.Config.BaseUrl .. endpoint,
    }, function(err, response)
        callback(err, response)
    end)
end

-- POST method
function HttpClient:post(endpoint, data, callback)
    async_curl_request({
        method = "POST",
        url = self.Config.BaseUrl .. endpoint,
        data = data,
        headers = { "Content-Type: application/json" },
    }, function(err, response)
        callback(err, response)
    end)
end

return HttpClient
