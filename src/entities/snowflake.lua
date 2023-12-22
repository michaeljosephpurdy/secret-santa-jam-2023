local Snowflake = class("Snowflake")

function Snowflake:init(props)
	self:randomize()
	self.y = self.y + 50
	self.color = { 1, 241 / 255, 232 / 255 }
end

function Snowflake:randomize()
	self.x = math.random(10000)
	self.y = math.random(-60, -10)
	self.speed = math.random(30)
	self.radius = math.random(5)
end

function Snowflake:update(dt)
	self.y = self.y + self.speed * dt
	if self.y > SCREEN_SIZE then
		self:randomize()
	end
end

function Snowflake:draw_foreground(dt)
	love.graphics.setColor(self.color[1], self.color[2], self.color[3])
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Snowflake
