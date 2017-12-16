local Entity    = require("qecs.entity")
local Component = require("qecs.component")
local System    = require("qecs.system")

local Position = Component(function(e, x, y)
   e.x = x
   e.y = y
end)

local Color = Component(function(e, r, g, b)
   e.r = r
   e.g = g
   e.b = b
end)

local Hello = Component()

local Gravity = System({Position})
function Gravity:update(dt)
   for i = 1, #self.entities do
      local e = self.entities[i]

      local position = e:get(Position)

      position.y = position.y + 100 * dt
   end
end

local RenderRectangle = System({Position})
function RenderRectangle:draw()
   for i = 1, #self.entities do
      local e = self.entities[i]

      local position = e:get(Position)
      local color    = e:get(Color)

      if color then
         love.graphics.setColor(color.r, color.g, color.b)
      else
         love.graphics.setColor(255, 255, 255)
      end

      love.graphics.rectangle("fill", position.x, position.y, 20, 20)

      if e:has(Hello) then
         love.graphics.print("Hello!", position.x, position.y)
      end
   end
end

local Remover = System({Position})
function Remover:update(dt)
   for i = #self.entities, 1, -1 do
      local e = self.entities[i]

      local position = e:get(Position)

      if position.y > 400 then
         e:destroy()

         Gravity:removeFromPool(e)
         RenderRectangle:removeFromPool(e)
         Remover:removeFromPool(e)
      end
   end
end

local t = 0

function love.load()
end

function love.update(dt)
   t = t - dt

   if t <= 0 then
      t = love.math.random(2, 10) / 10

      local e = Entity()
      e:add(Position, love.math.random(100, 300), 0)

      if love.math.random(0, 2) == 1 then
         e:add(Color, love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255))
         e:add(Hello)
      end

      Gravity:checkPool(e)
      RenderRectangle:checkPool(e)
      Remover:checkPool(e)
   end

   Gravity:update(dt)
   Remover:update(dt)
end

function love.draw()
   RenderRectangle:draw()
end
