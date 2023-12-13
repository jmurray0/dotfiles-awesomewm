--[[

"test.lua"
A template widget for awesomeWM.
Jayden Lee Murray / jmurray0 (jayden.murray@arrowhead.systems)

--]]

--> Requirements
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")

--> Widgets

local menu = 
{

    { "these are the fucking hotkeys", 
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },

}

local launcherMenu = awful.menu(
    {
        items = 
        {
            {"awesome", menu, beautiful.awesome_icon},
            {"terminal", "kitty"}
        }
    }
)

test = {}


test.launcher = awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = launcherMenu
    }
)

return test