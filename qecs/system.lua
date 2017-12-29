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
         system[pool.__name]             = pool
         system.__pools[#system.__pools] = pool
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

function System:update(dt)
end

function System:draw()
end

function System:check(e)
   local addedTo = {}

   for _, pool in pairs(self.__pools) do
      if pool:check(e) then
         addedTo[#addedTo + 1] = pool
      end
   end

   if #addedTo > 0 then
      if not self.__all[e] then
         self.__all[e] = 0
      end

      self.__all[e] = self.__all[e] + 1
      self:entityAdded(e, addedTo)

      return true
   end
end

function System:remove(e)
   local removedFrom = {}

   for _, pool in pairs(self.__pools) do
      if pool:remove(e) then
         removedFrom[#removedFrom + 1] = pool
      end
   end

   if #removedFrom > 0 then
      for _, pool in ipairs(removedFrom) do
         self:entityRemovedAny(e, pool)
      end

      self.__all[e] = self.__all[e] - #removedFrom
      if self.__all[e] == 0 then
         self.__all[e] = nil
         self:entityRemoved(e, removedFrom)
      end
   end
end

function System:has(e)
   return self.__all[e] and true
end

function System:entityAdded(e, pools)
end

function System:entityRemoved(e, pools)
end

function System:entityRemovedAny(e, pool)
end

return setmetatable(System, {
   __call = function(_, ...) return System.new(...) end,
})
