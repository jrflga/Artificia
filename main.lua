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

COLOR = {
  RED = { 200, 50, 50 },
  GREY = { 50, 50, 50 },
  WALL = { 65, 65, 75 },
  BLUE = { 52, 152, 219 },
  GREEN = { 50, 200, 50 }
}

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

  tipColor = lue:newColor():setColor(COLOR.GREY)

  tilemap[pointA.x][pointA.y].color = COLOR.RED
  tilemap[pointA.x][pointA.y].mode = "fill"
  tilemap[pointB.x][pointB.y].color = COLOR.GREEN
  tilemap[pointB.x][pointB.y].mode = "fill"
end

function love.update(dt)
  gTime = gTime + dt
  --print(gTime)
  love.window.setTitle("Artificia - " .. love.timer.getFPS() .. " FPS")
  loopmngr:update(dt)
  lue:update(dt)
end

function love.draw()
  renderer:draw()
  love.graphics.setColor(COLOR.GREY)
  love.graphics.print(modeoptions, 10, 10)
  love.graphics.setColor(tipColor:getColor())
  love.graphics.print(clickmode, 10, 30)
  love.graphics.setColor(COLOR.RED)
  love.graphics.print("A: (" .. pointA.x .. ", " .. pointA.y .. ")", 650, 10)
  love.graphics.setColor(COLOR.GREEN)
  love.graphics.print("B: (" .. pointB.x .. ", " .. pointB.y .. ")", 650, 30)  
  print(dist(pointA.x, pointA.y, pointB.x, pointB.y))
end

function love.keypressed(k)
  if k == "escape" then love.event.quit() end
  if k == "1" then clickmode = "Clear"   tipColor:setColor(COLOR.GREY)  end
  if k == "2" then clickmode = "Wall"    tipColor:setColor(COLOR.WALL)  end
  if k == "3" then clickmode = "Water"   tipColor:setColor(COLOR.BLUE)  end
  if k == "4" then clickmode = "Point A" tipColor:setColor(COLOR.RED)   end
  if k == "5" then clickmode = "Point B" tipColor:setColor(COLOR.GREEN) end
end

function dist(x1, y1, x2, y2)
  return x2 - x1 + y2 - y1
end

function F(x1, y1, x2, y2, x3, y3)
  return dist(x1, y1, x2, y2) + dist(x2, y2, x3, y3)
end

function astar(x1, y1, x2, y2)  -- TODO: This!
  --[[
    F = G + H
    G = Cost from Point A to a given square
    H = Cost from given square to Point B
    F = dist(PointA, tile) + dist(tile, PointB)
    Regular tiles cost 10pts
    Water costs 13pts (30%+)
    Walls cost Infinite

    Add the starting square to the open list
    Repeat:
      Calculate F for the 8 tiles around you
      Get the lowest F tile
      Switch that tile to the closed list
      For all 8 squares around that one:
        If Wall or in closed list, ignore
        If not on open list:
          Add it to open list.
          Make the current square its parent square
          Record the F, G and H costs of that square
        If on the open list:
          If G cost is lower:
            Change the parent of the square to the current square
            Recalculate G and F of the square
      Stop when:
        Target square is added to the closed list (path found)
        Empty open list, but target square not on closed list (no path)
    Go from each square to its parent square. That's the path
  --]]
  return nil
end