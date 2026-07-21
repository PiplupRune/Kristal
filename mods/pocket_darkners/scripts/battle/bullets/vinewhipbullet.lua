local VineWhipBullet, super = Class(Bullet)

function VineWhipBullet:init(x, y)
    super.init(self, x, y, "bullets/vinewhip")
    
    
end

function VineWhipBullet:drawTelegraph(start_y, length) 
    local rect = Rectangle(Game.battle.arena:getLeft(), start_y, 1, length)  
    rect:setLayer(BATTLE_LAYERS["below_bullets"])
    rect.rotation = math.rad(270)
    Assets.playSound("alert") 
    self.wave:spawnObject(rect) 
    rect:setColor(COLORS.red)
    rect.alpha = 0.7 
    self.wave.timer:after(0.5, function() 
    self.visible = true -- resets it to make it visible
        rect:remove() 
    end) 
end

function VineWhipBullet:update()
    super.update(self)
end

return VineWhipBullet