BackgroundDrawingSystem = tiny.processingSystem()
BackgroundDrawingSystem.is_draw_system = true
BackgroundDrawingSystem.filter = tiny.requireAll("draw_background")

function BackgroundDrawingSystem:process(e, dt)
	e:draw_background(dt)
end

return BackgroundDrawingSystem
