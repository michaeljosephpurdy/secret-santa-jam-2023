local DEG_TO_RAD = math.pi / 180

local function createRectangleBody(world, x, y, width, height, mass, image, mask)
	local body = love.physics.newBody(world, x + width / 2, y + height / 2, "dynamic")
	local shape = love.physics.newRectangleShape(width, height)
	local fixture = love.physics.newFixture(body, shape, mass or 0)
	fixture:setCategory(2)
	fixture:setMask(2)
	local scale_x, scale_y = 1, 1
	return {
		body = body,
		fixture = fixture,
		shape = shape,
		width = width,
		height = height,
		image = image,
		scale_x = scale_x,
		scale_y = scale_y,
	}
end

local function createCircleBody(world, x, y, radius, mass, image, mask)
	local body = love.physics.newBody(world, x + radius, y + radius, "dynamic")
	local shape = love.physics.newCircleShape(radius)
	local fixture = love.physics.newFixture(body, shape, mass or 0)
	fixture:setCategory(2)
	fixture:setMask(2)
	return {
		body = body,
		fixture = fixture,
		shape = shape,
		radius = radius,
		image = image,
		scale_x = radius * 2 / image:getWidth(),
		scale_y = radius * 2 / image:getHeight(),
	}
end

local Player = class("Player", {
	is_player = true,
	jumped = 1,
	camera_follow = true,
})

