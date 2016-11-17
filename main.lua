local insert = table.insert

local map_offset = { x = 20, y = 60 }
local tile_size = 16
local tilemap = {}

local mapsizeX, mapsizeY = 32, 32
local min_map_width, min_map_height = 4, 4
local max_map_width, max_map_height = 64, 32

local mouse = { x = 0, y = 0, isDown = false }

local drawing_tile = 0
local drawing_color = { 0, 0, 0 }

local path = {}
local line_points = {}
local closed_list = {}

function love.load()
    modeoptions = "1 - Clear, 2 - Wall, 3 - Water, 4 - Point A, 5 - Point B, 6 - Run"
    clickmode = "Clear"

    pointA, pointB = {}, {}

    COLOR = {
        NONE = { 0, 0, 0 },
        RED = { 200, 50, 50 },
        GREY = { 50, 50, 50 },
        WALL = { 100, 100, 125 },
        BLUE = { 52, 152, 219 },
        GREEN = { 50, 200, 50 },
        WHITE = { 180, 180, 180 },
        PURPLE = { 142, 68, 173 }
    }


    pointA = { x = 0, y = 0, g = 0, h = 0, f = 0 }
    pointB = { x = mapsizeX-1, y = mapsizeY-1, g = 0, h = 0, f = 0 }

    font = love.graphics.newImageFont("gfx/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(font)

    tilemap_create(mapsizeX, mapsizeY)
end

function love.update(dt)
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
    if mouse.isDown then tilemap_click(mouse.x, mouse.y) end
end

function love.draw()
    love.graphics.setColor(COLOR.GREY)
    love.graphics.print(modeoptions, 10, 10)
    love.graphics.setColor(drawing_color)
    love.graphics.print(clickmode, 10, 30)
    love.graphics.setColor(COLOR.RED)
    love.graphics.print("A: (" .. pointA.x .. ", " .. pointA.y .. ")", 650, 10)
    love.graphics.setColor(COLOR.GREEN)
    love.graphics.print("B: (" .. pointB.x .. ", " .. pointB.y .. ")", 650, 30)
    tilemap_draw(mapsizeX, mapsizeY)
    love.graphics.setColor(COLOR.PURPLE)
    if #line_points > 4 and #line_points % 2 == 0 then love.graphics.line(line_points) end
end

function love.keypressed(k)
    if k == "escape" then love.event.quit() end
    if k == "1" then clickmode = "Clear"   drawing_tile, drawing_color = 0, COLOR.NONE  end
    if k == "2" then clickmode = "Wall"    drawing_tile, drawing_color = 1, COLOR.WALL  end
    if k == "3" then clickmode = "Water"   drawing_tile, drawing_color = 2, COLOR.BLUE  end
    if k == "4" then clickmode = "Point A" drawing_tile, drawing_color = 3, COLOR.RED   end
    if k == "5" then clickmode = "Point B" drawing_tile, drawing_color = 4, COLOR.GREEN end
    if k == "6" then a_star() end
end

local INF = 1/0

----------------------------------------------------------------
-- local functions
----------------------------------------------------------------

function tilemap_create(sizeX, sizeY)
    local new_tilemap = {}
    for i=0, sizeX-1 do
        new_tilemap[i] = {}
        for j=0, sizeY-1 do
            if tilemap[i] and tilemap[i][j] then
                new_tilemap[i][j] = tilemap[i][j]
            else
                new_tilemap[i][j] = { tile_type = 0, g = nil, h = nil, f = nil }
            end
        end
    end
    tilemap = new_tilemap
  --  tilemap[pointA.x][pointA.y] = 3
--    tilemap[pointB.x][pointB.y] = 4
end

function tilemap_draw(sizeX, sizeY)
    local tile_color = { 0, 0, 0 }
    local fill_mode = "fill"
    for i=0, sizeX-1 do
        for j=0, sizeY-1 do
            if tilemap[i][j].tile_type == 0 then
                tile_color = COLOR.WHITE
                fill_mode = "line"
            elseif tilemap[i][j].tile_type == 1 then tile_color = COLOR.WALL
            elseif tilemap[i][j].tile_type == 2 then tile_color = COLOR.BLUE
            elseif tilemap[i][j].tile_type == 3 then tile_color = COLOR.RED
            elseif tilemap[i][j].tile_type == 4 then tile_color = COLOR.GREEN end
            if tilemap[i][j].tile_type ~= 0 then fill_mode = "fill" end

            love.graphics.setColor(tile_color)
            love.graphics.rectangle(fill_mode, i * tile_size + map_offset.x, j * tile_size + map_offset.y, tile_size, tile_size)
        end
    end

end

function tilemap_click(x, y)
    -- TODO: Bad code. Redo.

    local lock = false
    for i=1, mapsizeX do
        for j=1, mapsizeY do
            if tilemap[i-1][j-1].tile_type == 3 or tilemap[i-1][j-1].tile_type == 4 then
                -- Do nothing
            elseif x < i * tile_size + map_offset.x
            and y < j * tile_size + map_offset.y
            and tilemap[i-1][j-1].tile_type ~= 3 and tilemap[i-1][j-1].tile_type ~= 4
            and not lock then
                if drawing_tile == 3 then
                    if tilemap[pointA.x] and tilemap[pointA.x][pointA.y] then
                        tilemap[pointA.x][pointA.y].tile_type = 0
                    end
                    pointA = { x = i-1, y = j-1, g = 0, h = 0, f = 0 }
                elseif drawing_tile == 4 then
                    if tilemap[pointB.x] and tilemap[pointB.x][pointB.y] then
                        tilemap[pointB.x][pointB.y].tile_type = 0
                    end
                    pointB = { x = i-1, y = j-1, g = 0, h = 0, f = 0 }
                end
                tilemap[i-1][j-1].tile_type = drawing_tile
                lock = true
                break
            end
        end
    end
    tilemap_draw(mapsizeX, mapsizeY)
end



function isWalkableAt(x, y)
    return tilemap[x][y].tile_type == 0
end

function f_cost(previous, current) -- Node, Start, PointB
    local h = dist(current, pointB)
    local v = 0
    if current.diagonal then
        v = 14
    else
        v = 10
    end
    if not tilemap[current.x][current.y].tile_type == 0 then
        v = INF
    end
    local g = previous.g + v
    return { f = h + g, h = h, g = g }
end

function dist(pos1, pos2)
    return math.sqrt(math.pow(pos2.x - pos1.x, 2) + math.pow(pos2.y - pos1.y, 2))
end

function has_been_on_node(position, list)
    if #list > 1 then
        for i=1, #list do
            print("Checking " .. list[i].x .. " / " .. list[i].y)
            if list[i].x == position.x and list[i].y == position.y then
                return true
            end
        end
    end
    return false
end

function get_best(start, position1, position2)
    if not isWalkableAt(position1.x, position1.y) then
        return position2
    elseif has_been_on_node(position1, path) then
        return position2
    end

    local val = f_cost(start, position1)
    if math.min(val.f, position2.f) == position2.f then
        return position2
    else
        return { x = position1.x, y = position1.y, f = val.f, g = val.g, h = val.h }
    end
end

function find_best_neighbor(tile)
    local best_neighbor = {
        f = INF, g = 0, h = 0,
        x = 0, y = 0
    }
    local x = tile.x
    local y = tile.y

    if x-1 >= 0 then  -- Left column
        if y-1 >= 0 then  -- Top left
            best_neighbor = get_best(tile, { x = x-1, y = y-1, diagonal = true }, best_neighbor)
        end
        if y+1 < #tilemap[x] then  -- Bottom left
            best_neighbor = get_best(tile, { x = x-1, y = y+1, diagonal = true }, best_neighbor)
        end
        -- Left
        best_neighbor = get_best(tile, { x = x-1, y = y, diagonal = false }, best_neighbor)
    end

    if y-1 >= 0 then  -- Top
        best_neighbor = get_best(tile, { x = x, y = y-1, diagonal = false }, best_neighbor)
    end
    if y+1 < #tilemap[x] then  -- Bottom
        best_neighbor = get_best(tile, { x = x, y = y+1, diagonal = false }, best_neighbor)
    end

    if x+1 < #tilemap then  -- Right column
        if y-1 >= 0 then  -- Top right
            best_neighbor = get_best(tile, { x = x+1, y = y-1, diagonal = true }, best_neighbor)
        end
        if y+1 < #tilemap[x] then  -- Bottom right
            best_neighbor = get_best(tile, { x = x+1, y = y+1, diagonal = true }, best_neighbor)
        end
        -- Right
        best_neighbor = get_best(tile, { x = x+1, y = y, diagonal = false }, best_neighbor)
    end

    return best_neighbor
end

function a_star()
    path = {}
    line_points = {}

    local current_node = pointA
    local next_node = {}
    local counter = 0

    while current_node.x ~= pointB.x and current_node.y ~= pointB.y do
        counter = counter + 1
        next_node = find_best_neighbor(current_node)
        insert(path, next_node)
        current_node = next_node
    end

    insert(path, pointB)
    for i=1, #path do
        insert(line_points, map_offset.x + (path[i].x * tile_size) + tile_size/2)
        insert(line_points, map_offset.y + (path[i].y * tile_size) + tile_size/2)
    end
end