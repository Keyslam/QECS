local Component = {}
Component.__index = Component

function Component.new(populate, inherit)
   local component = setmetatable({
      __populate = populate,
      __inherit  = inherit,
   }, Component)

   if inherit then
      component.__mt = {__index = component}
   end

   return component
end

function Component:initialize(e, ...)
   if self.__populate then
      local bag = {}
      self.__populate(bag, ...)

      if self.__inherit then
         setmetatable(bag, self.__mt)
      end

      return bag
   end

   return true
end

return setmetatable(Component, {
   __call = function(_, ...) return Component.new(...) end,
})
