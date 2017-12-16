local Component = {
   components = {},
}
local Component_MT = {__index = Component}

function Component.new(name, populate)
   local component = setmetatable({
      name     = name,
      populate = populate,

      entities = {},
   }, Component_MT)

   Component.components[name] = component

   return component
end

function Component:initialize(e, ...)
   local bag = self.entities[e.id] or {}

   self.populate(bag, ...)
   self.entities[e.id] = bag

   return bag
end

function Component.populate(e, ...)
end

function Component:has(e)
   return self.entities[e.id] and true
end

function Component:get(e)
   return self.entities[e.id]
end

return setmetatable(Component, {
   __call = function(_, ...) return Component.new(...) end,
})
