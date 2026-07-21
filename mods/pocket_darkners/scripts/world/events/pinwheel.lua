-- Extend the Event class, and set the ID to "pinwheel"
-- This is what you'll use to refer to the event in Tiled
local PinwheelEvent, super = Class(Event, "pinwheel")

-- `data` is the data directly from Tiled
function PinwheelEvent:init(data)
    -- Place the event at the correct position, and make the size 20x20
    super.init(self, data.x, data.y, 20, 20, data)

    -- Any custom properties are stored in `data.properties`, but we don't use any.

    -- Just some variables for the pinwheel
    self.min_speed = 2
    self.speed_slowdown = 0.5
    self.speed = self.min_speed
    self.pinwheel_rotation = 0

    -- Most events in DELTARUNE are 2x sized
    self:setScale(2)

    -- We placed a single point in Tiled, which we want to be the bottom center of the pinwheel
    self:setOrigin(0.5, 1)
end

-- Update gets called every frame
function PinwheelEvent:update()
    super.update(self)

    -- Make it rotate using the speed
    self.pinwheel_rotation = self.pinwheel_rotation + (self.speed * DTMULT)

    -- If it's going too fast, slow it down
    if self.speed > self.min_speed then
        self.speed = self.speed - self.speed_slowdown * DTMULT
    end

    -- Make sure it doesn't go below the minimum speed
    self.speed = math.max(self.speed, self.min_speed)
end

function PinwheelEvent:draw()
    super.draw(self)

    -- First, draw the base
    love.graphics.draw(Assets.getTexture("pinwheel_base"), 0, 0, 0, 1, 1)
    -- Then draw the pinwheel, spinning
    love.graphics.draw(Assets.getTexture("pinwheel"), 10, 10, math.rad(self.pinwheel_rotation), 1, 1, 6, 6)
end

-- When we interact with the pinwheel, make it spin faster!
function PinwheelEvent:onInteract()
    self.speed = 60
end

return PinwheelEvent