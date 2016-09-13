local Tile = {}

function Tile:new(x, y, mode, color, tileSize)
  local tile = {}

  tile.x = x or 0
  tile.y = y or 0
  tile.mode = mode or "line"
  tile.color = color or {50, 50, 50}
  tile.tileSize = tileSize or 32

  function tile:setPosition(x, y)
    self.x = x
    self.y = y
  end

  function tile:getPosition()
    return self.x, self.y
  end

  function tile:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle(self.mode, self.x, self.y, tile.tileSize, tile.tileSize)
  end

  function tile:checkCollision(x, y, clicking, pos)

    if clicking == true
      and x >= self.x and x <= self.x + tile.tileSize
      and y >= self.y and y <= self.y + tile.tileSize
    then
      if clickmode == "Clear" then
        self.mode = "line"
      else
        self.mode = "fill"
        if clickmode == "Point A" then
          tilemap[pointA.x][pointA.y].color = {50, 50, 50}
          tilemap[pointA.x][pointA.y].mode = "line"
          pointA = { x = pos.x, y = pos.y }
        elseif clickmode == "Point B" then
          tilemap[pointB.x][pointB.y].color = {50, 50, 50}
          tilemap[pointB.x][pointB.y].mode = "line"
          pointB = { x = pos.x, y = pos.y }
        end
      end
      self.color = tipColor:getColor()
    end
  end

  return tile

end

return Tile
