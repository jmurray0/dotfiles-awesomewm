--[[

"rc.lua"
A template configuration for awesomeWM.
Jayden Lee Murray / jmurray0 (jayden.murray@arrowhead.systems)

--]]

--> Require luarocks, the library used in awesomeWM.
pcall(require, "luarocks.loader")
--> Require libraries
modules = require("rules.modules")

--- Optional dependencies. Add additional functionality.
-- Ex: moduleTable.cyclefocus = require("cyclefocus")
-- require("widgets.signals")
require("awful.hotkeys_popup.keys")

--- Modifier key name.
modifierKey = "Mod1"
--- Selects the environment's editor, or falls back to a chosen editor.
desiredEditor = "nano"; editor=os.getenv("EDITOR") or desiredEditor
--- Sets the terminal to the specified string.
terminal = "kitty"; modules.menubar.utils.terminal=terminal;
--- Determines the workspace titles and their layouts.
workspaces = require("widgets.workspaces")
awesome.themes_path = "~/.config/awesome/themes/"

autorun = true
autorunApps =
{

    {
        term = false,
        exec = "picom --config /home/jaydenlm/.config/awesome/rules/picom-config",
    },

    {
        term = false,
        exec = "lxqt-policykit-agent",
    },
    
}

---------------------------------------------------------------------------------------

--> Startup error handling
if awesome.startup_errors then
    modules.naughty.notify(
        {
            preset = modules.naughty.presets.critical,
            title = "Statup errors have occurred.",
            text = awesome.startup_errors
        }
    )
end

--> Runtime error handling
do
    local errorCheck = false
    awesome.connect_signal("debug::error", function(Error)
            if errorCheck then return end

            errorCheck = true
            modules.naughty.notify(
                {
                    preset = modules.naughty.presets.critical,
                    title = "An error has occurred.",
                    text = tostring(error)
                }
            )
    end) 
end

---------------------------------------------------------------------------------------

--- Initialize theme, if there is one.
modules.beautiful.init("~/.config/awesome/themes/nord.lua")

local function setWallpaper(Screen)
    if modules.beautiful.wallpaper then
        local wallpaper = modules.beautiful.wallpaper
        --- Check if wallpaper is a function.
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(Screen)
        end
        --- ??
        modules.gears.wallpaper.maximized(wallpaper, Screen, true)
    end
end
--- If the screen changes resolution, or there are more/less screens, re-add the wallpaper.
screen.connect_signal("property::geometry", setWallpaper)

---------------------------------------------------------------------------------------

--- Import widgets into this table.
local widgets = {}
widgets.topbar = require("widgets.topbar")
widgets.titlebar = require("widgets.titlebar")
widgets.wirelessStatus = require("widgets.wirelessStatus")

require("widgets.rememberGeometry")
require("widgets.screenshot")
-- Ex: widgets.test = require("widgets.test")

modules.awful.screen.connect_for_each_screen(function(Screen)

    setWallpaper(Screen)

    --> Top Bar Code 

    modules.awful.tag(workspaces[1], Screen, workspaces[2])

    Screen.topBar = modules.awful.wibar(
        {
            position = "top",
            screen = Screen
        }
    )

    workspaceList = widgets.topbar.createWorkspaceList(Screen)
    applicationList = widgets.topbar.createApplicationList(Screen)

    --[[
    Widget box setup is intuitive but doesn't make sense at first glance.
    The layout is as follows:
    Screen.Wibox:setup 
    {
        [Box layout. This would be the alignment direction. Ex: wibox.layout.align.horizontal],
        {
            [Widget section layout]
            [Widgets...]
        }
        
    }
    
    Widgets use flex boxes, similar to HTML elements with flex boxes.
    Widgets align left to right, and stack across the entire panel.

    --]]
    
    Screen.topBar:setup {
        layout = modules.wibox.layout.align.horizontal,
        {
            layout = modules.wibox.layout.align.horizontal,
            workspaceList,


        },
        {
            layout = modules.wibox.layout.flex.horizontal,
            applicationList,
        },
        {
            layout = modules.wibox.layout.align.horizontal,
            -- widgets.wirelessStatus,
            modules.wibox.widget.systray(),
            modules.wibox.widget.textclock(),

        },
    }

end)

