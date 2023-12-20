local Background = class("Background", {
	drawable_background true,
	is_player = true,
	jumped = 1,
})

function Background:draw(dt)
  love.graphics.clear()
end

return Background
