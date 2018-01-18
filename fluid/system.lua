local PATH = (...):gsub('%.[^%.]+$', '')

local Component = require(PATH..".component")
local Pool      = require(PATH..".pool")

local System = {}
System.__index = System

function System.new(...)
   local system = setmetatable({
      __all   = {},
      __pools = {},
   }, System)

   for _, filter in pairs({...}) do
      local pool = system:buildPool(filter)
      if not system[pool.__name] then
         system[pool.__name]                 = pool
         system.__pools[#system.__pools + 1] = pool
      else
         error("Pool with name '"..pool.__name.."' already exists.")
      end
   end

   return system
end

function System:buildPool(pool)
   local name   = "pool"
   local filter = {}

   for i, v in ipairs(pool) do
      if type(v) == "table" then
         filter[#filter + 1] = v
      elseif type(v) == "string" then
         name = v
      end
   end

   return Pool(name, filter)
end

function System:check(e)
   local added = false

   for _, pool in ipairs(self.__pools) do
      if pool:check(e) then
         self:entityAddedTo(e, pool)

         if not self.__all[e] then
            self.__all[e] = 0
            self:entityAdded(e)
         end

         self.__all[e] = self.__all[e] + 1
         added = true
      end
   end

   return added
end

function System:remove(e)
   for _, pool in ipairs(self.__pools) do
      if pool:remove(e) then
         self:entityRemovedFrom(e, pool)

         self.__all[e] = self.__all[e] - 1
         if self.__all[e] == 0 then
            self.__all[e] = nil
            self:entityRemoved(e, removedFrom)
         end
      end
   end
end

function System:has(e)
   return self.__all[e] and true
end

function System:entityAdded(e)
end

function System:entityAddedTo(e, pool)
end

function System:entityRemoved(e)
end

function System:entityRemovedFrom(e, pool)
end

return setmetatable(System, {
   __call = function(_, ...) return System.new(...) end,
})
