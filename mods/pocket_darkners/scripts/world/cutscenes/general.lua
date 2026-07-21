return {
    pause_music = function(cutscene, event)
        Game.world.music:pause()
        
    end,

    pause_music_and_reset_border = function(cutscene, event)
        Game.world.music:pause()
        Game:setBorder("placeholder")
        love.window.setTitle("THIS IS NEW")
    end,

    entrance_chamber_2_save_gaster = function(cutscene, event)
        love.window.setTitle("IT SEEMS SOMEBODY HAS BEEN TAMPERING WITH MY DELTARUNE")
    end,
}