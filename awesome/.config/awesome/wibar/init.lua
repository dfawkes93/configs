local machine = require("../util/getMachineName").getHostname()

if (machine == "egg-laptop") then
    local wibar = require("wibar/laptop")
    return wibar
else
    local wibar = require("wibar/desktop")
    return wibar
end

