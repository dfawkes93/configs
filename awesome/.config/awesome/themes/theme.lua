local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir() .. "themes/"
local themes_default = gfs.get_themes_dir()

local machine = require("util/getMachineName").getHostname()

theme = {}
theme.font              = "Fira Code Nerd Font 12"
theme.notification_font = "Fira Code Nerd Font 12"

theme.useless_gap 	    =  dpi(10)

theme.fg_normal         = "#FEFEFE"
theme.fg_focus          = "#32D6FF"
theme.fg_urgent         = "#C83F11"
theme.bg_normal         = "#222222"
theme.bg_focus          = "#222222"
theme.bg_urgent         = "#3F3F3F"


theme.color_1           = "#537886"
theme.color_2           = "#344247"
theme.color_3           = "#598392"
theme.color_4           = "#405860"
theme.color_5           = "#47636D"

theme.bg_minimize = theme.bg_normal
theme.bg_systray  = theme.bg_normal

theme.taglist_bg_focus = theme.color_2
-- theme.taglist_fg_focus = "#f15946"
theme.taglist_fg_empty = theme.color_2

theme.border_width  = dpi(4)
theme.border_normal = "#222222"
theme.border_focus  = "#47636D"
theme.border_marked = "#6510CC"

theme.hotkeys_modifiers_fg = "#2EB398"

-- System Tray
theme.systray_icon_spacing = 24;


theme.wibar_height = dpi(28)
theme.menu_height = dpi(24)
theme.menu_width  = dpi(200)
-- Define the image to load
theme.titlebar_close_button_normal = themes_default.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_default.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_default.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_default.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_default.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_default.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_default.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_default.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_default.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_default.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_default.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_default.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_default.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_default.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_default.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_default.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_default.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_default.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_default.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_default.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_default.."default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_default.."default/layouts/fairhw.png"
theme.layout_fairv = themes_default.."default/layouts/fairvw.png"
theme.layout_floating  = themes_default.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_default.."default/layouts/magnifierw.png"
theme.layout_max = themes_default.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_default.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_default.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_default.."default/layouts/tileleftw.png"
theme.layout_tile = themes_default.."default/layouts/tilew.png"
theme.layout_tiletop = themes_default.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_default.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_default.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_default.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_default.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_default.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_default.."default/layouts/cornersew.png"

return theme
