DrawingSystem = tiny.processingSystem()
DrawingSystem.is_draw_system = true
DrawingSystem.filter = tiny.requireAll("draw")

function DrawingSystem:onAdd(e)
	if e.is_player then
		self.player_count = (self.player_count or 0) + 1
	end
end

function DrawingSystem:process(e, dt)
	e:draw(dt)
end

return DrawingSystem
