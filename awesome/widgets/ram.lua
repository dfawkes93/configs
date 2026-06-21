local wibox = require("wibox")
local vicious = require("vicious")

-- RAM widget
ramw = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(ramw, vicious.widgets.mem, " $1%", 13)

return ramw
