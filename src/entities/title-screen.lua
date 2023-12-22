local TitleScreen = class("TitleScreen", {
	camera_follow = true,
})

function TitleScreen:init(props)
	self.x = -300
	self.y = 0
	self.title_img = love.graphics.newImage("assets/title.png")
	self.title_img_offset = self.title_img:getWidth() / 2
	local font = love.graphics.getFont()
	self.text =
		love.graphics.newText(font, "press 'Q' to start\na game by Mike Purdy\nfor donnn for Secret Santa Jam 2023")
	self.tree_img = love.graphics.newImage("assets/tree.png")
end

function TitleScreen:update(dt)
	if love.keyboard.isDown("q") then
		self.world:removeEntity(self)
		PubSub.publish("title.over")
		PubSub.publish("game.start")
	end
end

function TitleScreen:draw(dt)
	local variant = math.sin(love.timer:getTime())
	local rotation = variant * variant * 0.2
	local scale_x = 0.9 + variant * 0.1
	local scale_y = 0.9 + variant * 0.1
	love.graphics.draw(self.tree_img, self.x - SCREEN_SIZE * 1.75 / 3, self.y) -- + self.title_img_offset * 0.3)
	love.graphics.draw(
		self.title_img,
		self.x - SCREEN_SIZE * 1.75 / 3,
		self.y + self.title_img_offset * 1.1,
		rotation,
		scale_x,
		scale_y,
		self.title_img_offset,
		self.title_img_offset
	)
end

function TitleScreen:draw_foreground(dt)
	love.graphics.push()
	love.graphics.origin()
	love.graphics.setColor({ 0, 0, 0 })
	love.graphics.draw(self.text, 40, SCREEN_SIZE - 120, 0, 2, 2)
	love.graphics.pop()
end

return TitleScreen
