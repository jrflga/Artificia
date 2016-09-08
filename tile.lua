local Tile = {}

function Tile:new(x, y, mode)
  local tile = {}

  tile.x = x or 0
  tile.y = y or 0
  tile.mode = mode or 'line'

  function tile:setPosition(x, y)
    self.x = x
    self.y = y
  end

  function tile:getPosition()
    return self.x, self.y
  end

  function tile:draw(mode)
    love.graphics.rectangle(self.mode, self.x, self.y, 32, 32)
  end

  function tile:checkCollision(x, y, state, i, j)

    if  state == true
    and x > self.x and x < self.x + 32
    and y > self.y and y < self.y + 32
    then
      --love.window.setTitle("X: " .. self.x .. " Y: " .. self.y .. " i: " .. i .. " j: " .. j .. " mode: " .. self.mode)
      self.mode = 'fill'
    end
  end

  return tile

end

return Tile
