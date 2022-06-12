local utils = require("myTime.utils")

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
function M:showArgs(cliArgs)
    local args = cliArgs or require("myTime.cli")
    print(utils:tprint(args))
end

function M:run(cliArgs)
    local args = cliArgs or require("myTime.cli")
    if args["add"] then
        local input = { args["date"], args["time"], args["message"] }
        utils:appendUniqueCsv(args["path"], input, ";")
    elseif args["show"] then
        if args["all"] then
            print(utils:rawCsv(args["path"]))
        elseif args["time"] then
            print(utils:sumTime(args["path"], ";"))
        end
    end
end

return M
