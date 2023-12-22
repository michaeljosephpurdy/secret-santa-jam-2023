local CameraSystem = tiny.processingSystem()
CameraSystem.filter = tiny.requireAll("camera_follow")

function lerp(a, b, t)
	return (1 - t) * a + t * b
end

function CameraSystem:onAddToWorld(world)
	self.is_draw_system = true
	self.push = require("plugins.push")
	self.push:setupScreen(SCREEN_SIZE, SCREEN_SIZE, SCREEN_SIZE, SCREEN_SIZE, { fullscreen = false, resizable = true })
	self.push:setBorderColor({ 0, 0, 0 })
	self.offset = SCREEN_SIZE * 0.3
	self.targets = {}
	self.old_position = 0
	self.position = 1
	PubSub.subscribe("love.resize", function(data)
		self.push:resize(data[1], data[2])
	end)
end

function CameraSystem:onAdd(e)
	table.insert(self.targets, e)
end
function CameraSystem:onRemove(e)
	for i, val in pairs(self.targets) do
		if val == e then
			table.remove(self.targets, i)
		end
	end
end

function CameraSystem:process(e, dt)
	if not self.targets[1] or not self.targets[1].x then
		return
	end
	self.targets[1].targetted = true
	-- TODO: fix this damn lerping
	self.old_position = self.position
	self.position = lerp(self.old_position, self.targets[1].x, 1)
	love.graphics.translate(-self.position + self.offset, 0)
end

function CameraSystem:preWrap(dt)
	self.push:start()
end

function CameraSystem:postWrap(dt)
	self.push:finish()
end

return CameraSystem
