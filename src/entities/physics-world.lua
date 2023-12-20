local PhysicsWorld = class("PhysicsWorld")

function PhysicsWorld:init(props)
	self.is_physics_world = true
	self.physics_world = love.physics.newWorld(0, 9.81 * 64, true)
	love.physics.setMeter(64)
end

function PhysicsWorld:update(dt)
	self.physics_world:update(dt)
end

function PhysicsWorld:get_world()
	return self.physics_world
end

return PhysicsWorld
