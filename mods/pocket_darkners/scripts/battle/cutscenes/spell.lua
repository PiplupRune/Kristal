return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    level5 = function(cutscene, battler, enemy)
        
        cutscene:text("this is a test of the cutscene")
        cutscene:text("* this is where all the text magic happens")
        cutscene:text("* Due to the way this works you can not reject spells but thats okay makes it more deltarune")

    end
}