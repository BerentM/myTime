local M = {}

-- TODO: simplify it, func copied from internet
function tprint(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint .. k .. "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent - 2) .. "}"
    return toprint
end

---Split string into array of elements.
---@param inputStr string
---@param sep string
---@return table
function M:splitString(inputStr, sep)
    local out = {}
    sep = sep or ","
    if inputStr == nil then return out end

    for str in inputStr:gmatch("([^" .. sep .. "]+)") do
        table.insert(out, tonumber(str) or str)
    end

    return out
end

---Stringify table to string that can be appended to csv file.
---@param inputTable table
---@param sep string
---@return string
function M:createLine(inputTable, sep)
    local out = ""
    for index, value in ipairs(inputTable) do
        out = out .. tostring(value)
        if index ~= #inputTable then
            out = out .. sep
        end
    end
    return out .. "\n"
end

---Read csv and return it's content as list of lists.
---@param path string
---@param sep string
---@return table
function M:readCsv(path, sep)
    local out = {}

    local file = io.open(path, "r")
    if file == nil then return end

    while true do
        local line = file:read()
        if line == nil then break end
        table.insert(out, M:splitString(line, sep))
    end

    return out
end

function M:appendCsv(path, inputTable, sep)
    local file = io.open(path, "a+")
    if file == nil then return end

    local line = M:createLine(inputTable, sep)
    file:write(line)

    file:close()
end

function M:removeLastRowCsv(path)
    local file = io.open(path, "r")
    if file == nil then return end

    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()

    file = io.open(path, "w")
    for i, line in pairs(lines) do
        if i < #lines then
            file:write(line.."\n")
        end
    end
    file:close()

end

---Speed test function, uses CPU time.
---@param f function
---@param ... any
---@return number
function M:speed_test(f, ...)
    local s = os.clock()
    print(s)
    for _ = 1, 100000 do
        f(...)
    end
    return os.clock() - s
end

return M
