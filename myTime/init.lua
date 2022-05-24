local utils = require("myTime.utils")
local args = require("myTime.cli")

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
function M:showArgs()
    print(utils:tprint(args))
end

function M:run()
    if args["add"] then
        local input = {args["date"], args["time"], args["message"]}
        utils:appendCsv(args["path"], input, ";")
    elseif args["show"] then
        print(utils:rawCsv(args["path"]))
    end
end

return M
