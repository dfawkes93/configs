local wibox = require("wibox")
local vicious = require("vicious")

wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi , 
    function (widget, args)
        if (args["{ssid}"] == "N/A") then
            return "睊 "
        else 
            return ("直 %s"):format(args["{ssid}"])
        end
    end, 37, "wlp3s0")

return wifiwidget
