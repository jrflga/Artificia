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
  print(h_score(pointA.x, pointA.y, pointB.x, pointB.y))
end

function love.keypressed(k)
  if k == "escape" then love.event.quit() end
  if k == "1" then clickmode = "Clear"   tipColor:setColor(COLOR.GREY)  end
  if k == "2" then clickmode = "Wall"    tipColor:setColor(COLOR.WALL)  end
  if k == "3" then clickmode = "Water"   tipColor:setColor(COLOR.BLUE)  end
  if k == "4" then clickmode = "Point A" tipColor:setColor(COLOR.RED)   end
  if k == "5" then clickmode = "Point B" tipColor:setColor(COLOR.GREEN) end
end

function reconstruct_path(cameFrom, current)
  total_path := [current]
  while current in cameFrom.Keys:
      current := cameFrom[current]
      total_path.append(current)
  return total_path
end

function h_score(start, goal)
  return goal.x - start.x + goal.y - start.y
end

function g_score(parent_g, direction)
  if direction == "horizontal" or direction == "vertical" then
    return parent_g + 10
  else
    return parent_g + 14
  end
end

function f_score(current, node)
  return h_score(node) + g_score(current, node)
end

function a_star(start, goal)
  local insert = table.insert
  local remove = table.remove

  local open_list = {}
  local closed_list = {}

  local current_node = {
    x = start.x,
    y = start.y,
    h = h_score(start, goal),
    g = 0,
    f = h_score(start, goal)
  }

  insert(open_list, current_node)

  while #open_list not 0
    local node_current = { x = nil, y = nil, f = 10000 }

    for i=0, #open_list-1 do
      if open_list[i].f < node_current.f then
        node_current = open_list[i]
      end

      if node_current.x == goal.x and node_current.y == goal.y then
        return { x = node_current.x, y = node_current.y }
      end
    end

    local nodes_around = {}

    if node_current.x not 0 then
      local left = tilemap[node_current.x - 1][node_current.y]
      insert(nodes_around, {
        x = left.x,
        y = left.y,
        h = h_score(left, goal),
        g = g_score(<parent>, "horizontal"),
        f = h_score(left, goal) + g_score()
      })
    end
    if node_current.y not 0 then
      local top = tilemap[node_current.x][node_current.y - 1]
      insert(nodes_around, { top.x, top.y })
    end
    if (node_current.x + 1) <= mapsizeX - 1 then
      local right = tilemap[node_current.x + 1][node_current.y]
      insert(nodes_around, { right.x, right.y })
    end
    if (node_current.y + 1) <= mapsizeY - 1 then
      local bottom = tilemap[node_current.x][node_current.y + 1]
      insert(nodes_around, { bottom.x, bottom.y })
    end
    insert(nodes_around, tile)
    


-- PSEUDOCODE [
  Generate each state node_successor that come after node_current
  for each node_successor of node_current {
    Set successor_current_cost = g(node_current) + w(node_current, node_successor)
    if node_successor is in the OPEN list {
      if g(node_successor) ≤ successor_current_cost continue (to line 20)
    } else if node_successor is in the CLOSED list {
      if g(node_successor) ≤ successor_current_cost continue (to line 20)
      Move node_successor from the CLOSED list to the OPEN list
    } else {
      Add node_successor to the OPEN list
      Set h(node_successor) to be the heuristic distance to node_goal
    }
    Set g(node_successor) = successor_current_cost
    Set the parent of node_successor to node_current
  }
  Add node_current to the CLOSED list
}
-- PSEUDOCODE ]

  end

-- PSEUDOCODE [
if(node_current != node_goal) exit with error (the OPEN list is empty)
  -- PSEUDOCODE ]


end
