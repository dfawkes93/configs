local wibox = require("wibox")
local vicious = require("vicious")
vicious.contrib = require"vicious.contrib"

-- Create a volume widget
vol = wibox.widget.textbox("墳")
-- local sink = "alsa_output.usb-Burr-Brown_Japan_Burr-Brown_Japan_PCM2702-00.iec958-stereo"
-- vicious.register(vol, vicious.contrib.pulse, "墳 $1%", 2, sink)
-- vol:buttons(awful.util.table.join(
    -- awful.button({}, 1, function () vicious.contrib.pulse.toggle(sink) end),
    -- awful.button({}, 2, function () awful.util.spawn("pavucontrol") end),
    -- awful.button({}, 4, function () vicious.contrib.pulse.add(5, sink) end),
    -- awful.button({}, 5, function () vicious.contrib.pulse.add(-5, sink) end)))

