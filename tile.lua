Object = require "lib/classic"

Tile = Object:extend()

function Tile:new(x, y)
  self.x = x or 0
  self.y = y or 0
end
