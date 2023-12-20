DrawingSystem = tiny.processingSystem()
DrawingSystem.is_draw_system = true
DrawingSystem.filter = tiny.requireAll("draw")

function DrawingSystem:process(e, dt)
	e:draw(dt)
end

return DrawingSystem
