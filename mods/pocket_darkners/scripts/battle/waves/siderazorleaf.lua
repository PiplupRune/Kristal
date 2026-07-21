local SideRazorLeaf, super = Class(Wave)

function SideRazorLeaf:init()
    super.init(self)

    -- The duration of our wave, in seconds. (Defaults to `5`)
    self.time = 7.5
end

function SideRazorLeaf:onStart()
    -- code here gets called at the start of the wave

    -- create a bullet in the center of the screen
    
    local x, y = Game.battle.arena:getCenter()
    self.timer:every(0.5, function()
        local x = self:getSideX()
        local bullet = self:spawnBullet("bullets/razorleaf", x, (y + love.math.random(-60,60)))  -- sets the y to pretty much anywhere within the battle box bounds
        bullet.physics.speed = 5
        bullet.rotation = self:getRotation(x)  -- gets rotation based on position
        bullet.physics.direction = self:getDirection(x)  -- gets direction based on position
        bullet.graphics.spin = self:getSpin(x)  -- gets spin, you know the drill
        bullet.alpha = 0
        bullet:fadeTo(1, 0.5)
        self.timer:after(1.8,function()
            bullet:fadeTo(0, 0.5)
        end)
        
    end, 10)    -- we need this part so it does it ten times
    
    super.update(self)
end

function SideRazorLeaf:update()
    -- code here gets called every frame

    super.update(self)
end

function SideRazorLeaf:getSideX()
    local rand = love.math.random(1,2)
    if rand == 1 then
        return SCREEN_WIDTH/2 + 180 -- right
    else
        return SCREEN_WIDTH/2 - 180  -- left
    end
end

function SideRazorLeaf:getRotation(x)
    if x == (SCREEN_WIDTH/2 + 180) then
        return math.rad(180)  -- right
    else
        return math.rad(0)  -- left
    end
end

function SideRazorLeaf:getDirection(x)
    if x == (SCREEN_WIDTH/2 + 180) then
        return math.pi  -- right
    else
        return 0  -- left
    end
end

function SideRazorLeaf:getSpin(x)
    if x == (SCREEN_WIDTH/2 + 180) then
        return 100  -- right
    else
        return -100  -- left
    end
end

return SideRazorLeaf
