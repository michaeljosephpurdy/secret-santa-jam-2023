local FinishSign = class("FinishSign", {})

function FinishSign:init(props)
	self.x = 0
	self.y = SCREEN_SIZE - 512
	self.left_sign = love.graphics.newImage("assets/sign-left.png")
	self.right_sign = love.graphics.newImage("assets/sign-right.png")
end

function FinishSign:draw_background(dt)
	love.graphics.setColor({ 1, 1, 1 })
	love.graphics.draw(self.left_sign, self.x, SCREEN_SIZE - self.left_sign:getHeight())
end

function FinishSign:draw_foreground(dt)
	love.graphics.setColor({ 1, 1, 1 })
	love.graphics.draw(self.right_sign, self.x + self.left_sign:getWidth(), SCREEN_SIZE - self.right_sign:getHeight())
end

return FinishSign