---------------------------------------------------------------------------------------

--[[

    I would have preferred if keybinds were listed ABOVE the construction of the
    windows, but that would mean that any of the variables would not be 
    accessible by the keybinds. Whoops.

--]]
local key = modules.awful.key
local mouseBind = modules.awful.button

--- Mouse binds
root.buttons(modules.gears.table.join(

    )
)

--- Keybinds which pertain to the window manager as a whole.
globalKeybinds = modules.gears.table.join(

    --- Program Binds

    key({modifierKey}, "Return", --- Terminal
        function()
            modules.awful.spawn(terminal)
        end,
        {
            description = "open terminal",
            group = "application",
        }
    ),

    key({modifierKey}, "e", --- File explorer
        function()
            modules.awful.spawn("nemo")
        end,
        {
            description = "open file explorer",
            group = "application",
        }
    ),

    key({modifierKey}, "r", --- File explorer
        function()
            modules.awful.spawn("rofi -show run")
        end,
        {
            description = "show runner",
            group = "application",
        }
    ),
    
    --- System Binds

    key({modifierKey, "Control"}, "r", --- Restart awesomeWM.
        awesome.restart,
        {
            description = "reload awesome",
            group = "system",
        }
    ),

    key({modifierKey, "Control"}, "Delete", --- Quit awesomeWM. Return to DM.
        awesome.quit,
        {
            description = "quit awesome",
            group = "system",
        }
    ),

    key({modifierKey}, "s", --- Show the key binds/help menu.
        modules.awful_hotkeys_popup.show_help,
        {
            description = "show help",
            group = "system",
        }
    ),

    key({modifierKey}, "Left", --- Move to left one workspace.
        modules.awful.tag.viewprev,
        {
            description = "move to left workspace",
            group = "system",
        }
    ),

    key({modifierKey}, "Right", --- Move to right one workspace.
        modules.awful.tag.viewnext,
        {
            description = "move to Right workspace",
            group = "system",
        }
    ),

    key({modifierKey}, "Escape", --- Move to previous workspace.
        modules.awful.tag.history.restore,
        {
            description = "return to previous workspace",
            group = "system",
        }
    ),

    --- Navigation Binds

    key({modifierKey}, "j",
        function()
            modules.awful.client.focus.byidx(1)
        end,
        {
            description = "focus next by index",
            group = "navigation",
        }
    ),

    key({modifierKey}, "k",
        function()
            modules.awful.client.focus.byidx(-1)
        end,
        {
            description = "focus previous by index",
            group = "navigation",
        }
    ),
    
    key({modifierKey, "Shift"}, "j",
        function()
            modules.awful.client.swap.byidx(1)
        end,
        {
            description = "swap next by index",
            group = "navigation",
        }
    ),

    key({modifierKey, "Shift"}, "k",
        function()
            modules.awful.client.swap.byidx(-1)
        end,
        {
            description = "swap previous by index",
            group = "navigation",
        }
    ),

    key({modifierKey, "Control"}, "j",
        function()
            modules.awful.screen.focus_relative(1)
        end,
        {
            description = "focus next screen",
            group = "navigation",
        }
    ),

    key({modifierKey, "Control"}, "k",
        function()
            modules.awful.screen.focus_relative(1)
        end,
        {
            description = "focus next screen",
            group = "navigation",
        }
    ),

    key({modifierKey}, "u",
        modules.awful.client.urgent.jumpto,
        {
            description = "focus previous by index",
            group = "navigation",
        }
    ),

    key({modifierKey}, "Tab",
        function()
            modules.awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {
            description = "focus last window",
            group = "navigation",
        }
    )

)

