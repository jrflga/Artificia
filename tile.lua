local Tile = {}

function Tile:new(x, y)
  local tile = {}

  tile.x = x or 0
  tile.y = y or 0

  function tile:setPosition(x, y)
    self.x = x
    self.y = y
  end

  function tile:getPosition()
    return self.x, self.y
  end

  function tile:draw()
    love.graphics.rectangle('fill', self.x, self.y, 32, 32)
  end

  return tile

end

return Tile
