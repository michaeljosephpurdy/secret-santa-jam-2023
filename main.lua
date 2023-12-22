require("plugins.pubsub")
require("plugins.30log")
tiny = require("plugins.tiny-ecs")
require("plugins.table-addons")
SYSTEMS_IN_ORDER = {
	require("src.systems.music-system"),
	require("src.systems.physic-update-system"),
	require("src.systems.player-input-system"),
	require("src.systems.update-system"),
	require("src.systems.camera-system"),
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
--DEBUG = true
SCREEN_SIZE = 650
SIXTY_FPS = 1 / 60

local BackgroundMusic = require("src.entities.background-music")
local PhysicsWorld = require("src.entities.physics-world")
local Player = require("src.entities.player")
local Ground = require("src.entities.ground")
local FinishSign = require("src.entities.finish-sign")
local TitleScreen = require("src.entities.title-screen")
-- local Tree = require("src.entities.tree")
local Snowflake = require("src.entities.snowflake")
local Sky = require("src.entities.sky")
local Clock = require("src.entities.clock")

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
	love.window.setMode(640, 640)

	world = tiny.world()
	for _, system in pairs(SYSTEMS_IN_ORDER) do
		world:addSystem(system)
	end

	world:addEntity(BackgroundMusic:new())
	local physics_world = PhysicsWorld:new()
	world:addEntity(physics_world)
	local ground = Ground:new({ physics_world = physics_world.physics_world })
	local title_screen = TitleScreen:new()
	world:addEntity(title_screen)
	title_screen.world = world
	local player = Player:new({ physics_world = physics_world.physics_world })
	player.world = world
	world:addEntity(player)
	-- world:addEntity(Tree:new({ physics_world = physics_world.physics_world }))
	--world:addEntity(Player:new({ physics_world = physics_world.physics_world, player_number = 2 }))
	world:addEntity(ground)
	for i = 0, 1000 do
		world:addEntity(Snowflake:new())
	end
	world:addEntity(Sky:new())
	world:addEntity(Clock:new())
	world:addEntity(FinishSign:new())

	accumulator = SIXTY_FPS
end

function love.update(dt)
	accumulator = accumulator + dt
	while accumulator >= SIXTY_FPS do
		world:update(SIXTY_FPS, UPDATE_SYSTEMS)
		accumulator = accumulator - SIXTY_FPS
	end
end

function love.resize(w, h)
	PubSub.publish("love.resize", { w, h })
end

function love.draw()
	local dt = love.timer:getFPS()
	world:update(dt, DRAW_SYSTEMS)
end
