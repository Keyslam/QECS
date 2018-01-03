local PATH = (...):gsub('%.[^%.]+$', '')

local Entity = require(PATH..".entity")

local Assemblage = {}

function Assemblage.new(constructor)
   return setmetatable({
      constructor = constructor,
   }, {
      __index = Assemblage,
      __call  = function(self, ...) return self:create(...) end,
   })
end

function Assemblage:create(...)
   local e = Entity()
   self.constructor(e, ...)
   return e
end

return setmetatable(Assemblage, {
   __call = function(_, ...) return Assemblage.new(...) end,
})
