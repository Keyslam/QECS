local Fluid = require("Fluid")

local Instance = Fluid.instance()
local Score    = 0

local Position = Fluid.component(function(e, x, y)
   e.x = x
   e.y = y
end)

local Color = Fluid.component(function(e, r, g, b)
   e.r = r
   e.g = g
   e.b = b
end)

local Clickable = Fluid.component()
local Clicked   = Fluid.component()

local Block = Fluid.assemblage(function(e, x, y, r, g, b)
   e:give(Position, x or 0, y or 0)
   e:give(Color,    r or 0, g or 0, b or 0)
   e:give(Clickable)
end)

local Spawner = Fluid.system()
Spawner.timeLeft = 0
Spawner.maxTime  = 1

function Spawner:update(ev)
   Spawner.timeLeft = Spawner.timeLeft - ev.dt

   if Spawner.timeLeft <= 0 then
      Spawner.timeLeft = Spawner.timeLeft + Spawner.maxTime

      local x, y    = love.math.random(0, 320), love.math.random(0, 320)
      local r, g, b = love.math.random(60, 255), love.math.random(60, 255), love.math.random(60, 255)

      local block = Block(x, y, r, g, b)

      Instance:addEntity(block)
   end
end

local RectangleRenderer = Fluid.system({Position, Color})

function RectangleRenderer:draw()
   for _, e in ipairs(self.pool) do
      local position = e:get(Position)
      local color    = e:get(Color)

      love.graphics.setColor(color.r, color.g, color.b)
      love.graphics.rectangle("fill", position.x, position.y, 20, 20)
   end
end

local Remover = Fluid.system({Clicked})

function Remover:update(dt)
   for _, e in ipairs(self.pool) do
      Instance:destroyEntity(e)
      Score = Score + 10
   end
end

local Clicker = Fluid.system({Clickable, Position})

function Clicker:mousepressed(ev)
   for _, e in ipairs(self.pool) do
      local position = e:get(Position)

      if ev.x > position.x and ev.x < position.x + 20 and
         ev.y > position.y and ev.y < position.y + 20 then

         e:give(Clicked)
         e:check()
      end
   end
end

Instance:addSystem(Spawner, "update")
Instance:addSystem(RectangleRenderer, "draw")
Instance:addSystem(Remover, "update")
Instance:addSystem(Clicker, "mousepressed")

function love.load()
end

function love.update(dt)
   Instance:update(dt)
end

function love.draw()
   Instance:draw()

   love.graphics.setColor(255, 255, 255)
   love.graphics.print(Score, 10, 10)
end

function love.mousepressed(x, y)
   Instance:emit(Fluid.event.mousepressed(x, y))
end
