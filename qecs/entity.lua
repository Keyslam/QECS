local Entity = {
   entities = {},
}
Entity.__index = Entity

function Entity.new()
   local e = setmetatable({
      id         = #Entity.entities + 1,
      components = {},
      keys       = {},
   }, Entity)

   Entity.entities[e.id] = e

   return e
end

function Entity:destroy()
   Entity.entities[self.id] = nil
end

function Entity:add(component, ...)
   local bag = component:initialize(self, ...)
   self.components[component] = bag
   return bag
end

function Entity:get(component)
   return self.components[component]
end

function Entity:has(component)
   return self.components[component] and true
end

return setmetatable(Entity, {
   __call = function(_, ...) return Entity.new(...) end,
})
