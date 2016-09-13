local lue = require "lib/lue/lue"

local Renderer = require "renderer"
local LoopManager = require "loop_manager"
local Tilemap = require "tile_map"

local mapsizeX, mapsizeY = 10, 10  -- TODO: Min 4x4, Max 64x32 -> User must pick size
local initPosX, initPosY = 20, 60
local tileSize = 16

modeoptions = "Pick a mode (1 - Clear, 2 - Wall, 3 - Water, 4 - Point A or 5 - Point B)"
clickmode = "Clear"
tipColor = nil

pointA, pointB = {}, {}

renderer = Renderer:create()
loopmngr = LoopManager:create()
tilemap = Tilemap:create(initPosX, initPosY, mapsizeX, mapsizeY, tileSize)

gTime = 0

function love.load()
  tilemap:load()
  pointA = {x = 0, y = 0}
  pointB = {x = mapsizeX-1, y = mapsizeY-1}

  font = love.graphics.newImageFont("gfx/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
  love.graphics.setFont(font)

  tipColor = lue:newColor():setColor({50, 50, 50})
end

function love.update(dt)
  gTime = gTime + dt
  --print(gTime)
  love.window.setTitle(" Bx: " .. pointB.x .. " By:" .. pointB.y .. " Artificia - " .. love.timer.getFPS() .. " FPS")
  loopmngr:update(dt)
  lue:update(dt)
end

function love.draw()
  renderer:draw()
  love.graphics.setColor({50, 50, 50})
  love.graphics.print(modeoptions, 10, 10)
  love.graphics.setColor(tipColor:getColor())
  love.graphics.print(clickmode, 10, 30)
  love.graphics.setColor({200, 50, 50})
  love.graphics.print("Ax: " .. pointA.x .. " Ay:" .. pointA.y, 650, 10)
  love.graphics.setColor({50, 200, 50})
  love.graphics.print("Bx: " .. pointB.x .. " By:" .. pointB.y, 650, 30)
end

function love.keypressed(k)
  if k == "escape" then love.event.quit() end
  if k == "1" then clickmode = "Clear"   tipColor:setColor({50, 50, 50}) end
  if k == "2" then clickmode = "Wall"    tipColor:setColor({65, 65, 75})   end
  if k == "3" then clickmode = "Water"   tipColor:setColor({52, 152, 219}) end
  if k == "4" then clickmode = "Point A" tipColor:setColor({200, 50, 50})  end
  if k == "5" then clickmode = "Point B" tipColor:setColor({50, 200, 50})  end
end
