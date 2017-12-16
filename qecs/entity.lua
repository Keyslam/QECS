local Entity = {
   entities = {},
   open     = {}
}
local Entity_MT = {__index = Entity}

local function getOpen()
   local c = #Entity.open

   if c > 0 then
      local e = Entity.open[c]
      Entity.open[c] = nil

      return e
   else
      return setmetatable({
         id   = #Entity.entities + 1,
         keys = {},
      }, Entity_MT)
   end
end

function Entity.new()
   local e = getOpen()

   Entity.entities[e.id] = e

   return e
end

function Entity:destroy()
   Entity.entities[self.id] = nil
   Entity.open[#Entity.open + 1] = self
end

function Entity:add(component, ...)
   return component:initialize(self, ...)
end

function Entity:get(component)
   return component:get(self)
end

return setmetatable(Entity, {
   __call = function(_, ...) return Entity.new(...) end,
})
