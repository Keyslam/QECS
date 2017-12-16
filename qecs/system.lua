local Component = require("qecs.component")

local System = {}
local System_MT = {__index = System}

function System.new(filter)
   return setmetatable({
      entities = {},
      filter   = filter,
   }, System_MT)
end

function System:update(dt)
end

function System:draw()
end

function System:checkPool(e)
   local allowed = true

   for i = 1, #self.filter do
      local component = self.filter[i]

      if not component:has(e) then
         allowed = false
         break
      end
   end

   if allowed then
      local key = #self.entities + 1

      e.keys[self] = key
      self.entities[key] = e
   end
end

function System:removeFromPool(e)
   local key = e.keys[self]
   local c   = #self.entities

   if key == c then
      self.entities[key] = nil
   else
      local ne = self.entities[c]
      
      self.entities[key] = ne
      self.entities[c]   = nil
      ne.keys[self]      = key
   end
end

return setmetatable(System, {
   __call = function(_, ...) return System.new(_, ...) end,
})
