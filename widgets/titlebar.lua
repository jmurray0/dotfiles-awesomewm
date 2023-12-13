--[[

"titlebar.lua"
A descriptor widget for the titlebars of awesomeWM.
Jayden Lee Murray / jmurray0 (jayden.murray@arrowhead.systems)

--]]
---> Variables
local button = modules.awful.button

titlebarKeybinds = modules.gears.table.join(

    button({}, 1,
        function()
            Window:emit_signal("request::activate", "titlebar", {raise = true})
            modules.awful.mouse.client.move(Window)
        end
    ),

    button({}, 3,
        function()
            Window:emit_signal("request::activate", "titlebar", {raise = true})
            modules.awful.mouse.client.resize(Window)
        end
    )
    
)

--[[

These  functions are responsible for creating the widgets in awesomeWM.
They do not need to be modified.

--]]
export = 
{

    createTitlebarForWindow = function(Window)
        local configTable = 
        {
            
            { --- Left align
                layout = modules.wibox.layout.fixed.horizontal,
                buttons = titlebarKeybinds,

                modules.awful.titlebar.widget.iconwidget(Window)
            },
            { --- Center align
                layout = modules.wibox.layout.flex.horizontal,
                buttons = titlebarKeybinds,

                {
                    align = "center",
                    widget = modules.awful.titlebar.widget.titlewidget(Window),
                },
            },
            { --- Left align
                modules.awful.titlebar.widget.floatingbutton(Window),
                modules.awful.titlebar.widget.maximizedbutton(Window),
                modules.awful.titlebar.widget.ontopbutton(Window),
                modules.awful.titlebar.widget.closebutton(Window),
                layout = modules.wibox.layout.align.horizontal,
            },
            layout = modules.wibox.layout.align.horizontal
        }
        return configTable
    end

}

return export