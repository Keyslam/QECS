local Component = {
   components = {},
}
local Component_MT = {__index = Component}

function Component.new(name, populate)
   local component = setmetatable({
      name     = name,
      populate = populate,
   }, Component_MT)

   Component.components[name] = component

   return component
end

function Component:initialize(e, ...)
   local bag = {}
   self.populate(bag, ...)
   return bag
end

function Component.populate(e, ...)
end

return setmetatable(Component, {
   __call = function(_, ...) return Component.new(...) end,
})
