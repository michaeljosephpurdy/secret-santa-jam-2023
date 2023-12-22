local Sky = class("Sky")

function Sky:init(props)
	self.x, self.y = 0, 0
	self.img = love.graphics.newImage("assets/sky.png")
	self.batch = love.graphics.newSpriteBatch(self.img, 100)
	local width = self.img:getWidth()
	for x = -3, 100 do
		self.batch:add(x * width, 0)
	end
end

function Sky:draw_background(dt)
	love.graphics.draw(self.batch)
end

return Sky
