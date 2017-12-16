local Component = {}
Component.__index = Component

function Component.new(populate)
   local component = setmetatable({
      populate = populate,
   }, Component)

   return component
end

function Component:initialize(e, ...)
   if self.populate then
      local bag = {}
      self.populate(bag, ...)
      return bag
   end

   return true
end

--[[
function Component.populate(e, ...)
end
]]

return setmetatable(Component, {
   __call = function(_, ...) return Component.new(...) end,
})
