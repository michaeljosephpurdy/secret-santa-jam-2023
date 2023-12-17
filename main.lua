local DEG_TO_RAD = math.pi / 180

function love.load()
	-- the height of a meter our worlds will be 64px
	love.physics.setMeter(64)
	-- create a world for the bodies to exist in with horizontal gravity
	-- of 0 and vertical gravity of 9.81
	world = love.physics.newWorld(0, 9.81 * 64, true)

	objects = {} -- table to hold all our physical objects

	-- let's create the ground
	objects.ground = {}
	-- remember, the shape (the rectangle we create next) anchors to the
	-- body from its center, so we have to move it to (650/2, 650-50/2)
	objects.ground.body = love.physics.newBody(world, 650 / 2, 650 - 50 / 2)
	-- make a rectangle with a width of 650 and a height of 50
	objects.ground.shape = love.physics.newRectangleShape(1200, 50)
	-- attach shape to body
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

	-- Create the leg components
	local joint_offset = 10
	local joint_placement = 5
	body = createRectangleBody(100, 200, 300, 100, 8, { 0.7, 0.7, 0.3 })
	thigh = createRectangleBody(380, 300, 30, 100, 5, { 1, 0, 0 })
	--thigh.body:setFixedRotation(false)
	shin = createRectangleBody(400, 400, 30, 100, 10, { 0, 1, 1 })
	wheel = createCircleBody(100, 300, 50, 2, { 0, 1, 0 })
	drawable_rectangles = { body, thigh, shin }
	drawable_circles = { wheel }
	body_to_thigh = love.physics.newRevoluteJoint(body.body, thigh.body, 400, 300)
	body_to_thigh:setLimits(-180 * DEG_TO_RAD, 45 * DEG_TO_RAD)
	body_to_thigh:setLimitsEnabled(true)
	thigh_to_shin = love.physics.newRevoluteJoint(thigh.body, shin.body, 400, 400)
	body_to_wheel = love.physics.newWheelJoint(body.body, wheel.body, wheel.body:getX(), wheel.body:getY(), 0, 1)
	body_to_wheel:setSpringFrequency(7)
	body_to_wheel:setSpringDampingRatio(0.5)

	love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
	love.window.setMode(650, 650) -- set the window dimensions to 650 by 650
	print(body_to_thigh:setMaxMotorTorque(100))
end

function love.update(dt)
	world:update(dt) -- this puts the world into motion
	local torque = 10
	local acceleration = 7
	local friction = 0.9
	local current_thigh_velocity = thigh.body:getAngularVelocity()
	if love.keyboard.isDown("z") then
		local new_velocity = math.min(current_thigh_velocity + acceleration, torque)
		thigh.body:setAngularVelocity(new_velocity)
	elseif love.keyboard.isDown("x") then
		local new_velocity = math.max(current_thigh_velocity - acceleration, -torque)
		thigh.body:setAngularVelocity(new_velocity)
	else
		thigh.body:setAngularVelocity(current_thigh_velocity * friction)
	end
	local current_shin_velocity = shin.body:getAngularVelocity()
	if love.keyboard.isDown("c") then
		local new_velocity = math.min(current_shin_velocity + acceleration, torque)
		shin.body:setAngularVelocity(new_velocity)
	elseif love.keyboard.isDown("v") then
		local new_velocity = math.max(current_shin_velocity - acceleration, -torque)
		shin.body:setAngularVelocity(new_velocity)
	else
		shin.body:setAngularVelocity(current_shin_velocity * friction)
	end
end

function love.draw()
	love.graphics.translate(-body.body:getX() + 200, 0)
	-- set the drawing color to green for the ground
	love.graphics.setColor(0.28, 0.63, 0.05)
	-- draw a "filled in" polygon using the ground's coordinates
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

	for _, drawable in pairs(drawable_rectangles) do
		love.graphics.setColor(drawable.color)
		love.graphics.polygon("fill", drawable.body:getWorldPoints(drawable.shape:getPoints()))
	end
	for _, drawable in pairs(drawable_circles) do
		love.graphics.setColor(drawable.color)
		love.graphics.circle("fill", drawable.body:getX(), drawable.body:getY(), drawable.shape:getRadius())
	end
	for i = 0, 10 do
		love.graphics.line(0, i * 100, 700, i * 100)
		love.graphics.line(i * 100, 0, i * 100, 700)
	end
end

function createRectangleBody(x, y, width, height, mass, color)
	local body = love.physics.newBody(world, x + width / 2, y + height / 2, "dynamic")
	local shape = love.physics.newRectangleShape(width, height)
	local fixture = love.physics.newFixture(body, shape, mass or 0)
	return { body = body, shape = shape, color = color, width = width, height = height }
end

function createCircleBody(x, y, radius, mass, color)
	local body = love.physics.newBody(world, x + radius / 2, y + radius / 2, "dynamic")
	local shape = love.physics.newCircleShape(radius)
	local fixture = love.physics.newFixture(body, shape, mass or 0)
	return { body = body, shape = shape, color = color, radius = radius }
end
