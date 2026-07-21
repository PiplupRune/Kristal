local actor, super = Class(Actor, "shopkeepers/spamtog")

function actor:init()
    super.init(self)

    self.name = "Spamtog"

    self.width = 125
    self.height = 120

    self.path = "shopkeepers/spamtog"
    self.default = "idle"
    self.voice = "spamtog"
    
    self.animations = {
        ["idle"] = {"idle", function(sprite, wait)
            while true do
                sprite:setFrame(1)
                wait(2)
                sprite:setFrame(2)
                wait(3/30)
                sprite:setFrame(3)
                wait(3/30)
                sprite:setFrame(2)
                wait(3/30)
            end
        end}
    }

    self.talk_sprites = {
        ["talk"] = 0.125,
    --    ["explaining_talk"] = 0.125,
        ["left_talk"] = 0.125,
        ["crazy_talk"] = 0.125,
        ["annoyed_talk"] = 0.125,
        ["smug_talk"] = 0.125
    }

    --self.offsets = {
    --  ["explaining"] = {-26, 0},
    --  ["explaining_talk"] = {-26, 0}
    --}
end

function actor:onTalkStart(text, sprite)
    if sprite.sprite == "idle" then
      sprite:setSprite("talk")
    elseif sprite.sprite == "left" then
        sprite:setSprite("left_talk")
    --elseif sprite.sprite == "explaining" then
    --    sprite:setSprite("explaining_talk")
    elseif sprite.sprite == "crazy" then
        sprite:setSprite("crazy_talk")
    elseif sprite.sprite == "annoyed" then
        sprite:setSprite("annoyed_talk")
    elseif sprite.sprite == "smug" then
        sprite:setSprite("smug_talk")
    end
end

function actor:onTalkEnd(text, sprite)
    if sprite.sprite == "talk" then
        sprite:setAnimation("idle")
    elseif sprite.sprite == "left_talk" then
        sprite:setSprite("left")
    --elseif sprite.sprite == "explaining_talk" then
    --    sprite:setSprite("explaining")
    elseif sprite.sprite == "crazy_talk" then
        sprite:setSprite("crazy")
    elseif sprite.sprite == "annoyed_talk" then
        sprite:setSprite("annoyed")
    elseif sprite.sprite == "smug_talk" then
        sprite:setSprite("smug")
    end
end

return actor