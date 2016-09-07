local LightWorld = require "lib/lightworld"

local Renderer = require "renderer"
local LoopManager = require "loop_manager"
local Tilemap = require "tile_map"

local mapsizeX, mapsizeY = 25, 25
local initPosX, initPosY = 0, 0
local tileGap = 1

renderer = Renderer:create()
loopmngr = LoopManager:create()
tilemap = Tilemap:create(initPosX, initPosY, mapsizeX, mapsizeY, tileGap)

gTime = 0

function love.load()
	tilemap:load()

	lightRange = 500
	lightSmooth = 1
	x = 0
  y = 0
  z = 1
  scale = 1

	_world = LightWorld({
		ambient = {55, 55, 55},
		refractionStrength = 16.0,
	 	reflectionVisibility = 0.75,
	 	shadowBlur = 2.0
	})

	mouseLight = _world:newLight(0, 0, 255, 191, 127, lightRange)
	mouseLight:setGlowStrength(0.3)
	mouseLight:setSmooth(lightSmooth)
	mouseLight.z = 63
	lightDirection = 0.0
end

function love.update(dt)
	gTime = gTime + dt
	loopmngr:update(dt)
 	mouseLight:setPosition(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	_world:update(dt)
	love.window.setTitle("Artificia - FPS" .. love.timer.getFPS())
end

function love.draw()
	_world:setTranslation(x, y, scale)
  love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale)
    _world:draw(function()
			renderer:draw()
    end)
  love.graphics.pop()
end

function love.keypressed(k)
   if k == "escape" then love.event.quit() end
end
