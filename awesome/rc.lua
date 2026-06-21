-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
vicious.contrib = require "vicious.contrib"
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/beautiful.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/theme.lua")
naughty.notify({ text = gears.filesystem.get_configuration_dir() .. "themes/theme.lua" })

-- This is used later as the default terminal and editor to run.
local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "vi"
local editor_cmd = terminal .. " -e " .. editor

local monitor_vert = 3
local monitor_left = 1
local monitor_right = 2

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
local modkey = "Mod4"
local altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

local function screen_has_fake(s)
    s = s or awful.screen.focused()
    return s.has_fake or s.is_fake
end

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Separators
local half_spr = wibox.widget.textbox(" ")
function right_tri(cr, width, height, degree)
    cr:move_to(beautiful.wibar_height, 0)
    cr:line_to(0, beautiful.wibar_height)
    cr:line_to(beautiful.wibar_height, beautiful.wibar_height)
    cr:close_path()
end

local widgetlist = require("./wibar")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    -- Wallpaper
    -- if s.index == monitor_vert then
    --     awful.spawn.easy_async([[/bin/sh -c 'ls -d /home/egg/Pictures/bg/vert/* | sort -R | tail -1' ]],
    --         function(stdout, stderr, reason, exit_code)
    --             --naughty.notify { text = stdout }
    --             gears.wallpaper.maximized(string.gsub(stdout, "%s+", ""), s, true)
    --         end)
    -- else
    --     awful.spawn.easy_async([[/bin/sh -c 'ls -d /home/egg/Pictures/bg/horz/* | sort -R | tail -1' ]],
    --         function(stdout, stderr, reason, exit_code)
    --             --naughty.notify { text = stdout }
    --             gears.wallpaper.maximized(string.gsub(stdout, "%s+", ""), s, false)
    --         end)
    -- end
    gears.wallpaper.maximized("/home/dylanf/Pictures/bg.png", s, false)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    if not s.is_fake then
        set_wallpaper(s)
    end

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- XXX
    -- Create a promptbox for each screen
    -- s.mypromptbox = awful.widget.prompt()
    -- -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- -- We need one layoutbox per screen.
    -- s.mylayoutbox = awful.widget.layoutbox(s)
    -- s.mylayoutbox:buttons(gears.table.join(
    --     awful.button({}, 1, function() awful.layout.inc(1) end),
    --     awful.button({}, 3, function() awful.layout.inc(-1) end),
    --     awful.button({}, 4, function() awful.layout.inc(1) end),
    --     awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- -- Create a taglist widget
    -- s.mytaglist = awful.widget.taglist {
    --     screen = s,
    --     filter = awful.widget.taglist.filter.all,
    --     layout = {
    --         layout = wibox.layout.fixed.horizontal,
    --         spacing = dpi(8),
    --     },
    --     style = { shape = gears.shape.circle },
    --     widget_template = {
    --         {
    --             {
    --                 {
    --                     id = "text_role",
    --                     widget = wibox.widget.textbox,
    --                 },
    --                 layout = wibox.layout.fixed.horizontal,
    --             },
    --             left = beautiful.spacing,
    --             right = beautiful.spacing,
    --             widget = wibox.container.margin,
    --         },
    --         id = "background_role",
    --         widget = wibox.container.background,
    --     },
    -- }
    --
    -- -- Create a tasklist widget
    -- s.mytasklist = awful.widget.tasklist {
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons
    -- }
    --
    -- -- Create the wibox
    -- s.mywibox = awful.wibar({ position = "top", screen = s, opacity = 0.8 })
    --
    -- -- s.mywibox:struts ({
    -- --     top = dpi(4)
    -- -- })
    -- -- Add widgets to the wibox
    -- s.mywibox:setup {
    --     layout = wibox.layout.align.horizontal,
    --     {
    --         -- Left widgets
    --         layout = wibox.layout.fixed.horizontal,
    --         --  mylauncher,
    --         wibox.container.background(s.mylayoutbox, beautiful.yellow),
    --         wibox.container.background(mysep(beautiful.orange, right_tri), beautiful.yellow),
    --         wibox.container.background(s.mytaglist, beautiful.orange),
    --         wibox.container.background(mysep(beautiful.red, right_tri), beautiful.orange),
    --         s.mypromptbox,
    --     },
    --     s.mytasklist, -- Middle widget
    --     widgetlist    -- Right widget (imported widgetlist)
    --     ,
    -- }
    -- XXX
    -- Create a taglist widget
    local wrap_bg = function(widgets, lospace)
        -- if type(widgets) == "table" then
        widgets.spacing = beautiful.spacing
        -- end
        local space_lg = beautiful.spacing_lg
        local space = beautiful.spacing

        if lospace then
            space = beautiful.spacing_xs
            space_lg = beautiful.spacing_sm
        end

        return wibox.widget({
            {
                widgets,
                left = space_lg,
                right = space_lg,
                top = space,
                bottom = space,
                widget = wibox.container.margin,
            },
            -- shape = utils.ui.rounded_rect(20),
            bg = beautiful.bg_normal,
            widget = wibox.container.background,
        })
    end
    s.mytaglist = awful.widget.taglist({
        screen = s,
        buttons = taglist_buttons,
        filter = awful.widget.taglist.filter.all,
        layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.spacing,
        },
        style = { shape = gears.shape.circle },
        widget_template = {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = beautiful.spacing,
                right = beautiful.spacing,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    })
    -- Create a tasklist widget
    -- s.mytasklist = awful.widget.tasklist {
    --     screen  = s,
    --     filter  = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons
    -- }
    s.mytasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = tasklist_buttons,
        layout          = {
            spacing_widget = {
                {
                    forced_height = 24,
                    thickness     = 1,
                    color         = '#777777',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing        = beautiful.spacing,
            layout         = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 2,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 2,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
            bg = beautiful.bg_normal,
        },
    }

    s.mywibox = awful.wibar({
        height = beautiful.bar_height,
        type = "dock",
        bg = "#00000000",
        position = "top",
        screen = s,
    })

    s.mywibox:setup({
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                {
                    -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    wrap_bg(s.mytaglist),
                },
                nil,
                {
                    -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.spacing,
                    wrap_bg(wibox.widget.systray()),
                },
                widget = wibox.container.margin,
            },
            {
                wrap_bg(s.mytasklist, true),
                valign = "center",
                halign = "center",
                layout = wibox.container.place,
            },
        },
        left = beautiful.useless_gap * 2,
        right = beautiful.useless_gap * 2,
        top = beautiful.useless_gap * 2,
        widget = wibox.container.margin,
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey, }, "c", hotkeys_popup.show_help,
        { description = "show cheatsheet", group = "awesome" }),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    awful.key({ modkey, }, "[",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "]",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    -- Audio manip
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pactl set-sink-volume 0 +5%") end,
        { description = "Volume Up", group = "awesome" }),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pactl set-sink-volume 0 -5%") end,
        { description = "Volume Down", group = "awesome" }),
    awful.key({}, "XF86AudioMute", function() awful.spawn("pactl set-sink-mute 0 toggle") end,
        { description = "Volume Mute", group = "awesome" }),


    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "[", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "]", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "[", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "]", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, "Shift" }, "s",
        function() awful.spawn.with_shell("scrot -s -f - | xclip -selection clipboard -target image/png") end,
        { description = "screenshot selection", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "x", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "Prior", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, }, "Next", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.spawn.with_shell("$HOME/.config/rofi/scripts/launcher_t1 drun") end,
        { description = "run rofi", group = "launcher" }),
    awful.key({ modkey }, "t", function() awful.spawn.with_shell("$HOME/.config/rofi/scripts/launcher_t1 window") end,
        { description = "rofi winselect", group = "launcher" }),
    awful.key({ modkey }, "d", function() awful.spawn.with_shell("$HOME/.config/rofi/scripts/launcher_t1 file") end,
        { description = "rofi files", group = "launcher" }),
    awful.key({ modkey }, "x", function() awful.spawn.with_shell("$HOME/.config/rofi/scripts/powermenu_t1") end,
        { description = "rofi power", group = "launcher" }),

    awful.key({ modkey, "Control" }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"})
    -- Toggle/hide fake screen
    awful.key({ modkey }, ';',
        function()
            _G.screen.emit_signal('toggle_fake')
        end,
        { description = 'show/hide fake screen', group = 'fake screen' }),

    awful.key({ modkey, altkey }, 'q', function()
            _G.screen.emit_signal('subscreen_none')
        end,
        { description = 'single frame', group = 'fake screen' }
    ),

    awful.key({ modkey, altkey }, 'w', function()
            _G.screen.emit_signal('subscreen_single')
        end,
        { description = 'dual frame', group = 'fake screen' }
    ),

    awful.key({ modkey, altkey }, 'f', function()
            _G.screen.emit_signal('subscreen_dual')
        end,
        { description = 'triple frame', group = 'fake screen' }
    ),

    -- Create or remove
    awful.key({ modkey, altkey }, 'c',
        function()
            if screen_has_fake() then
                _G.screen.emit_signal('remove_fake')
            else
                _G.screen.emit_signal('create_fake')
            end
        end,
        { description = 'create/remove fake screen', group = 'fake screen' }),

    -- Increase fake screen size
    awful.key({ modkey, altkey }, 'Left',
        function()
            _G.screen.emit_signal('resize_fake', -10)
        end,
        { description = 'resize fake screen', group = 'fake screen' }),

    -- Decrease fake screen size
    awful.key({ modkey, altkey }, 'Right',
        function()
            _G.screen.emit_signal('resize_fake', 10)
        end,
        { description = 'resize fake screen', group = 'fake screen' }),

    -- Reset screen sizes to initial size
    awful.key({ modkey, altkey }, 'r',
        function()
            _G.screen.emit_signal('reset_fake')
        end,
        { description = 'reset fake screen size', group = 'fake screen' })
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            if c.maximized then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to next screen", group = "client" }),
    awful.key({ modkey, }, "i", function(c) c:move_to_screen(c.screen.index - 1) end,
        { description = "move to prev screen", group = "client" }),
    awful.key({ modkey, "Shift" }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "s", function(c) c.sticky = not c.sticky end,
        { description = "toggle sticky", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized = not c.maximized
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "(un)maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tagKeys = { "q", "w", "f", "p", "b" }
for i = 1, 5 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, tagKeys[i], -- "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, tagKeys[i], --  "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, tagKeys[i], -- "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, tagKeys[i], -- "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer" },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            },
            except_any = { class = { "Chromium" } },
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    {
        rule = { class = "Chromium", name = "YouTube Music" },
        properties = { screen = monitor_right, tag = "2", floating = false }
    },
    {
        rule = { class = "Chromium", name = "Discord.*" },
        properties = { screen = monitor_vert, tag = "2", floating = false }
    },
    -- { rule = { class = "Chromium", name = "Discord" },
    --  properties = { screen = monitor_vert, tag = "2", floating = false } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- turn titlebar on when client is floating
-------------------------------------------------------------------------------
client.connect_signal("property::floating", function(c)
    if c.floating and not c.requests_no_titlebar and not c.maximized then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        {
            -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {
            -- Middle
            {
                -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {
            -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Startup tasks
-- awful.spawn("/usr/bin/setxkbmap -option ctrl:nocaps")

-- fakescreens
local screens = {}
local uw
for s in _G.screen do
    if s.geometry.width > 2560 then
        uw = s.geometry
    end
end

local ratio = 0.733 -- 0.6465

local function subscreen_none(s)
    s = s or awful.screen.focused()
    while s.is_fake do
        s = s.parent
    end
    if not uw or not s.fake or #s.fake == 0 then return end
    for k, fake in pairs(s.fake) do
        fake:fake_remove()
    end
    s.fake = nil
    s:fake_resize(uw.x, uw.y, uw.width, uw.height)
end

local function subscreen_single(s)
    s = s or awful.screen.focused()
    while s.is_fake do
        s = s.parent
    end
    if not s.fake then s.fake = {} end
    if not uw or #s.fake == 1 then return end
    local half_w = math.floor(uw.width * 0.5)
    if #s.fake == 0 then
        table.insert(s.fake, _G.screen.fake_add(
            uw.x + half_w,
            uw.y,
            half_w,
            uw.height
        ))
    end
    if #s.fake == 2 then
        s.fake[2]:fake_remove()
        s.fake[2] = nil
        s.fake[1]:fake_resize(
            uw.x + half_w,
            uw.y,
            half_w,
            uw.height
        )
    end
    s:fake_resize(uw.x, uw.y, half_w, uw.height)
    for k, fake in pairs(s.fake) do
        fake.parent = s
        fake.is_open = true
        fake.is_fake = true
        fake.is_subscreen = true
    end
    s.has_fake = true
    -- Because memory leak
    collectgarbage('collect')
    -- Emit signal
    s:emit_signal('fake_created')
end

local function subscreen_dual(s)
    s = s or awful.screen.focused()
    while s.is_fake do
        s = s.parent
    end
    if not s.fake then s.fake = {} end
    if not uw or #s.fake == 2 then return end
    local quater_w = math.floor(uw.width * 0.25)
    s:fake_resize(uw.x + quater_w, uw.y, quater_w * 2, uw.height)
    if #s.fake == 0 then
        table.insert(s.fake, _G.screen.fake_add(
            uw.x + quater_w * 3,
            uw.y,
            quater_w,
            uw.height
        ))
    else
        s.fake[1]:fake_resize(
            uw.x + quater_w * 3,
            uw.y,
            quater_w,
            uw.height
        )
    end
    table.insert(s.fake, _G.screen.fake_add(
        uw.x,
        uw.y,
        quater_w,
        uw.height
    ))
    for k, fake in pairs(s.fake) do
        fake.parent = s
        fake.is_open = true
        fake.is_fake = true
        fake.is_subscreen = true
    end
    s.has_fake = true
    -- Because memory leak
    collectgarbage('collect')
    -- Emit signal
    s:emit_signal('fake_created')
end

local function create_fake(s)
    -- If screen was not passed
    s = s or awful.screen.focused()
    -- Get real screen if fake was focused
    if s.is_fake then s = s.parent end
    -- If already is or has fake
    -- if screen_has_fake(s) then return end
    -- Create variables
    local geo = s.geometry
    local real_w = math.floor(geo.width * ratio)
    local fake_w = geo.width - real_w
    -- Index for cleaner code
    local index = tostring(s.index)
    -- Set initial sizes into memory
    screens[index] = {}
    screens[index].geo = geo
    screens[index].real_w = real_w
    screens[index].fake_w = fake_w
    -- Create if doesn't exist
    -- Resize screen
    s:fake_resize(geo.x, geo.y, real_w, geo.height)
    -- Create fake for screen
    s.fake = _G.screen.fake_add(
        geo.x + real_w,
        geo.y,
        fake_w,
        geo.height
    )
    s.fake.parent = s
    -- Mark screens
    s.fake.is_fake = true
    s.has_fake = true
    -- Change status
    s.fake.is_open = true
    -- Because memory leak
    collectgarbage('collect')
    -- Emit signal
    s:emit_signal('fake_created')
    naughty.notify({ title = "Creating fake", text = tostring(s.geometry.width) })
end

local function remove_fake(s)
    -- Return if no screen presented
    s = s or awful.screen.focused()
    -- Get real screen if fake was focused
    if s.is_fake then s = s.parent end
    -- If screen doesn't have fake
    if not s.has_fake then return end
    -- Index for cleaner code
    local index = tostring(s.index)
    s:fake_resize(
        screens[index].geo.x,
        screens[index].geo.y,
        screens[index].geo.width,
        screens[index].geo.height
    )
    -- Remove and handle variables
    s.fake:fake_remove()
    s.has_fake = false
    s.fake = nil
    screens[index] = {}
    -- Because memory leaks
    collectgarbage('collect')
    -- Emit signal
    s:emit_signal('fake_created')
    naughty.notify({ title = "Destroying fake", text = tostring(s.geometry.width) })
end

-- Toggle fake screen
local function toggle_fake(s)
    -- No screen given as parameter
    s = s or awful.screen.focused()
    -- If screen doesn't have fake or isn't fake
    if not s.has_fake and not s.is_fake then return end
    -- Ge real screen if fake was focused
    if s.is_fake then s = s.parent end
    -- Index for cleaner code
    local index = tostring(s.index)
    -- If fake was open
    if s.fake.is_open then
        -- Resize real screen to be initial size
        s:fake_resize(
            screens[index].geo.x,
            screens[index].geo.y,
            screens[index].geo.width,
            screens[index].geo.height
        )
        -- Resize fake to 1px 'out of the view'
        -- 0px will move clients out of the screen.
        -- On multi monitor setups it will show up
        -- on screen on right side of the screen we're handling
        s.fake:fake_resize(
            screens[index].geo.width,
            screens[index].geo.y,
            1,
            screens[index].geo.height
        )
        -- Mark fake as hidden
        s.fake.is_open = false
    else -- Fake was selected
        -- Resize screens
        s:fake_resize(
            screens[index].geo.x,
            screens[index].geo.y,
            screens[index].real_w,
            screens[index].geo.height
        )
        s.fake:fake_resize(
            screens[index].geo.x + screens[index].real_w,
            screens[index].geo.y,
            screens[index].fake_w,
            screens[index].geo.height
        )
        -- Mark fake as open
        s.fake.is_open = true
    end
    -- Because memory leaks
    collectgarbage('collect')
    -- Emit signal
    s:emit_signal('fake_toggle')
end

-- Resize fake with given amount in pixels
local function resize_fake(amount, s)
    -- No screen given
    s = s or awful.screen.focused()
    amount = amount or resize_default_amount
    -- Ge real screen if fake was focused
    if s.is_fake then s = s.parent end
    -- Index for cleaner code
    local index = tostring(s.index)
    -- Resize only if fake is open
    if s.fake.is_open then
        -- Modify width variables
        screens[index].real_w = screens[index].real_w + amount
        screens[index].fake_w = screens[index].fake_w - amount
        -- Resize screens
        s:fake_resize(
            screens[index].geo.x,
            screens[index].geo.y,
            screens[index].real_w,
            screens[index].geo.height
        )
        s.fake:fake_resize(
            screens[index].geo.x + screens[index].real_w,
            screens[index].geo.y,
            screens[index].fake_w,
            screens[index].geo.height
        )
    end
    -- Because memory leak
    collectgarbage('collect')
    -- Emit signal
    s:emit_signal('fake_resize')
end

-- Reset screen widths to default value
local function reset_fake(s)
    -- No sreen given
    s = s or awful.screen.focused()
    -- Get real screen if fake was focused
    if s.is_fake then s = s.parent end
    -- In case screen doesn't have fake
    if not s.has_fake then return end
    -- Index for cleaner code
    local index = tostring(s.index)
    if s.fake.is_open then
        screens[index].real_w = math.floor(screens[index].geo.width * ratio)
        screens[index].fake_w = screens[index].geo.width - screens[index].real_w
        s:fake_resize(
            screens[index].geo.x,
            screens[index].geo.y,
            screens[index].real_w,
            screens[index].geo.height
        )
        s.fake:fake_resize(
            screens[index].real_w,
            screens[index].geo.y,
            screens[index].geo.width - screens[index].real_w,
            screens[index].geo.height
        )
    end
    -- Because memory leak
    collectgarbage('collect')
    -- Emit signal
    s:emit_signal('fake_reset')
end


-- Signals, maybe useful for keybinds. s = screen, a = amount
_G.screen.connect_signal('remove_fake', function(s) remove_fake(s) end)
_G.screen.connect_signal('toggle_fake', function(s) toggle_fake(s) end)
_G.screen.connect_signal('create_fake', function(s) create_fake(s) end)
_G.screen.connect_signal('resize_fake', function(a, s) resize_fake(a, s) end)
_G.screen.connect_signal('reset_fake', function(s) reset_fake(s) end)
_G.screen.connect_signal('subscreen_none', function(s) subscreen_none(s) end)
_G.screen.connect_signal('subscreen_single', function(s) subscreen_single(s) end)
_G.screen.connect_signal('subscreen_dual', function(s) subscreen_dual(s) end)
