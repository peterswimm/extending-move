-- move-display mod for Norns
-- Automatically redirects display output to Move device
-- Install in: /home/we/dust/code/move-display/lib/mod.lua

local mod = require 'core/mods'
local osc = require 'osc'

local move_display = {}

-- Configuration
move_display.enabled = true
move_display.host = "move.local"  -- Change to your Move device IP if needed
move_display.port = 10111
move_display.debug = false

-- OSC client
local osc_client = nil

-- Original screen functions
local original_screen = {}

-- Initialize the mod
function move_display.init()
    -- Create OSC client
    osc_client = osc.new {
        host = move_display.host,
        port = move_display.port
    }
    
    -- Store original screen functions
    for k, v in pairs(screen) do
        if type(v) == "function" then
            original_screen[k] = v
        end
    end
    
    -- Wrap screen functions
    move_display.wrap_screen()
    
    print("Move Display: Initialized (sending to " .. move_display.host .. ":" .. move_display.port .. ")")
end

-- Wrap screen functions to send OSC
function move_display.wrap_screen()
    -- Clear
    screen.clear = function()
        if move_display.enabled then
            osc_client:send("/screen/clear")
        end
        return original_screen.clear()
    end
    
    -- Level (brightness)
    screen.level = function(l)
        if move_display.enabled then
            osc_client:send("/screen/level", {l})
        end
        return original_screen.level(l)
    end
    
    -- Move
    screen.move = function(x, y)
        if move_display.enabled then
            osc_client:send("/screen/move", {x, y})
        end
        return original_screen.move(x, y)
    end
    
    -- Move relative
    screen.move_rel = function(x, y)
        if move_display.enabled then
            osc_client:send("/screen/move_rel", {x, y})
        end
        return original_screen.move_rel(x, y)
    end
    
    -- Line
    screen.line = function(x, y)
        if move_display.enabled then
            osc_client:send("/screen/line", {x, y})
        end
        return original_screen.line(x, y)
    end
    
    -- Line relative
    screen.line_rel = function(x, y)
        if move_display.enabled then
            osc_client:send("/screen/line_rel", {x, y})
        end
        return original_screen.line_rel(x, y)
    end
    
    -- Rectangle
    screen.rect = function(x, y, w, h)
        if move_display.enabled then
            osc_client:send("/screen/rect", {x, y, w, h})
        end
        return original_screen.rect(x, y, w, h)
    end
    
    -- Circle
    screen.circle = function(x, y, r)
        if move_display.enabled then
            osc_client:send("/screen/circle", {x, y, r})
        end
        return original_screen.circle(x, y, r)
    end
    
    -- Text
    screen.text = function(s)
        if move_display.enabled then
            osc_client:send("/screen/text", {s})
        end
        return original_screen.text(s)
    end
    
    -- Text centered
    screen.text_center = function(s)
        if move_display.enabled then
            osc_client:send("/screen/text_center", {s})
        end
        return original_screen.text_center(s)
    end
    
    -- Text right aligned
    screen.text_right = function(s)
        if move_display.enabled then
            osc_client:send("/screen/text_right", {s})
        end
        return original_screen.text_right(s)
    end
    
    -- Fill
    screen.fill = function()
        if move_display.enabled then
            osc_client:send("/screen/fill")
        end
        return original_screen.fill()
    end
    
    -- Stroke
    screen.stroke = function()
        if move_display.enabled then
            osc_client:send("/screen/stroke")
        end
        return original_screen.stroke()
    end
    
    -- Pixel
    screen.pixel = function(x, y)
        if move_display.enabled then
            osc_client:send("/screen/pixel", {x, y})
        end
        return original_screen.pixel(x, y)
    end
    
    -- Update (refresh display)
    screen.update = function()
        if move_display.enabled then
            osc_client:send("/screen/update")
        end
        return original_screen.update()
    end
    
    -- Anti-aliasing
    screen.aa = function(state)
        if move_display.enabled then
            osc_client:send("/screen/aa", {state and 1 or 0})
        end
        return original_screen.aa(state)
    end
    
    -- Line width
    screen.line_width = function(w)
        if move_display.enabled then
            osc_client:send("/screen/line_width", {w})
        end
        return original_screen.line_width(w)
    end
    
    -- Font face
    screen.font_face = function(i)
        if move_display.enabled then
            osc_client:send("/screen/font_face", {i})
        end
        return original_screen.font_face(i)
    end
    
    -- Font size
    screen.font_size = function(s)
        if move_display.enabled then
            osc_client:send("/screen/font_size", {s})
        end
        return original_screen.font_size(s)
    end
end

-- Toggle display mirroring
function move_display.toggle()
    move_display.enabled = not move_display.enabled
    print("Move Display: " .. (move_display.enabled and "Enabled" or "Disabled"))
end

-- Set host
function move_display.set_host(host)
    move_display.host = host
    osc_client = osc.new {
        host = move_display.host,
        port = move_display.port
    }
    print("Move Display: Host set to " .. host)
end

-- Set port
function move_display.set_port(port)
    move_display.port = port
    osc_client = osc.new {
        host = move_display.host,
        port = move_display.port
    }
    print("Move Display: Port set to " .. port)
end

-- Menu for mod configuration
local m = {}

m.key = function(n, z)
    if n == 2 and z == 1 then
        -- Back
        mod.menu.exit()
    elseif n == 3 and z == 1 then
        -- Toggle
        move_display.toggle()
        mod.menu.redraw()
    end
end

m.enc = function(n, d)
    -- Could add encoder controls for settings
end

m.redraw = function()
    screen.clear()
    screen.level(15)
    screen.move(64, 20)
    screen.text_center("MOVE DISPLAY")
    screen.move(64, 30)
    screen.level(3)
    screen.text_center(move_display.host .. ":" .. move_display.port)
    screen.move(64, 40)
    screen.level(15)
    screen.text_center(move_display.enabled and "ENABLED" or "DISABLED")
    screen.move(64, 55)
    screen.level(3)
    screen.text_center("K3: TOGGLE")
    screen.update()
end

m.init = function()
    -- Initialize when menu opens
end

m.deinit = function()
    -- Cleanup when menu closes
end

-- Register the mod
mod.hook.register("script_pre_init", "move-display", function()
    -- Initialize before any script loads
    move_display.init()
end)

-- Add menu
mod.menu.register(mod.this_name, m)

return move_display