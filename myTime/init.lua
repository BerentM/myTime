local M = {}

---return hello world
---@return string
function M:first()
    return "Hello, World!"
end

---hello name
---@param name string
---@return string
function M:name(name)
    return "Hello, " .. name .. "!"
end

--TODO: parse cli args and put them into table that could be added into csv file
return M
