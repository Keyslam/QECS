local PATH = (...):gsub('%.init$', '')

local Fluid = {}

function Fluid.init(settings)
   Fluid.entity       = require(PATH..".entity")
   Fluid.component    = require(PATH..".component")
   Fluid.system       = require(PATH..".system")
   Fluid.instance     = require(PATH..".instance")
   Fluid.event        = require(PATH..".event")
   Fluid.eventManager = require(PATH..".eventManager")

   if settings and settings.useEvents then
      Fluid.instances = {}

      Fluid.addInstance = function(instance)
         table.insert(Fluid.instances, instance)
      end

      Fluid.removeInstance = function(instance)
         for i, instance in ipairs(Fluid.instances) do
            table.remove(Fluid.instances, i)
            break
         end
      end

      love.run = function()
         if love.math then
            love.math.setRandomSeed(os.time())
         	love.timer.step()
      	end

         for _, instance in ipairs(Fluid.instances) do
            instance:emit(Fluid.event.load(arg))
         end

      	if love.timer then love.timer.step() end

      	local dt = 0

      	while true do
      		if love.event then
      			love.event.pump()
      			for name, a, b, c, d, e, f in love.event.poll() do
                  local event = Fluid.event[name](a, b, c, d, e, f)

                  if name == "quit" then
                     event.__satisfied = true
                  end

                  for _, instance in ipairs(Fluid.instances) do
                     instance:emit(event)
                  end

                  if name == "quit" and event.__satisfied then
                     return a
                  end
      			end
      		end

      		if love.timer then
      			love.timer.step()
      			dt = love.timer.getDelta()
      		end

            for _, instance in ipairs(Fluid.instances) do
               instance:emit(Fluid.event.update(dt))
            end

            for _, instance in ipairs(Fluid.instances) do
               instance.eventManager:process()
            end

      		if love.graphics and love.graphics.isActive() then
      			love.graphics.clear(love.graphics.getBackgroundColor())
      			love.graphics.origin()

               for _, instance in ipairs(Fluid.instances) do
                  instance:emit(Fluid.event.draw())
               end

      			love.graphics.present()
      		end

      		if love.timer then love.timer.sleep(0.001) end
      	end
      end
   end

   return Fluid
end

return Fluid
