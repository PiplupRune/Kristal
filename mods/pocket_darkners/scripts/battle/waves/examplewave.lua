local ExampleWave, super = Class(Wave)

function ExampleWave:init()
    super.init(self)

    -- The duration of our wave, in seconds. (Defaults to `5`)
    self.time = 5
end

function ExampleWave:onStart()
    -- code here gets called at the start of the wave
end

function ExampleWave:update()
    -- code here gets called every frame

    super.update(self)
end

return ExampleWave