function Player:init(props)
	self.canvas = love.graphics.newCanvas()
	self.physics_world = props.physics_world
	self.overlay_spritesheet = love.graphics.newImage("assets/key-overlay.png")
	self.shin_image = love.graphics.newImage("assets/shin.png")
	self.thigh_image = love.graphics.newImage("assets/thigh.png")
	self.head_image = love.graphics.newImage("assets/head.png")
	self.wheel_image = love.graphics.newImage("assets/wheel.png")
	self.player_number = props.player_number or 1
	if self.player_number == 1 then
		self.keys = {
			thigh_backward = "q",
			thigh_forward = "w",
			shin_backward = "e",
			shin_forward = "r",
		}
		self.overlay_quads = {
			idle = {
				love.graphics.newQuad(0, 0, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(32, 0, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(64, 0, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(96, 0, 32, 32, self.overlay_spritesheet),
			},
			pressed = {
				love.graphics.newQuad(0, 32, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(32, 32, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(64, 32, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(96, 32, 32, 32, self.overlay_spritesheet),
			},
		}
		self.body_image = love.graphics.newImage("assets/body-blue.png")
	else
		self.keys = {
			thigh_forward = "m",
			thigh_backward = ",",
			shin_backward = ".",
			shin_forward = "/",
		}
		self.overlay_quads = {
			idle = {
				love.graphics.newQuad(128, 0, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(160, 0, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(192, 0, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(224, 0, 32, 32, self.overlay_spritesheet),
			},
			pressed = {
				love.graphics.newQuad(128, 32, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(160, 32, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(192, 32, 32, 32, self.overlay_spritesheet),
				love.graphics.newQuad(224, 32, 32, 32, self.overlay_spritesheet),
			},
		}
		self.body_image = love.graphics.newImage("assets/body-green.png")
	end
	local x = props.x or 0
	local y = props.y or 0
	self.body =
		createRectangleBody(self.physics_world, x + 100, y + 200, 300, 100, 5, self.body_image, self.player_number)
	self.thigh =
		createRectangleBody(self.physics_world, x + 340, y + 260, 30, 80, 5, self.thigh_image, self.player_number)
	self.shin =
		createRectangleBody(self.physics_world, x + 340, y + 360, 30, 70, 5, self.shin_image, self.player_number)
	self.head =
		createRectangleBody(self.physics_world, x + 380, y + 30, 100, 200, 0, self.head_image, self.player_number)
	self.wheel = createCircleBody(self.physics_world, x + 55, y + 210, 100, 2, self.wheel_image, self.player_number)
	self.wheel.fixture:setCategory(3)
	self.wheel.fixture:setMask(3)

	self.body_to_head = love.physics.newRevoluteJoint(self.body.body, self.head.body, x + 400, self.body.body:getY())
	self.body_to_head:setLimits(-15 * DEG_TO_RAD, 10 * DEG_TO_RAD)
	self.body_to_head:setLimitsEnabled(true)

	self.body_to_thigh = love.physics.newRevoluteJoint(self.body.body, self.thigh.body, x + 360, y + 260)
	self.body_to_thigh:setLimits(-20 * DEG_TO_RAD, 20 * DEG_TO_RAD)
	self.body_to_thigh:setLimitsEnabled(true)
	self.thigh_to_shin = love.physics.newRevoluteJoint(self.thigh.body, self.shin.body, x + 360, y + 360)
	self.thigh_to_shin:setLimits(-20 * DEG_TO_RAD, 20 * DEG_TO_RAD)
	self.thigh_to_shin:setLimitsEnabled(true)
	self.body_to_wheel = love.physics.newWheelJoint(
		self.body.body,
		self.wheel.body,
		self.wheel.body:getX(),
		self.wheel.body:getY(),
		0,
		1
	)
	self.body_to_wheel:setSpringFrequency(4)
	self.body_to_wheel:setSpringDampingRatio(0.5)
	self.drawables = {
		self.body,
		self.thigh,
		self.shin,
		self.head,
		self.wheel,
	}
	self.thigh_torque = 30
	self.shin_torque = 20
	self.friction = 0.84
end

function Player:update(dt)
	self.x = self.body.body:getX()
	if self.thigh_backward then
		self.thigh.body:setAngularVelocity(self.thigh_torque)
	elseif self.thigh_forward then
		self.thigh.body:setAngularVelocity(-self.thigh_torque)
	else
		self.thigh.body:setAngularVelocity(self.thigh.body:getAngularVelocity() * self.friction)
	end
	if self.shin_backward then
		self.shin.body:setAngularVelocity(self.shin_torque)
	elseif self.shin_forward then
		self.shin.body:setAngularVelocity(-self.shin_torque)
	else
		self.shin.body:setAngularVelocity(self.shin.body:getAngularVelocity() * self.friction)
	end
end

function Player:draw()
	love.graphics.push()
	love.graphics.setColor(1, 1, 1, 1)
	for _, drawable in pairs(self.drawables) do
		love.graphics.draw(
			drawable.image,
			drawable.body:getX(),
			drawable.body:getY(),
			drawable.body:getAngle(),
			drawable.scale_x or 1,
			drawable.scale_y or 1,
			drawable.image:getWidth() / 2,
			drawable.image:getHeight() / 2
		)
		if DEBUG then
			love.graphics.setColor(1, 0, 0)
			if drawable.shape:typeOf("PolygonShape") then
				love.graphics.polygon("line", drawable.body:getWorldPoints(drawable.shape:getPoints()))
			elseif drawable.shape:typeOf("CircleShape") then
				love.graphics.circle("line", drawable.body:getX(), drawable.body:getY(), drawable.shape:getRadius())
			end
		end
	end
	love.graphics.pop()
end

function Player:draw_foreground(dt)
	if not self.targetted then
		return
	end
	love.graphics.push()
	love.graphics.origin()
	local overlay_sprites = {}
	if self.thigh_backward then
		table.insert(overlay_sprites, self.overlay_quads.pressed[1])
	else
		table.insert(overlay_sprites, self.overlay_quads.idle[1])
	end
	if self.thigh_forward then
		table.insert(overlay_sprites, self.overlay_quads.pressed[2])
	else
		table.insert(overlay_sprites, self.overlay_quads.idle[2])
	end
	if self.shin_backward then
		table.insert(overlay_sprites, self.overlay_quads.pressed[3])
	else
		table.insert(overlay_sprites, self.overlay_quads.idle[3])
	end
	if self.shin_forward then
		table.insert(overlay_sprites, self.overlay_quads.pressed[4])
	else
		table.insert(overlay_sprites, self.overlay_quads.idle[4])
	end
	for x, sprite in pairs(overlay_sprites) do
		love.graphics.draw(self.overlay_spritesheet, sprite, x * 40, 10)
	end
	love.graphics.pop()
end

return Player
