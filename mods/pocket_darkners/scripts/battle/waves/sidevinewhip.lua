local SideVineWhip, super = Class(Wave)

function SideVineWhip:init()
    super.init(self)

    -- The duration of our wave, in seconds. (Defaults to `5`)
    self.time = 8.5
end

function SideVineWhip:onStart()
    -- code here gets called at the start of the wave

    -- create a bullet in the center of the screen
    local x, y = Game.battle.arena:getCenter()
    self.timer:every(1, function()
        local x = self:getSideX()
        local bullet = self:spawnBullet("vinewhipbullet", x, (y + love.math.random(-60,60)))  -- sets the y to pretty much anywhere within the battle box bounds
        bullet:setParent(Game.battle.arena.mask)
        local x, y = Game.battle.arena:getCenter()
        local x = self:getSideX()
        bullet:setScreenPos(x, (y + love.math.random(-60,60)))  -- sets the y to pretty much anywhere within the battle box bounds
        bullet.visible = false
        bullet:drawTelegraph(bullet.y, Game.battle.arena.width)
        bullet.rotation = self:getRotation(x)  -- gets rotation based on position
        bullet.physics.direction = self:getDirection(x)  -- gets direction based on position
        bullet:slideTo(bullet.x + self:getEdgePos(x), bullet.y, 0.5)
        self.timer:after(0.5, function()
            Assets.playSound("grab")
        end)
        self.timer:after(2, function()
            bullet:slideTo(bullet.x - self:getEdgePos(x), bullet.y, 1)
        end)
-- BEGINNING OF ALLY CODE --

        -- spawn a telegraph line
        -- ill just spawn a rectangle object
        local arena_left = Game.battle.arena:getLeft()
        local arena_width = Game.battle.arena:getRight() - arena_left
        local rectangle = Rectangle(arena_left, bullet.y, arena_width, 1)

        self:spawnObject(rectangle)
        
-- END OF ALLY CODE --
        
    end, 5)    -- we need this part so it does it ten times
end

--function SideVineWhip:draw()
 --           love.graphics.line(Game.battle.arena:getLeft(), bullet.y, Game.battle.arena:getRight(), bullet.y)
 --       super.draw(self)
 --           love.graphics.setColor(COLORS.red) -- Draw in pure red
 ---           love.graphics.setLineWidth(1) -- Draw 1px line
  --          love.graphics.setLineStyle("rough") -- Draw the line with rough edges
  --          
  --      end

function SideVineWhip:update()
    -- code here gets called every frame

    super.update(self)
end

function SideVineWhip:getSideX()
    local rand = love.math.random(1,2)
    if rand == 1 then
        return SCREEN_WIDTH/2 + 180 -- right
    else
        return SCREEN_WIDTH/2 - 180  -- left
    end
end

function SideVineWhip:getRotation(x)
    if x == (SCREEN_WIDTH/2 + 180) then
        return math.rad(180)  -- right
    else
        return math.rad(0)  -- left
    end
end

function SideVineWhip:getDirection(x)
    if x == (SCREEN_WIDTH/2 + 180) then
        return math.pi  -- right
    else
        return 0  -- left
    end
end

function SideVineWhip:getEdgePos(x)
    if x == (SCREEN_WIDTH/2 + 180) then
        return -160  -- right
    else
        return 160  -- left
    end
end

return SideVineWhip