local PATH = (...):gsub('%.[^%.]+$', '')

local Event = {}
Event.__index = Event
Event.__call  = function(self, ...) return self:populate(...) end

function Event.new(name, ...)
   local event = setmetatable({
      name = name,
      keys = {...},
   }, Event)

   return event
end

function Event:populate(...)
   local values = {...}

   local bag = {
      __name      = self.name,
      __satisfied = false,
   }

   for i = 1, #values do
      bag[self.keys[i]] = values[i]
   end

   return bag
end

Event.update = Event.new("update", "dt")
Event.draw   = Event.new("draw")
Event.quit   = Event.new("quit")

Event.keypressed  = Event.new("keypressed", "key", "scancode", "isrepeat")
Event.keyreleased = Event.new("keyreleased", "key", "scancode")

Event.mousepressed  = Event.new("mousepressed", "x", "y", "button", "istouch")
Event.mousereleased = Event.new("mousereleased", "x", "y", "button", "istouch")
Event.mousemoved    = Event.new("mousemoved", "x", "y", "dx", "dy", "istouch")
Event.wheelmoved    = Event.new("wheelmoved", "x", "y")

Event.textedited = Event.new("textedited", "text", "start", "length")
Event.textinput  = Event.new("textinput", "text")

Event.touchmoved    = Event.new("touchmoved", "id", "x", "y", "dx", "dy", "pressure")
Event.touchpressed  = Event.new("touchpressed", "id", "x", "y", "dx", "dy", "pressure")
Event.touchreleased = Event.new("touchreleased", "id", "x", "y", "dx", "dy", "pressure")

Event.joystickadded    = Event.new("joystickadded", "joystick")
Event.joystickremoved  = Event.new("joystickremoved", "joystick")
Event.joystickpressed  = Event.new("joystick", "button")
Event.joystickreleased = Event.new("joystickreleased", "joystick", "button")
Event.joystickaxis     = Event.new("joystickaxis", "joystick", "axis", "value")
Event.joystickhat      = Event.new("joystickhat", "joystick", "hat", "direction")

Event.gamepadpressed  = Event.new("gamepadpressed", "joystick", "button")
Event.gamepadreleased = Event.new("gamepadreleased", "joystick", "button")
Event.gamepadaxis     = Event.new("gamepadaxis", "joystick", "axis", "value")

Event.filedropped      = Event.new("filedropped", "file")
Event.directorydropped = Event.new("directorydropped", "path")

Event.focus      = Event.new("focus", "focus")
Event.mousefocus = Event.new("mousefocus", "focus")
Event.visible    = Event.new("visible", "visible")
Event.resize     = Event.new("resize", "w", "h")

Event.lowmemory   = Event.new("lowmemory")
Event.threaderror = Event.new("threaderror", "thread", "errorstr")
Event.errhandler  = Event.new("errhandler", "msg")

return setmetatable(Event, {
   __call = function(_, ...) return Event.new(...) end,
})
