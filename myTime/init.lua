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

---debug function
---@param cliArgs table or nil
function M:showArgs(cliArgs)
    local args = cliArgs or require("myTime.cli")
    print(utils:tprint(args))
end

function M:run(cliArgs)
    local args = cliArgs or require("myTime.cli")
    if args["add"] then
        local message = ""
        for index, value in ipairs(args["message"]) do
            -- message arg is passed as table, unpack and format it
            message = message .. value
            if index < #args["message"] then
                message = message .. " "
            end
        end
        local input = { args["date"], args["time"], message }
        utils:appendSortDeduplicateCsv(args["path"], input, ";")
    elseif args["show"] then
        if args["time"] then
            print(utils:sumTime(args["path"], ";"))
        else
            print(utils:rawCsv(args["path"]))
        end
    end
end

return M
