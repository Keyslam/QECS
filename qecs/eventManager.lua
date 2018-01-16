local EventManager = {}
EventManager.__index = EventManager

function EventManager.new()
   local eventManager = setmetatable({
      queue     = {count = 0},
      listeners = {},
   }, EventManager)

   return eventManager
end

function EventManager:push(event)
   queue.count = queue.count + 1
   queue[queue.count] = event
end

function EventManager:emit(event)
   local listeners = self.listeners[event.__name]

   if listeners then
      for i = 1, #listeners do
         local listener = listeners[i]
         listener(event)
      end
   end
end

function EventManager:register(name, listener)
   local listeners = self.listeners[name]

   if not listeners then
      listeners = {count = 0}
      self.listeners[name] = listeners
   end

   listeners.count = count + 1
   listeners[listeners.count] = listener
end

function EventManager:deregister(name, listener)
   local listeners = self.listeners[name]

   if listeners then
      for index, other in ipairs(listeners) do
         if listener == other then
            table.remove(listeners, index)
            listeners.count = listeners.count - 1

            return
         end
      end
   end
end

function EventManager:process()
   for i = 1, queue.count do
      self:emit(queue[i])
      queue[i] = nil
   end

   queue.count = 0
end

return setmetatable(EventManager, {
   __call = function(_, ...) return EventManager.new(...) end,
})
