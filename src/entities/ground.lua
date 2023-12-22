local Ground = class("Ground")
Ground.drawable_background = true

function Ground:init(props)
	-- remember, the shape (the rectangle we create next) anchors to the
	-- body from its center, so we have to move it to (650/2, 650-50/2)
	local left_boundary_body = love.physics.newBody(props.physics_world, -50, 0)
	local left_boundary_shape = love.physics.newRectangleShape(10, 1000)
	local left_boundary_fixture = love.physics.newFixture(left_boundary_body, left_boundary_shape)
	self.body = love.physics.newBody(props.physics_world, 2400 / 2, 650 - 50 / 2)
	-- make a rectangle with a width of 650 and a height of 50
	self.shape = love.physics.newRectangleShape(2400, 50)
	-- attach shape to body
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setCategory(1)
	self.foreground_objects = {}
	for i = 0, 1000 do
		table.insert(
			self.foreground_objects,
			{ x = math.random(10000), y = SCREEN_SIZE - math.random(15, 35), radius = math.random(10, 30) }
		)
	end
	self.img = love.graphics.newImage("assets/ground.png")
	self.batch = love.graphics.newSpriteBatch(self.img, 100)
	local width = self.img:getWidth()
	local y = SCREEN_SIZE - self.img:getHeight()
	for x = -0.5, 100 do
		self.batch:add(x * width, y)
	end
end

function Ground:draw()
	--love.graphics.push()
	-- set the drawing color to green for the ground
	--love.graphics.setColor(0.28, 0.63, 0.05)
	-- draw a "filled in" polygon using the ground's coordinates
	--love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	--love.graphics.pop()
end

function Ground:draw_foreground()
	love.graphics.draw(self.batch)
end

return Ground
