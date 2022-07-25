local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
local naughty = require("naughty")

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat,
    function (widget, args)
        if (tonumber(args[2]) > 90) then
            return ("  %d%%"):format(args[2])
    elseif (tonumber(args[2]) > 65) then
            return ("  %d%%"):format(args[2])
    elseif (tonumber(args[2]) > 35) then 
            return ("  %d%%"):format(args[2])
    elseif (tonumber(args[2]) > 10) then
            return ("  %d%%"):format(args[2])
    else
            return ("  %d%%"):format(args[2])
        end
    end, 31, "BAT0")
batwidget:buttons(awful.util.table.join(awful.button(
    {}, 1,
    function ()
        naughty.notify{ title = "Battery indicator",
                        text = vicious.call(vicious.widgets.bat,
                                            "Remaining time: $3", "BAT0") }
    end)))

return batwidget
