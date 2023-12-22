local PlayerInputSystem = tiny.processingSystem()
PlayerInputSystem.filter = tiny.requireAll("is_player")

function PlayerInputSystem:process(e, dt)
	e.thigh_backward = false
	e.thigh_forward = false
	e.shin_backward = false
	e.shin_forward = false
	if love.keyboard.isDown(e.keys.thigh_backward) then
		e.thigh_backward = true
	elseif love.keyboard.isDown(e.keys.thigh_forward) then
		e.thigh_forward = true
	end
	if love.keyboard.isDown(e.keys.shin_backward) then
		e.shin_backward = true
	elseif love.keyboard.isDown(e.keys.shin_forward) then
		e.shin_forward = true
	end
end

return PlayerInputSystem
