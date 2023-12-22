local Clock = class("Clock")

function Clock:init(props)
	self:reset()
	PubSub.subscribe("title.over", function()
		self.calculate_time = true
	end)
	PubSub.subscribe("game.over", function()
		self.calculate_time = false
		self.show_time = true
	end)
end

function Clock:reset()
	self.milliseconds = 0
	self.seconds = 0
	self.minutes = 0
end

function Clock:update(dt)
	if not self.calculate_time then
		return
	end
	if self.show_time then
		return
	end
	self.milliseconds = self.milliseconds + dt
	if self.milliseconds >= 1 then
		self.milliseconds = self.milliseconds - 1
		self.seconds = self.seconds + 1
	end
	if self.seconds >= 60 then
		self.seconds = self.seconds - 60
		self.minutes = self.minutes + 1
	end
end

function Clock:draw_foreground(dt)
	if not self.show_time then
		return
	end
	love.graphics.push()
	love.graphics.origin()
	local seconds = tostring(self.seconds)
	if #seconds < 2 then
		seconds = "0" .. tostring(seconds)
	end
	love.graphics.setColor({ 1, 1, 1 })
	love.graphics.print("Thanks for playing!", 40, SCREEN_SIZE * 2 / 3, 0, 3, 3)
	love.graphics.print(
		string.format("your time: %s:%s", self.minutes, self.seconds),
		40,
		(SCREEN_SIZE * 2 / 3) + 50,
		0,
		3,
		3
	)
	love.graphics.pop()
end

return Clock
