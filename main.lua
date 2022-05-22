-- local h = require("hours")
local u = require("myTime.utils")

-- local out = u:readCsv("./spec/test_file.csv", ",")
-- print(tprint(out))

-- print(u:createLine({1,2,3}, ";"))
u:removeLastRowCsv("spec/test_file.csv")