--- Keybinds which affect the currently selected window.
windowKeybinds = modules.gears.table.join(

    key({modifierKey}, "f",
        function(Window)
            if Window.maximized == true then
                Window.maximized = false
            end
            modules.awful.client.floating.toggle()
            Window:raise()
        end,
        {
            description = "toggle floating on window",
            group = "window",
        }
    ),

    -- key({modifierKey, "Control"}, "f",
    --     function(Window)
    --         Window.maximized = not Window.maximized
    --         Window:raise()
    --     end,
    --     {
    --         description = "toggle maximized window",
    --         group = "window",
    --     }
    -- ),

    key({modifierKey, "Control", "Shift"}, "f",
        function(Window)
            Window.fullscreen = not Window.fullscreen
            Window:raise()
        end,
        {
            description = "fullscreen window",
            group = "window",
        }
    ),

    key({}, "Print",
        scrot_selection,
        {
            description = "fullscreen window",
            group = "window",
        }
    ),

    key({modifierKey, "Shift"}, "q",
        function(Window)
            Window:kill()
        end,
        {
            description = "quit application",
            group = "window",
        }
    ),

    key({modifierKey}, "v",
        function(Window)
            Window.ontop = not Window.ontop
        end,
        {
            description = "pin window to top",
            group = "window",
        }
    )

)

--- This for loop is responsible for generating the keybinds of the workspaces.
for i = 1, 9 do
    globalKeybinds = modules.gears.table.join(globalKeybinds,

        key({modifierKey}, "#" .. i+9,
            function()
                local Screen = modules.awful.screen.focused()
                local Workspace = Screen.tags[i]
                if Workspace then
                    Workspace:view_only()
                end
            end,
            {
                description = "view workspace #"..i,
                group = "workspaces",
            }
        ),

        key({modifierKey, "Control"}, "#" .. i+9,
            function()
                local Screen = modules.awful.screen.focused()
                local Workspace = Screen.tags[i]
                if Workspace then
                    modules.awful.tag.viewtoggle(Workspace)
                end
            end,
            {
                description = "toggle view of workspace #"..i,
                group = "workspaces",
            }
        ),

        key({modifierKey, "Shift"}, "#" .. i+9,
            function()
                if client.focus then
                    local Workspace = client.focus.screen.tags[i]
                    if Workspace then
                        client.focus:move_to_tag(Workspace)
                    end
               end
            end,
            {
                description = "move window to workspace #"..i,
                group = "workspaces",
            }
        ),

        key({modifierKey, "Shift"}, "#" .. i+9,
            function()
                if client.focus then
                    local Workspace = client.focus.screen.tags[i]
                    if Workspace then
                        client.focus:toggle_tag(Workspace)
                    end
               end
            end,
            {
                description = "move window to workspace #"..i,
                group = "workspaces",
            }
        )

    )
end

mouseHoverAction = modules.gears.table.join(
    mouseBind({}, 1,
        function(Window)
            Window:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    
    mouseBind({modifierKey}, 1,
        function(Window)
            Window:emit_signal("request::activate", "mouse_click", {raise = true})
            modules.awful.mouse.client.move(Window)
        end
    ),

    mouseBind({modifierKey}, 3,
        function(Window)
            Window:emit_signal("request::activate", "mouse_click", {raise = true})
            modules.awful.mouse.client.resize(Window)
        end
    )

)
root.keys(globalKeybinds)

---------------------------------------------------------------------------------------

--[[

Window rules.

Format: 
{
    rule = {}
    properties = {}
}

Rules that use "rule_any" must specify window properties in xorg in their 
"rule" table.

Widgets use flex boxes, similar to HTML elements with flex boxes.
Widgets align left to right, and stack across the entire panel.

--]]
local button = modules.awful.button

modules.awful.rules.rules = require("rules.global")

client.connect_signal("manage", function(Window)

    if awesome.startup
    and not Window.size_hints.user_position
    and not window.size_hints.program_position
    then
        modules.awful.placement.no_offscreen(Window)
    end

end)

client.connect_signal("request::titlebars", function(Window)

    modules.awful.titlebar(Window):setup(widgets.titlebar.createTitlebarForWindow(Window))

end)

--- Mouse focus
client.connect_signal("mouse::enter", function(Window)

    Window:emit_signal("request::activate", "mouse_enter", {raise = false})

end)

--- Changing border color on focus.
client.connect_signal("focus", function(Window)
    Window.border_color = modules.beautiful.border_focus
end)
client.connect_signal("unfocus", function(Window)
    Window.border_color = modules.beautiful.border_normal
end)

-- Autorun Programs
if autorun then
    
    for index, table in pairs(autorunApps) do

        if table.term == true then
            modules.awful.spawn.with_shell(table.exec)
        else
            modules.awful.spawn(table.exec)
        end

    end

end