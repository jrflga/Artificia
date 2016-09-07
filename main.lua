local Tilemap = require "tilemap"

tilemap = Tilemap:create()

function love.load()
	tilemap:load()
end

function love.update(dt)
	tilemap:update(dt)
end

function love.draw()
	tilemap:draw()
end
