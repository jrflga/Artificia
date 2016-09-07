local Renderer = require "renderer"
local LoopManager = require "loop_manager"
local Tilemap = require "tile_map"

renderer = Renderer:create()
loopmngr = LoopManager:create()
tilemap = Tilemap:create()

gTime = 0

function love.load()
	tilemap:load()

	font = love.graphics.newFont("gfx/font.ttf", 32)
	love.graphics.setFont(font)
end

function love.update(dt)
	gTime = gTime + dt
	loopmngr:update(dt)
end

function love.draw()
	love.graphics.print (love.timer.getFPS (), 10, 10)
	renderer:draw()
end
