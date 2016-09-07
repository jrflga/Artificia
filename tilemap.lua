local tile = require "tile"
local Tilemap = {}

local mapsizeX, mapsizeY = 10, 10
local initPosX, initPosY = 180, 60
local tileGap = 4
local map = {}

function Tilemap:create()
  local tilemap = {}

  function tilemap:load()
    for i=1, mapsizeX do
  		tilemap[i] = {}
  		for j=1, mapsizeY do
  			tilemap[i][j] = tile:new(initPosX + (i * (32 + tileGap)), initPosY + (j * (32 + tileGap)))
  		end
  	end
  end

  function tilemap:update(dt)
  end

  function tilemap:draw()
    for i=1, mapsizeX do
  		for j=1, mapsizeY do
  			tilemap[i][j]:draw()
  		end
  	end
  end
  return tilemap
end
return Tilemap
