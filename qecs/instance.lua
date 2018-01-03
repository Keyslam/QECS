local PATH = (...):gsub('%.[^%.]+$', '')

local Pool = require(PATH..".pool")

local Instance = {}
Instance.__index = Instance

function Instance.new()
   local instance = setmetatable({
      entities = Pool(),
      systems  = {},
   }, Instance)

   return instance
end

function Instance:addEntity(e)
   e.instance = self
   self.entities:add(e)
   self:checkEntity(e)
end

function Instance:checkEntity(e)
   for _, system in ipairs(self.systems) do
      if system:check(e) then
         e.systems[#e.systems + 1] = system
      end
   end
end

function Instance:destroyEntity(e)
   self.entities:remove(e)

   for _, system in ipairs(e.systems) do
      system:remove(e)
   end
end

function Instance:addSystem(system)
   self.systems[#self.systems + 1] = system
end

function Instance:callback(name, ...)
   for _, system in ipairs(self.systems) do
      if system[name] then
         system[name](system, ...)
      end
   end
end

function Instance:update(dt)
   self:callback("update", dt)
end

function Instance:draw()
   self:callback("draw")
end

return setmetatable(Instance, {
   __call = function(_, ...) return Instance.new(...) end,
})
