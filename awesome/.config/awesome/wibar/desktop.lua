local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
beautiful.init(awful.util.get_configuration_dir() .. "themes/theme.lua")

function mysep(color, shape)
    return wibox.widget {
        shape        = shape,
        color        = color,
        border_width = 0,
        forced_width = theme.wibar_height,
        widget       = wibox.widget.separator,
    }
end

datewidget = require("../widgets/date")
wifiwidget = require("../widgets/wifi")
batwidget = require("../widgets/battery")
-- vol = require("../widgets/volume")
ramw = require("../widgets/ram")
fsw = require("../widgets/fs")
pbw = require("../widgets/power")

return { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wibox.container.background(mysep(theme.color_1, right_tri), theme.bg_normal),
            wibox.container.background(fsw, theme.color_1),
            wibox.container.background(mysep(theme.color_2, right_tri), theme.color_1),
            wibox.container.background(ramw, theme.color_2),
            wibox.container.background(mysep(theme.color_3, right_tri), theme.color_2),
			wibox.container.background(batwidget, theme.color_3),
            wibox.container.background(mysep(theme.color_4, right_tri), theme.color_3),
            wibox.container.background(datewidget, theme.color_4),
            wibox.container.background(mysep(theme.color_5, right_tri), theme.color_4),
            wibox.container.background(pbw, theme.color_5)
        }

