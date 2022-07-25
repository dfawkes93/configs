local wibox = require("wibox")
local vicious = require("vicious")

datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, " %b %d, %R")
return datewidget
