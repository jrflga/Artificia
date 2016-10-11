local lue = require "lib/lue/lue"

local initPosX, initPosY = 20, 60
local tileSize = 16
local tilemap = {}

local mapsizeX, mapsizeY = 10, 10
local min_map_width, min_map_height = 4, 4
local max_map_width, max_map_height = 64, 32

local mouse = {
    x = 0, y = 0, isDown = false
}

function love.load()
    modeoptions = "Pick a mode (1 - Clear, 2 - Wall, 3 - Water, 4 - Point A or 5 - Point B)"
    clickmode = "Clear"
    tipColor = nil

    pointA, pointB = {}, {}

    COLOR = {
        NONE = { 0, 0, 0 },
        RED = { 200, 50, 50 },
        GREY = { 50, 50, 50 },
        WALL = { 100, 100, 125 },
        BLUE = { 52, 152, 219 },
        GREEN = { 50, 200, 50 },
        WHITE = { 180, 180, 180 }
    }

    gTime = 0

    pointA = {x = 0, y = 0}
    pointB = {x = mapsizeX-1, y = mapsizeY-1}

    font = love.graphics.newImageFont("gfx/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(font)

    tipColor = lue:newColor():setColor(COLOR.GREY)
    tilemap_create(mapsizeX, mapsizeY)
end

function love.update(dt)
    gTime = gTime + dt
    love.window.setTitle("Artificia - " .. love.timer.getFPS() .. " FPS")

    if love.keyboard.isDown("up") and mapsizeY - 1 >= min_map_height then
        mapsizeY = mapsizeY - 1
        tilemap_create(mapsizeX, mapsizeY)
    elseif love.keyboard.isDown("down") and mapsizeY + 1 <= max_map_height then
        mapsizeY = mapsizeY + 1
        tilemap_create(mapsizeX, mapsizeY)
    end
    if love.keyboard.isDown("left") and mapsizeX - 1 >= min_map_width then
        mapsizeX = mapsizeX - 1
        tilemap_create(mapsizeX, mapsizeY)
    elseif love.keyboard.isDown("right") and mapsizeX + 1 <= max_map_width then
        mapsizeX = mapsizeX + 1
        tilemap_create(mapsizeX, mapsizeY)
    end

    mouse.x = love.mouse.getX()
    mouse.y = love.mouse.getY()
    mouse.isDown = love.mouse.isDown(1)
    if mouse.down then tilemap_click(mouse.x, mouse.y) end

    lue:update(dt)
end

function love.draw()
    love.graphics.setColor(COLOR.GREY)
    love.graphics.print(modeoptions, 10, 10)
    love.graphics.setColor(tipColor:getColor())
    love.graphics.print(clickmode, 10, 30)
    love.graphics.setColor(COLOR.RED)
    love.graphics.print("A: (" .. pointA.x .. ", " .. pointA.y .. ")", 650, 10)
    love.graphics.setColor(COLOR.GREEN)
    love.graphics.print("B: (" .. pointB.x .. ", " .. pointB.y .. ")", 650, 30)
    tilemap_draw(mapsizeX, mapsizeY)
end

function love.keypressed(k)
    if k == "escape" then love.event.quit() end
    if k == "1" then clickmode = "Clear"   tipColor:setColor(COLOR.GREY)  end
    if k == "2" then clickmode = "Wall"    tipColor:setColor(COLOR.WALL)  end
    if k == "3" then clickmode = "Water"   tipColor:setColor(COLOR.BLUE)  end
    if k == "4" then clickmode = "Point A" tipColor:setColor(COLOR.RED)   end
    if k == "5" then clickmode = "Point B" tipColor:setColor(COLOR.GREEN) end
end

local INF = 1/0
local cachedPaths = nil

----------------------------------------------------------------
-- local functions
----------------------------------------------------------------

function tilemap_create(sizeX, sizeY)
    for i=0, sizeX-1 do
        tilemap[i] = {}
        for j=0, sizeY-1 do
            tilemap[i][j] = 0
        end
    end
    tilemap[pointA.x][pointA.y] = 3
    tilemap[pointB.x][pointB.y] = 4
end

function tilemap_draw(sizeX, sizeY)
    local tile_color = {0,0,0}
    local fill_mode = "fill"
    for i=0, sizeX-1 do
        for j=0, sizeY-1 do
            if tilemap[i][j] == 0 then
                tile_color = COLOR.WHITE
                fill_mode = "line"
            elseif tilemap[i][j] == 1 then tile_color = COLOR.WALL
            elseif tilemap[i][j] == 2 then tile_color = COLOR.BLUE
            elseif tilemap[i][j] == 3 then tile_color = COLOR.RED
            elseif tilemap[i][j] == 4 then tile_color = COLOR.GREEN end
            if tilemap[i][j] ~= 0 then fill_mode = "fill" end

            love.graphics.setColor(tile_color)
            love.graphics.rectangle(fill_mode, i * tileSize + initPosX, j * tileSize + initPosY, tileSize, tileSize)
        end
    end
end

--[[function tilemap_click(mouseX, mouseY)
    for i = 0, sizeX-1 do
        for j = 0, sizeY-1 do


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
    end
end--]]

function dist (x1, y1, x2, y2)
    return math.sqrt ( math.pow ( x2 - x1, 2 ) + math.pow ( y2 - y1, 2 ) )
end

function dist_between ( nodeA, nodeB )

    return dist ( nodeA.x, nodeA.y, nodeB.x, nodeB.y )
end

function heuristic_cost_estimate ( nodeA, nodeB )

    return dist ( nodeA.x, nodeA.y, nodeB.x, nodeB.y )
end

function is_valid_node ( node, neighbor )

    return true
end

function lowest_f_score ( set, f_score )

    local lowest, bestNode = INF, nil
    for _, node in ipairs ( set ) do
        local score = f_score [ node ]
        if score < lowest then
            lowest, bestNode = score, node
        end
    end
    return bestNode
end

function neighbor_nodes ( theNode, nodes )

    local neighbors = {}
    for _, node in ipairs ( nodes ) do
        if theNode ~= node and is_valid_node ( theNode, node ) then
            table.insert ( neighbors, node )
        end
    end
    return neighbors
end

function not_in ( set, theNode )

    for _, node in ipairs ( set ) do
        if node == theNode then return false end
    end
    return true
end

function remove_node ( set, theNode )

    for i, node in ipairs ( set ) do
        if node == theNode then 
            set [ i ] = set [ #set ]
            set [ #set ] = nil
            break
        end
    end 
end

function unwind_path ( flat_path, map, current_node )

    if map [ current_node ] then
        table.insert ( flat_path, 1, map [ current_node ] ) 
        return unwind_path ( flat_path, map, map [ current_node ] )
    else
        return flat_path
    end
end

function a_star (start, goal, nodes, valid_node_func)

    local closedset = {}
    local openset = { start }
    local came_from = {}

    if valid_node_func then is_valid_node = valid_node_func end

    local g_score, f_score = {}, {}
    g_score [ start ] = 0
    f_score [ start ] = g_score [ start ] + heuristic_cost_estimate ( start, goal )

    while #openset > 0 do
    
        local current = lowest_f_score ( openset, f_score )
        if current == goal then
            local path = unwind_path ( {}, came_from, goal )
            table.insert ( path, goal )
            return path
        end

        remove_node ( openset, current )        
        table.insert ( closedset, current )
        
        local neighbors = neighbor_nodes ( current, nodes )
        for _, neighbor in ipairs ( neighbors ) do 
            if not_in ( closedset, neighbor ) then
            
                local tentative_g_score = g_score [ current ] + dist_between ( current, neighbor )
                 
                if not_in ( openset, neighbor ) or tentative_g_score < g_score [ neighbor ] then 
                    came_from   [ neighbor ] = current
                    g_score     [ neighbor ] = tentative_g_score
                    f_score     [ neighbor ] = g_score [ neighbor ] + heuristic_cost_estimate ( neighbor, goal )
                    if not_in ( openset, neighbor ) then
                        table.insert ( openset, neighbor )
                    end
                end
            end
        end
    end
    return nil
end

function clear_cached_paths()
    cachedPaths = nil
end

function path(start, goal, nodes, ignore_cache, valid_node_func)

    if not cachedPaths then cachedPaths = {} end
    if not cachedPaths [ start ] then
        cachedPaths [ start ] = {}
    elseif cachedPaths [ start ] [ goal ] and not ignore_cache then
        return cachedPaths [ start ] [ goal ]
    end
    
    return a_star ( start, goal, nodes, valid_node_func )
end