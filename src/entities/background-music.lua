local Bg = class("BackgroundMusic")

function Bg:init()
	self.is_audio = true
	self.source = love.audio.newSource("assets/bg.wav", "stream")
	self.source:setVolume(1)
	self.source:setLooping(true)
end

function Bg:play()
	if not self.source:isPlaying() then
		love.audio.play(self.source)
	end
end

return Bg
