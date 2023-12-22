local Tree = class("Tree")

function Tree:init(props)
	self.image = love.graphics.newImage("assets/tree.png")
	local x, y = 400, SCREEN_SIZE - self.image:getHeight()
	self.body = love.physics.newBody(props.physics_world, x, y, "static")
	self.shape = love.physics.newRectangleShape(30, 1000)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function Tree:draw(dt)
	love.graphics.draw(
		self.image,
		self.body:getX(),
		self.body:getY(),
		self.body:getAngle(),
		self.scale_x or 1,
		self.scale_y or 1,
		self.image:getWidth() / 2,
		self.image:getHeight() / 2
	)
end

return Tree
