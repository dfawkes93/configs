local wibox = require("wibox")
local vicious = require("vicious")

-- FS widget
fsw = wibox.widget.textbox()
vicious.register(fsw, vicious.widgets.fs, " ${/ used_gb}GB/${/ avail_gb}GB", 37)

return fsw
