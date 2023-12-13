-- local modules = {}
-- modules.beautiful = require("beautiful")

return 
{
    { --- Standard rules
        rule = {},
        properties = 
        {
            border_width = modules.beautiful.border_width,
            border_color = modules.beautiful.border_normal,
            maximized = false,
            focus = modules.awful.client.focus.filter,
            raise = true,
            keys = windowKeybinds,
            buttons = mouseHoverAction,
            screen = modules.awful.screen.preferred,
            placement = modules.awful.placement.no_overlap+modules.awful.placement.no_offscreen,
        },
    },

    { --- Floating windows

        rule_any = 
        {
            instance = 
            {
                "kitty",
            },
            class = 
            {
                "kitty",
            },
            name = 
            {

            },
            role = 
            {
                "AlarmWindow",
                "ConfigManager",
                "pop-up",
                "popup",
            }
        },
        properties = 
        {
            floating = true,
            ontop = true,
        }

    },

        { --- Floating windows

        rule_any = 
        {
        type = 
        {
            "normal",
            "dialog",
        },
        },
        properties = 
        {
            titlebars_enabled = true,
        }

    },

        { --- No titlebars

            rule_any = 
            {
                instance = 
                {

                },
                class = 
                {
                    "kitty",
                    "rofi",
                    "librewolf",
                }, 
            },
            properties = 
            {
                titlebars_enabled = false,
            }

    },
}