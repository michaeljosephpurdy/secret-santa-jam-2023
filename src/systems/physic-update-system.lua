local PhysicsUpdateSystem = tiny.processingSystem()
PhysicsUpdateSystem.filter = tiny.requireAll("is_physics_world")

function PhysicsUpdateSystem:process(e, dt)
	e:update(dt)
end

return PhysicsUpdateSystem
