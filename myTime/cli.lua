require("os")
local argparse = require("argparse")

local parser = argparse() {
    name = "myTime",
    description = "Tool for time reporting/management.",
    epilog = "For more info, see https://github.com/BerentM/myTime"
}
parser:require_command(false)
    :help_usage_margin(4)

parser:add_help_command()
local show = parser:command "show"
    :description "Show file summary."
local add = parser:command "add"
    :description "Add new entry"

add:argument "message"
    :description "What have you been doing?"
add:option "-p --path"
    :description "CSV file path."
    :default(os.date("./%m%G.csv"))
add:option "-d --date"
    :description "Provide valid date [YYYY-MM-DD]."
    :default(os.date("%G-%m-%d"))
add:option "-t --time"
    :description "How many hours have you worked?"
    :default "8"

show:option "-p --path"
    :description "CSV file path."
    :default(os.date("./%m%G.csv"))
show:option "-t --time"
    :description "Show time summary."
show:option "-a --all"
    :description "Show whole file."

local args = parser:parse()

return args
