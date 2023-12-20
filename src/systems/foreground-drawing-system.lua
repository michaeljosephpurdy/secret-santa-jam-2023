ForegroundDrawingSystem = tiny.processingSystem()
ForegroundDrawingSystem.is_draw_system = true
ForegroundDrawingSystem.filter = tiny.requireAll("draw_foreground")

function ForegroundDrawingSystem:process(e, dt)
	e:draw_foreground(dt)
end

return ForegroundDrawingSystem
