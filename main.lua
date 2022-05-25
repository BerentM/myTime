-- local mt = require("myTime")

-- mt:showArgs()
-- mt:run()

local utils = require("myTime.utils")

local out = utils:csvToMap("spec/test_file.csv", ",")

print(out)


