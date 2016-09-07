local Renderer = {}

local layersMax = 2
local insert = table.insert
local remove = table.remove

function Renderer:create()
  local renderer = {}

  renderer.drawers = {}
  for i = 0, layersMax do
    renderer.drawers[i] = {}
  end

  function renderer:add(obj, layer)
    insert(self.drawers[layer or 0], obj)
  end

  function renderer:draw()
    for layer = 0, #self.drawers do
      for i = 0, #self.drawers[layer] do
        local obj = self.drawers[layer][i]
        if obj ~= nil then
          love.graphics.clear()
          obj:draw()
        end
      end
    end
  end
  return renderer
end
return Renderer
