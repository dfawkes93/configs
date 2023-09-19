local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("awful")

function mysep(color, shape)
    return wibox.widget {
        shape        = shape,
        color        = color,
        border_width = 0,
        forced_width = beautiful.wibar_height,
        widget       = wibox.widget.separator,
    }
end

datewidget = require("../widgets/date")
wifiwidget = require("../widgets/wifi")
-- batwidget = require("../widgets/battery")
-- vol = require("../widgets/volume")
ramw = require("../widgets/ram")
fsw = require("../widgets/fs")
pbw = require("../widgets/power")

return { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wibox.container.background(mysep(beautiful.yellow, right_tri), beautiful.black),
            wibox.container.background(fsw, beautiful.yellow),
            wibox.container.background(mysep(beautiful.red, right_tri), beautiful.yellow),
            wibox.container.background(ramw, beautiful.red),
            wibox.container.background(mysep(beautiful.orange, right_tri), beautiful.red),
            wibox.container.background(datewidget, beautiful.orange),
            wibox.container.background(mysep(beautiful.white, right_tri), beautiful.orange),
            wibox.container.background(pbw, beautiful.white)
        }

