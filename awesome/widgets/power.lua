local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")

-- Power Button Widget
pbw =  wibox.widget{
    {
        text = " 襤 ",
        widget = wibox.widget.textbox
    },
    top = 2, bottom = 4, left = 2, right = 2,
        widget = wibox.container.margin
}

pbw:connect_signal("button::press", function(c, _, _, button) 
    if button == 1 then awful.spawn.with_shell("$HOME/scripts/logoutopts")
    end
end)

return pbw
