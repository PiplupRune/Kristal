local bullet, super = Class(Bullet)

function bullet:init(x, y)
    super.init(self, x, y, "bullets/razorleaf")

    self.collider = CircleCollider(self, self.width / 2, self.height / 2, 6)
end

return bullet