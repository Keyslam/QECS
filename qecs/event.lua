local PATH = (...):gsub('%.[^%.]+$', '')

local Event = {}
Event.__index = Event
Event.__call  = function(self, ...) return self:populate(...) end

function Event.new(...)
   local event = setmetatable({
      keys = {...}
   }, Event)

   return event
end

function Event:populate(...)
   local values = {...}

   local bag = {
      __satisfied = false,
   }

   for i = 1, #values do
      bag[self.keys[i]] = values[i]
   end

   return bag
end

return setmetatable(Event, {
   __call = function(_, ...) return Event.new(...) end,
})
