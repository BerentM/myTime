local M = {}
-- TODO: think about switching from csv to sqlite table

-- TODO: simplify it, func copied from internet
function M:tprint(tbl, indent)
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
            toprint = toprint .. M:tprint(v, indent + 2) .. ",\r\n"
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

---Read file and return it as raw string.
---@param path string
---@return string
function M:rawCsv(path)
    local file = io.open(path, "r")
    if file == nil then return end
    local out = file:read("a")

    return out
end

---Append table to end of file.
---@param path string
---@param inputTable table
---@param sep string
function M:appendCsv(path, inputTable, sep)
    local file = io.open(path, "a+")
    if file == nil then return end

    local line = M:createLine(inputTable, sep)
    file:write(line)

    file:close()
end

---Pop last row from the file.
---@param path string
function M:removeLastRowCsv(path)
    local file = io.open(path, "r")
    if file == nil then return end
    local old_str = file:read("a")
    -- https://stackoverflow.com/questions/64844032/how-to-remove-last-line-from-a-string-in-lua
    local new_str = old_str:gsub("\n[^\n]*(\n?)$", "%1")
    file:close()

    file = io.open(path, "w")
    file:seek("set")
    file:write(new_str)
    file:close()
end

---Parse file, and remove all rows that starts with check_value.
---@param path string
---@param check_value string
---@param sep string
function M:removeOtherOccurences(path, check_value, sep)
    local contents = M:readCsv(path, sep)
    if contents == nil then return end
    local new_contents = {}

    for _, line in ipairs(contents) do
        if line[1] ~= check_value then
            table.insert(new_contents, line)
        end
    end

    local file = io.open(path, "w+")
    if file == nil then return end

    for _, inputTable in ipairs(new_contents) do
        local line = M:createLine(inputTable, sep)
        file:write(line)
    end
    file:close()
end

---Convert csv file to map.
---@param path string
---@param sep string
---@return table
function M:csvToMap(path, sep)
    local tbl = M:readCsv(path, sep)
    local new_map = {}
    for _, value in ipairs(tbl) do
        table.insert(new_map, { date = value[1], hours = value[2], message = value[3] })
    end
    return new_map
end

---Sort csv file by its first key.
---@param path string
---@param sep string
function M:sortCsvFile(path, sep)
    local map = M:csvToMap(path, sep)
    table.sort(map, function(a, b) return a.date < b.date end)

    local file = io.open(path, "w+")
    if file == nil then return end

    for _, v in ipairs(map) do
        local line = M:createLine({ v.date, v.hours, v.message }, sep)
        file:write(line)
    end

    file:close()
end

---Deduplicate file, sort it and append new row.
---@param path string
---@param inputTable table
---@param sep string
function M:appendSortDeduplicateCsv(path, inputTable, sep)
    M:removeOtherOccurences(path, inputTable[1], sep)
    M:appendCsv(path, inputTable, sep)
    M:sortCsvFile(path, sep)
end

---Sum time spent in work
---@param path string
---@param sep string
---@return integer
function M:sumTime(path, sep)
    local contents = M:readCsv(path, sep)
    local hours = 0

    for _, line in ipairs(contents) do
        hours = hours + line[2]
    end

    return hours
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
