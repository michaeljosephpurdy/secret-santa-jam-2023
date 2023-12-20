local PlayerInputSystem = tiny.processingSystem()
PlayerInputSystem.filter = tiny.requireAll("is_player")

function PlayerInputSystem:process(e, dt)
	local thigh_torque = 20
	local shin_torque = 15

	local friction = 0.84
	e.jumped = e.jumped - dt
	if love.keyboard.isDown(e.keys.thigh_backward) then
		e.thigh.body:setAngularVelocity(thigh_torque)
	elseif love.keyboard.isDown(e.keys.thigh_forward) then
		e.thigh.body:setAngularVelocity(-thigh_torque)
	else
		e.thigh.body:setAngularVelocity(e.thigh.body:getAngularVelocity() * friction)
	end
	if love.keyboard.isDown(e.keys.shin_backward) then
		e.shin.body:setAngularVelocity(shin_torque)
	elseif love.keyboard.isDown(e.keys.shin_forward) then
		e.shin.body:setAngularVelocity(-shin_torque)
	else
		e.shin.body:setAngularVelocity(e.shin.body:getAngularVelocity() * friction)
	end
	-- if love.keyboard.isDown("c") and e.jumped < 0 then
	-- e.neck.body:applyLinearImpulse(0, -5000)
	-- e.jumped = 1
	-- elseif love.keyboard.isDown("v") then
	-- e.neck.body:applyLinearImpulse(0, 1000)
	-- end
end

return PlayerInputSystem
