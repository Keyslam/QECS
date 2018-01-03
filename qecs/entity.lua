local Entity = {
   entities = {},
}
Entity.__index = Entity

function Entity.new()
   local e = setmetatable({
      id         = #Entity.entities + 1,
      components = {},
      systems    = {},
      keys       = {},

      instance = nil,
   }, Entity)

   Entity.entities[e.id] = e

   return e
end

function Entity:give(component, ...)
   local bag = component:initialize(self, ...)
   self.components[component] = bag

   return bag
end

function Entity:check()
   self.instance:checkEntity(self)
end

function Entity:destroy()
   Entity.entities[self.id] = nil
   self.instance:destroyEntity(self)
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
