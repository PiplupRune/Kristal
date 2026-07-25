local RippleEffect, super = Class(Object)

function RippleEffect:init(x, y, color, start_radius, max_radius, speed)
    super.init(self, x, y)
    self.color = color or COLORS.white
    self.radius = start_radius or 10
    self.max_radius = max_radius or 80
    self.speed = speed 
    self.alpha = 1
    self.layer = BATTLE_LAYERS["below_battlers"]
    self:setOrigin(0.5, 0.5) -- probably does nothing but eh lol
end

function RippleEffect:update()
    super.update(self)
    self.radius = self.radius + (self.speed * DTMULT)
    local progress = math.min(1, self.radius / self.max_radius)
    self.alpha = 1 - progress
    if self.radius >= self.max_radius then
        self:fadeOutAndRemove(0.5)
    end
end

function RippleEffect:draw()
    super.draw(self)
    local r, g, b = unpack(self.color)
    Draw.setColor(r, g, b, self.alpha)
    love.graphics.setLineWidth(4)
    love.graphics.circle("line", 0, 0, self.radius) -- okay :3 gosh i love commenting lmfao 
    love.graphics.setLineWidth(1)
    Draw.setColor(1, 1, 1, 1)
end

return RippleEffect
