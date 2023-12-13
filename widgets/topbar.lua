--[[

"topbar.lua"
A descriptor widget for the topbar of awesomeWM.
Jayden Lee Murray / jmurray0 (jayden.murray@arrowhead.systems)

--]]
---> Variables
local button = modules.awful.button

workspacesBinds = modules.gears.table.join(

    button(
        {}, 1,
        function(Workspace)
            Workspace:view_only()
        end
    ),

    button(
        {modifierKey}, 1,
        function(Workspace)
            if client.focus then
                client.focus:move_to_tag(Workspace)
            end
        end
    ),
    
    button(
        {}, 3,
        modules.awful.tag.viewtoggle
    ),

    button(
        {modifierKey}, 1,
        function(Workspace)
            if client.focus then
                client.focus:toggle_tag(Workspace)
            end
        end
    ),

    button(
        {}, 1,
        function(Workspace)
            modules.awful.tag.viewnext(Workspace.screen)
        end
    ),

    button(
        {}, 1,
        function(Workspace)
            modules.awful.tag.viewprev(Workspace.screen)
        end
    )

)

applicationsBinds = modules.gears.table.join(

    button(
        {}, 1,
        function(Tab)
            if Tab == client.focus then
                Tab.minimized = true
            else
                Tab:emit_signal(
                    "request::activate",
                    "tasklist",
                    {raise = true}
                )
            end
        end
    ),

    button(
        {}, 3,
        function()
            modules.awful.menu.client_list({theme = {width = 250}})
        end
    ),

    button(
        {}, 4,
        function()
            modules.awful.client.focus.byidx(1)
        end
    ),
    
    button(
        {}, 5,
        function()
            modules.awful.client.focus.byidx(-1)
        end
    )

)

--[[

These  functions are responsible for creating the widgets in awesomeWM.
They do not need to be modified.

--]]
export = 
{
    createWorkspaceList = function(Screen)
        local workspacesList = modules.awful.widget.taglist{
            screen = Screen,
            filter = modules.awful.widget.taglist.filter.all,
            buttons = workspacesBinds
        }
        return workspacesList
    end,

    createApplicationList = function(Screen)
        local applicationList = modules.awful.widget.tasklist{
            screen = Screen,
            filter = modules.awful.widget.tasklist.filter.currenttags,
            buttons = applicationsBinds
        }
        return applicationList
    end
}

return export