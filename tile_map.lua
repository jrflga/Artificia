local Renderer = require "renderer"
local LoopManager = require "loop_manager"
local tile = require "tile"
local Tilemap = {}

loopmngr = LoopManager:create()
renderer = Renderer:create()

local map = {}

function Tilemap:create(initPosX, initPosY, mapsizeX, mapsizeY, tileGap)
  local tilemap = {}

  function tilemap:load()
    loopmngr:add(self)
    renderer:add(self)
  end

  function tilemap:tick(dt)
    for i=0, mapsizeX do
      tilemap[i] = {}
      for j=0, mapsizeY do
        tilemap[i][j] = tile:new(initPosX + (i * (32 + tileGap)), initPosY + (j * (32 + tileGap)))
      end
    end
  end

  function tilemap:draw()
    for i=0, mapsizeX do
  		for j=0, mapsizeY do
  			tilemap[i][j]:draw()
  		end
  	end
  end

  return tilemap
end
return Tilemap
