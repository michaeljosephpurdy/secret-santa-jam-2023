local MusicSystem = tiny.processingSystem()
MusicSystem.filter = tiny.requireAll("is_audio")

function MusicSystem:process(e, dt)
	e:play()
end

return MusicSystem
