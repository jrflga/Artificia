local Renderer = require "renderer"
local LoopManager = require "loop_manager"
local tile = require "tile"
local Tilemap = {}

loopmngr = LoopManager:create()
renderer = Renderer:create()

local map = {}

function Tilemap:create(initPosX, initPosY, mapsizeX, mapsizeY, tileSize)
  local tilemap = {}

  function tilemap:load()
    loopmngr:add(self)
    renderer:add(self)
    for i=0, mapsizeX-1 do
      tilemap[i] = {}
      for j=0, mapsizeY-1 do
        tilemap[i][j] = tile:new(initPosX + (i * (tileSize)), initPosY + (j * (tileSize)), 'line', {50, 50, 50}, tileSize)
      end
    end
  end

  function tilemap:tick(dt)
    for i=0, mapsizeX-1 do
      for j=0, mapsizeY-1 do
        tilemap[i][j]:checkCollision(love.mouse.getX(), love.mouse.getY(), love.mouse.isDown(1), { x = i, y = j})
      end
    end
  end

  function tilemap:draw()
    for i=0, mapsizeX-1 do
  		for j=0, mapsizeY-1 do
  			tilemap[i][j]:draw()
  		end
  	end
    tilemap:drawLine((tilemap[pointA.x][pointA.y]), (tilemap[pointB.x][pointB.y]))
  end

  function tilemap:drawLine(tileA, tileB)
    love.graphics.setColor({255, 255, 255})
    love.graphics.line(tileA.x + tileSize / 2, tileA.y + tileSize / 2, tileB.x + tileSize / 2, tileB.y + tileSize / 2)
  end

  return tilemap
end
return Tilemap
