local VineWhipBullet, super = Class(Bullet)

function VineWhipBullet:init(x, y)
    super.init(self, x, y, "bullets/vinewhip")

    self:setOrigin(0, 0.5)
    self:setHitbox(0, 2, 100, 4)

    self.destroy_on_hit = false

    self.telegraph = true
end

function VineWhipBullet:draw()
    if self.telegraph then
        love.graphics.setLineWidth(1)
        Draw.setColor(COLORS.red)

        love.graphics.line(-400, self.height / 2, 400, self.height / 2)
    end

    Draw.setColor(1, 1, 1, 1)

    super.draw(self)
end

return VineWhipBullet