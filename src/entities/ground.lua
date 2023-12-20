local Ground = class("Ground")
Ground.drawable_background = true

function Ground:init(props)
	-- remember, the shape (the rectangle we create next) anchors to the
	-- body from its center, so we have to move it to (650/2, 650-50/2)
	self.body = love.physics.newBody(props.physics_world, 0, 650 - 50 / 2)
	-- make a rectangle with a width of 650 and a height of 50
	self.shape = love.physics.newRectangleShape(2400, 50)
	-- attach shape to body
	self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Ground:draw()
	love.graphics.push()
	-- set the drawing color to green for the ground
	love.graphics.setColor(0.28, 0.63, 0.05)
	-- draw a "filled in" polygon using the ground's coordinates
	love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	love.graphics.pop()
end

return Ground
