require("os")
local argparse = require("argparse")

local parser = argparse() {
    name = "myTime",
    description = "Tool for time reporting/management.",
    epilog = "For more info, see https://github.com/BerentM/myTime"
}

parser:help_usage_margin(4)
    :help_vertical_space(1)

parser:group("General`",
    parser:argument "path"
        :description "CSV file path."
        :default (os.date("./%m%G.csv"))
)
parser:group("Add new entry.",
    parser:option "-d --date"
        :description "Provide valid date [YYYY-MM-DD]."
        :default (os.date("%G-%m-%d")),
    parser:option "-t --time"
        :description "How many hours have you worked?"
        :default "8",
    parser:option "-m --message"
        :description "What have you been doing?"
)

parser:group("Show output options.",
    parser:option "-s --show"
        :description "Show summary"
)

local args = parser:parse()

return args
