local Tile = {}

function Tile:new(x, y, mode, color, tileSize)
  local tile = {}

  tile.x = x or 0
  tile.y = y or 0
  tile.mode = mode or "line"
  tile.color = color or COLOR.GREY
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
      -- if Clear, check if it's the same position as the Points, then set the color and mode
      if clickmode == "Clear" then
        if (pointA.x == pos.x and pointA.y == pos.y)
        or (pointB.x == pos.x and pointB.y == pos.y) then
          print("Cannot clear main Points")
        else
          self.mode = "line"
          self.color = tipColor:getColor()
        end
      else
        self.mode = "fill"
        -- if Point A, check if it's the same position as Point B, then set the color
        if clickmode == "Point A" then
          if pointB.x == pos.x and pointB.y == pos.y then
            print("Point A can't be on the same spot as Point B")
          else
            tilemap[pointA.x][pointA.y].color = COLOR.GREY
            tilemap[pointA.x][pointA.y].mode = "line"
            tilemap[pos.x][pos.y].color = COLOR.RED
            tilemap[pos.x][pos.y].mode = "fill"
            pointA = { x = pos.x, y = pos.y }
            self.color = tipColor:getColor()
          end
        -- if Point B, check if it's the same position as Point A, then set the color
        elseif clickmode == "Point B" then
          if pointA.x == pos.x and pointA.y == pos.y then
            print("Point B can't be on the same spot as Point A")
          else
            tilemap[pointB.x][pointB.y].color = COLOR.GREY
            tilemap[pointB.x][pointB.y].mode = "line"
            tilemap[pos.x][pos.y].color = COLOR.GREEN
            tilemap[pos.x][pos.y].mode = "fill"
            pointB = { x = pos.x, y = pos.y }
            self.color = tipColor:getColor()
          end
        -- if Wall or Water, check if it's the same position as Points, then set the color
        elseif clickmode == "Wall" or clickmode == "Water" then
          if (pointA.x == pos.x and pointA.y == pos.y)
          or (pointB.x == pos.x and pointB.y == pos.y) then
            print("Cannot replace main Points")
          else
            self.color = tipColor:getColor()
          end
        end
      end
    end
  end

  return tile

end

return Tile