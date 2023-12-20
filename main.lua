require("plugins.pubsub")
require("plugins.push")
require("plugins.30log")
tiny = require("plugins.tiny-ecs")
require("plugins.table-addons")
SYSTEMS_IN_ORDER = {
	require("src.systems.physic-update-system"),
	require("src.systems.player-input-system"),
	require("src.systems.background-drawing-system"),
	require("src.systems.drawing-system"),
	require("src.systems.foreground-drawing-system"),
}
UPDATE_SYSTEMS = function(_, s)
	return not s.is_draw_system
end
DRAW_SYSTEMS = function(_, s)
	return s.is_draw_system
end

local PhysicsWorld = require("src.entities.physics-world")
local Player = require("src.entities.player")
local Ground = require("src.entities.ground")

function love.load()
	world = tiny.world()
	for _, system in pairs(SYSTEMS_IN_ORDER) do
		world:addSystem(system)
	end
	local physics_world = PhysicsWorld:new()
	world:addEntity(physics_world)
	local player = Player:new({ physics_world = physics_world.physics_world })
	world:addEntity(player)
	local ground = Ground:new({ physics_world = physics_world.physics_world })
	world:addEntity(ground)

	love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
	love.window.setMode(650, 650) -- set the window dimensions to 650 by 650
end

function love.keyreleased(k) end

function love.update(dt)
	world:update(dt, UPDATE_SYSTEMS)
end

function love.draw()
	local dt = love.timer:getFPS()
	world:update(dt, DRAW_SYSTEMS)
end
