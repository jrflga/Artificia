local Renderer = require "renderer"
local LoopManager = require "loop_manager"
local Tilemap = require "tile_map"

local mapsizeX, mapsizeY = 10, 10
local initPosX, initPosY = 210, 120
local tileGap = 4

renderer = Renderer:create()
loopmngr = LoopManager:create()
tilemap = Tilemap:create(initPosX, initPosY, mapsizeX, mapsizeY, tileGap)

gTime = 0

function love.load()
	tilemap:load()
end

function love.update(dt)
	gTime = gTime + dt
	print(gTime)
	loopmngr:update(dt)
	love.window.setTitle("Artificia - FPS" .. love.timer.getFPS())
end

function love.draw()
	renderer:draw()
end

function love.keypressed(k)
   if k == "escape" then love.event.quit() end
end
