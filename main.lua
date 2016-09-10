local lue = require "lib/lue/lue"

local Renderer = require "renderer"
local LoopManager = require "loop_manager"
local Tilemap = require "tile_map"

local mapsizeX, mapsizeY = 64, 32
local initPosX, initPosY = 170, 60
local tileSize = 16

clickmode = "Pick a mode (1 - Wall, 2 - Point A and 3 - Point B)"
tipColor = nil

renderer = Renderer:create()
loopmngr = LoopManager:create()
tilemap = Tilemap:create(initPosX, initPosY, mapsizeX, mapsizeY, tileSize)

gTime = 0

function love.load()
	tilemap:load()

	font = love.graphics.newImageFont("gfx/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)

	tipColor =  lue:newColor():setColor({50, 50, 50})
end

function love.update(dt)
	gTime = gTime + dt
	print(gTime)
	love.window.setTitle("Artificia - FPS" .. love.timer.getFPS())
	loopmngr:update(dt)
	lue:update(dt)
end

function love.draw()
	renderer:draw()
	love.graphics.setColor(tipColor:getColor())
	love.graphics.print(clickmode, 10, 10)
end

function love.keypressed(k)
   if k == "escape" then love.event.quit() end
	 if k == "1" then clickmode = "Wall" tipColor:setColor({50, 50, 100}) end
	 if k == "2" then clickmode = "Point_A" tipColor:setColor({255, 0, 0}) end
	 if k == "3" then clickmode = "Point_B" tipColor:setColor({0, 255, 0}) end
end
