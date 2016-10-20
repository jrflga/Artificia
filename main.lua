local lue = require "lib/lue/lue"

local map_offset = { x = 20, y = 60 }
local tile_size = 16
local tilemap = {}

local mapsizeX, mapsizeY = 10, 10
local min_map_width, min_map_height = 4, 4
local max_map_width, max_map_height = 64, 32

local mouse = { x = 0, y = 0, isDown = false }

local drawing_tile = 0
local drawing_color = { 0, 0, 0 }

function love.load()
    modeoptions = "Pick a mode (1 - Clear, 2 - Wall, 3 - Water, 4 - Point A or 5 - Point B)"
    clickmode = "Clear"

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
    if mouse.isDown then tilemap_click(mouse.x, mouse.y) end

    lue:update(dt)
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
end

function love.keypressed(k)
    if k == "escape" then love.event.quit() end
    if k == "1" then clickmode = "Clear"   drawing_tile, drawing_color = 0, COLOR.NONE  end
    if k == "2" then clickmode = "Wall"    drawing_tile, drawing_color = 1, COLOR.WALL  end
    if k == "3" then clickmode = "Water"   drawing_tile, drawing_color = 2, COLOR.BLUE  end
    if k == "4" then clickmode = "Point A" drawing_tile, drawing_color = 3, COLOR.RED   end
    if k == "5" then clickmode = "Point B" drawing_tile, drawing_color = 4, COLOR.GREEN end
end

local INF = 1/0
local cachedPaths = nil

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
                new_tilemap[i][j] = 0
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
            if tilemap[i][j] == 0 then
                tile_color = COLOR.WHITE
                fill_mode = "line"
            elseif tilemap[i][j] == 1 then tile_color = COLOR.WALL
            elseif tilemap[i][j] == 2 then tile_color = COLOR.BLUE
            elseif tilemap[i][j] == 3 then tile_color = COLOR.RED
            elseif tilemap[i][j] == 4 then tile_color = COLOR.GREEN end
            if tilemap[i][j] ~= 0 then fill_mode = "fill" end

            love.graphics.setColor(tile_color)
            love.graphics.rectangle(fill_mode, i * tile_size + map_offset.x, j * tile_size + map_offset.y, tile_size, tile_size)
        end
    end

end

function tilemap_click(x, y)
    local lock = false
    for i=1, mapsizeX do
        for j=1, mapsizeY do
            if tilemap[i-1][j-1] == 3 or tilemap[i-1][j-1] == 4 then
                -- Do nothing
            elseif x < i * tile_size + map_offset.x
            and y < j * tile_size + map_offset.y
            and tilemap[i-1][j-1] ~= 3 and tilemap[i-1][j-1] ~= 4
            and not lock then
                if drawing_tile == 3 then
                    tilemap[pointA.x][pointA.y] = 0
                    pointA = { x = i-1, y = j-1 }
                elseif drawing_tile == 4 then
                    tilemap[pointB.x][pointB.y] = 0
                    pointB = { x = i-1, y = j-1 }
                end
                tilemap[i-1][j-1] = drawing_tile
                lock = true
                break
            end
        end
    end
    tilemap_draw(mapsizeX, mapsizeY)
end
