local SpamtogShopQuaintonRiverbed, super = Class(Shop, "spamtogs_secret_shop_west_of_quainton")

function SpamtogShopQuaintonRiverbed:init()
    super.init(self)
    love.window.setTitle("I WILL BE SUING FOR INTELLECTUAL PROPERTY INFRINGEMENT ONCE YOU ARE DONE HERE")
    self.encounter_text = "[emote:idle]* HELL   EVRY !![wait:5] IT'S ME, SPAMTOG SPAMTO! !\n[wait:5]* WELCOME TO MY [voice:none][sound:voice/spamtog/itsasecret][It's a secret to everybody][wait:0.75s][voice:spamtog] SHOP!","spamtog" --When you enter the shop
    self.shop_text = "[emote:idle]* [voice:none][sound:voice/spamtog/buysomething][Buy Somethin' Will Ya!][voice:spamtog]" --Flavour text
    self.leaving_text = "[emote:crazy]* YOU CAN NEVER ESCAPE!" --Upon exiting
    self.buy_menu_text = "[emote:idle]DO YOU\nLIKE MY\n[voice:none][sound:voice/spamtog/wears][wears][voice:spamtog]??" -- Text when in the BUY menu
    self.buy_refuse_text = "[emote:annoyed]NOT GOOD ENOUGH FOR [voice:none][sound:voice/spamtog/you][u][voice:spamtog], EH?" -- If you refuse to purchase
    self.buy_text = "[emote:crazy]MUCH [voice:none][sound:voice/spamtog/depreciated][depreciated][voice:spamtog]!!" --If you successfully buy an item
    self.buy_storage_text = "[emote:idle]I PUT THAT IN YOUR [voice:none][sound:voice/spamtog/storage][Storage Wars][voice:spamtog]" -- If you have no INV space, and the item goes to STORAGE
    self.buy_too_expensive_text = "[emote:annoyed]NOT ENOUGH CHROME" -- Not enough money to buy
    self.buy_no_space_text = "[emote:annoyed]YOU MUST [voice:none][sound:voice/spamtog/downloadram][download additional RAM][voice:spamtog]." -- You don't have room
    self.sell_no_price_text = "[emote:annoyed]OFFER DECLINED" -- If you can't sell the item (see Wood sword)
    self.sell_menu_text = "[emote:crazy]A [voice:none][sound:voice/spamtog/presents][presents][voice:spamtog] FOR [voice:none][sound:voice/spamtog/lilolme][lil' ol' me][voice:spamtog]?!" --Offering to sell
    self.sell_nothing_text = "[emote:smug]YOU [voice:none][sound:voice/spamtog/literate][literate][voice:spamtog]LY HAVE NOTHING" -- If you have nothing to sell
    self.sell_refuse_text = "[emote:annoyed]NO CHROME FOR YOU" -- If you cancel a selling
    -- Shown when you sell something
    self.sell_text = "[emote:idle]CHROME FOR YOU!"
    self.sell_everything_text = "[emote:idle]CHROME FOR YOU!"
    -- Shown when you have nothing in a storage
    self.sell_no_storage_text = "[emote:annoyed]WHAT AM I EVEN [voice:none][sound:voice/spamtog/men][men!][voice:spamtog]t 2 B LOOKING @"
    -- Shown when you enter the talk menu.
    self.talk_text = "[emote:smug]WHA7 CAN I D0 YOU FOR, LI<< NERS?"

    self.currency_text = "%d CHROME"

    self.sell_options_text = {}
    self.sell_options_text["items"]   = "[emote:idle]ITEMS FOR CHROME?"
    self.sell_options_text["weapons"] = "[emote:idle]WEAPONS FOR CHROME?"
    self.sell_options_text["armors"]  = "[emote:idle]ARMORS FOR CHROME?"
    self.sell_options_text["storage"] = "[emote:idle]ANYTHINGS FOR CHROME?"

    self.background = "ui/shop/bg_spamtog" -- The background, found in the corresponding folder
    self.shop_music = "pokedaa_mus_shop_mysterious_us3" --replace with your music file

    self.shopkeeper:setActor("shopkeepers/spamtog")
    --self.shopkeeper.sprite:setPosition(0, 8)
    --self.shopkeeper.slide = true

    self:registerItem("darkburger")
    self:registerItem("oran_berry")
    self:registerItem("darkburger")
    self:registerItem("darkburger")

    self:registerTalk("You look familiar...")
    self:registerTalk("Got any deals?")
    self:registerTalkAfter("Error 401?", 2, "talk_2_1", true)
    self:registerTalk("Why do you want chrome?")
    self:registerTalkAfter("Other browsers?", 3, "talk_3_1", true)
end

function SpamtogShopQuaintonRiverbed:startTalk(talk)
    if talk == "You look familiar..." then
        self:startDialogue({"[emote:annoyed]* WHAT COULD ÿOU [voice:none][sound:voice/spamtog/impossible][impossible][voice:spamtog]LY MEAN?[wait:5]\n* MY [voice:none][sound:voice/spamtog/customfit][Custom-fit apparel][voice:spamtog] IS COMPLE7ELY ORIGINAL!";
        "* ...";"* \"SPAMTON G. SPAMTON?\"![wait:5]\n* WHAT æRE YOU [voice:none][sound:voice/spamtog/on][on][voice:spamtog]?!";
        "[emote:crazy]* I'M THE [voice:none][sound:voice/spamtog/oneandonly][one and only!!][voice:spamtog] AND ONLY SPAMTOG SPAMTO [voice:none][sound:voice/spamtog/numberone][NumberOneSale197][voice:spamtog]!!!1"}, function ()
            self.shopkeeper:setSprite("talk")
        end)
    elseif talk == "Got any deals?" then
        self:startDialogue({"[emote:crazy]* DO I!";
        "[emote:smug]* ALRIGHT,[wait:5] [voice:none][sound:voice/spamtog/listenclosely][listen closely][voice:spamtog],[wait:5] KID.";
        "* HAVE YOU EVER WANTED TO BE A [voice:none][sound:voice/spamtog/taskfailed][Task failed successfully][voice:spamtog] IN LIFE?";
        "[emote:annoyed]* AR3 YOUR [voice:none][sound:voice/spamtog/friends][friends][voice:spamtog] AREN'T  '        ,,     EN[wait:1]OUGH?!";
        "[emote:crazy]* FELT LIKE A [voice:none][sound:voice/spamtog/zxcvbnm][zxcvbnm][voice:spamtog] EVER SINCE THEY TOOK THE [     ] IN THE DIVORCE?!?!";
        "[emote:smug]* THEN [voice:none][sound:voice/spamtog/child][child][voice:spamtog] DO I HA[wait:3]VE A [shake:1]GREAT[shake:0] DEAL-";
        "[emote:crazy]* NO,[wait:5] THE [shake:2]BEST[shake:0] DEAL";
        "[emote:smug]* NOW[wait:5] IS YOUR CHANCE[wait:5] TO BE A [voice:none][sound:voice/spamtog/shot][shot][voice:spamtog]!";
        "[emote:idle]* NOW,[wait:5] I [voice:none][sound:voice/spamtog/no][no!!][voice:spamtog] WHAT YOU'RE THI[wait:0.5]NKING";
        "* MISTER SPAMTOG SPAMTOG SPAMTOG SPAMTOG SPAMTOG SPA[next]";
        "* HOW DOES [voice:none][sound:voice/spamtog/one][one (1)][voice:spamtog] BECOME A [voice:none][sound:voice/spamtog/shot][shot][voice:spamtog]?";
        "* WELL,[wait:5][emote:smug] I'M GLAD YOU ASKED!";
        "* TO BE THE [voice:none][sound:voice/spamtog/shot][shot][voice:spamtog] YOU'VE ALWAYS WANTED [voice:none][sound:voice/spamtog/two][two (2)][voice:spamtog] BE,[wait:5] ALL YOU NEED IS...";
        "* A HEALTHY DOSE OF [voice:none][sound:voice/spamtog/error401][ERROR 401 FILE ACCESS DENIED][voice:spamtog]!";
        "[emote:smug]* EH?[wait:5] SOUND [voice:none][sound:voice/spamtog/intoxicating][intoxicating][voice:spamtog]?[wait:5]IF YOU'RE [voice:none][sound:voice/spamtog/interest][interest rates are through the][voice:spamtog],[wait:5] JUST [voice:none][sound:voice/spamtog/clickorcall][click or call today][voice:spamtog]!"}, function()
            -- This flag is set, so Kristal knows replace this 
            -- dialogue option with "Error 401"
            self:setFlag("talk_2_1", true)
        end)
    elseif talk == "Error 401?" then
        self:startDialogue({"[emote:idle]* I HAVE NO [voice:none][sound:voice/spamtog/thatsawonderful][That's a wonderful--][voice:spamtog] WHAT YOU JUST SAID.";
        "* NO,[wait:5] SERIOUSLY.[wait:5]\n* YOUR MOUTH MOVED BUT NO [voice:none][sound:voice/spamtog/sweetsiound][the sweet sound of][voice:spamtog] CAME OUT.";
        "* THAT'S...[wait:5] UNUSUAL."}, function ()
            self.shopkeeper:setSprite("talk")
        end)
    elseif talk == "Why do you want chrome?" then
        self:startDialogue({"[emote:idle]* WHY,[wait:5] [voice:none][sound:voice/spamtog/ifitisn't][if it isn't the][voice:spamtog] ISN'T THÊ BEST INTERNET [voice:none][sound:voice/spamtog/eyebrows][eyebrow trimmers onsale $20 off][voice:spamtog] THERE IS!";
        "* GOTTA HAVE THAT [emote:crazy][shake:2][speed:0.25]DELICOUS CHROME[shake:0][speed:1]!"}, function()
            -- This flag is set, so Kristal knows replace this 
            -- dialogue option with "Other browsers"
            self:setFlag("talk_3_1", true)
        end)
    elseif talk == "Other browsers?" then
        self:startDialogue({"[emote:annoyed]* DON'þ YOU [voice:none][sound:voice/spamtog/no][no!!][voice:spamtog] [voice:none][sound:voice/spamtog/chrome][[font:qooqle]Qooqle Chrome™ [font:reset]][voice:spamtog] IS THE BEST [text \"STOP\" to [voice:none][sound:voice/spamtog/tooptout][style:GONER]427837[style:dark][voice:spamtog] to opt out]ION THERE IS!";
        "[emote:left]* [voice:none][sound:voice/spamtog/internetconquistador][Internet Conquistador™][voice:spamtog] HASN'T BEEN UPD@TED IN YEARS!";
        "[emote:smug]* [voice:none][sound:voice/spamtog/opera][Operahus EX™][voice:spamtog] IS A [color:#5C3EAC]RAM[color:white] HOG!";
        "[emote:left]* [voice:none][sound:voice/spamtog/vulcanvulpes][Modzilla VulcanVulpes™][voice:spamtog] IS...";
        "[emote:idle]* WELL ACTUALLY I DON'T [voice:none][sound:voice/spamtog/cook][[--se we have to c--]][voice:spamtog] ANYTHING AGAINST IT,[wait:5] I JUST DON'T LIKE CHANGE.";
        "[emote:smug]* I'LL [voice:none][sound:voice/spamtog/except][except][voice:spamtog] YOvR PO CK[wait:2]E T CHAN[wait:3]GE,[wait:5] THOUGH!"}, function ()
            self.shopkeeper:setSprite("talk")
        end)
    end
end

function SpamtogShopQuaintonRiverbed:drawMoney()
    Draw.setColor(COLORS.white)
    love.graphics.setFont(self.font)
    love.graphics.print(string.format(self.currency_text, self:getMoney()), 440, 420, math.rad(0), 0.6, 1)
end

function SpamtogShopQuaintonRiverbed:drawBuyItems(draw_soul)
    local heart_pos = 30
    local text_pos = 60

    local total_items = #self.items + 1
    local visible_items = 5

    local first_item = 1 + self.item_offset
    local last_item = self.item_offset + visible_items

    local return_index = math.max(last_item, total_items)

    -- Show items
    for i = first_item, last_item do
        local y = 220 + ((i - self.item_offset) * 40)
        local item = self.items[i]

        if i == return_index then
            Draw.setColor(COLORS.white)
            love.graphics.print("Exit", text_pos, y)
        elseif item == nil then
            -- If there's no item there, show empty slot
            Draw.setColor(COLORS.dkgray)
            love.graphics.print("--------", text_pos, y)
        elseif item.options["stock"] and (item.options["stock"] <= 0) then
            -- If we've depleted the stock, show a "sold out" message
            Draw.setColor(COLORS.gray)
            love.graphics.print("--SOLD OUT--", text_pos, y)
        else
            -- Valid item, show it
            Draw.setColor(item.options["color"])
            love.graphics.print(item.options["name"], text_pos, y)
            if not self.hide_price then
                Draw.setColor(COLORS.white)
                love.graphics.print(string.format(self.currency_text, item.options["price"] or 0), 260, y, math.rad(0), 0.8, 1)
            end
        end

        if draw_soul and (i == self.current_selected_item) then
            -- Draw the soul if we're selecting this option
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, heart_pos, y + 10)
        end
    end
end

function SpamtogShopQuaintonRiverbed:drawSellItems(confirming)
    local inventory = Game.inventory:getStorage(self.selected_storage)

    if inventory == nil then
        Draw.setColor(COLORS.ltgray)
        love.graphics.print("Invalid storage", 60, 260)
        return
    end

    -- Draw the soul
    Draw.setColor(Game:getSoulColor())
    Draw.draw(self.heart_sprite, 30, 230 + ((self.current_selected_item - self.item_offset) * 40))

    Draw.setColor(COLORS.white)

    for i = 1 + self.item_offset, self.item_offset + math.min(5, inventory.max) do
        local item = inventory[i]
        love.graphics.setFont(self.font)

        if item then
            Draw.setColor(COLORS.white)
            love.graphics.print(item:getName(), 60, 220 + ((i - self.item_offset) * 40))
            if item:isSellable() then
                love.graphics.print(string.format(self.currency_text, item:getSellPrice()), 260, 220 + ((i - self.item_offset) * 40), math.rad(0), 0.8, 1)
            end
        else
            Draw.setColor(COLORS.dkgray)
            love.graphics.print("--------", 60, 220 + ((i - self.item_offset) * 40))
        end
    end

    local max = inventory.max
    if inventory.sorted then
        max = #inventory
    end

    Draw.setColor(COLORS.white)

    if max > 5 then
        for i = 1, max do
            local percentage = (i - 1) / (max - 1)
            local height = 129

            local draw_location = percentage * height

            local tocheck = self.current_selected_item

            if confirming and (Game.chapter <= 2) then
                -- DR bug -- if in the confirming menu, use the wrong variable
                -- TODO: Game.chapter usage!
                tocheck = self.current_selecting_choice
            end

            if i == tocheck then
                love.graphics.rectangle("fill", 372, 292 + draw_location, 9, 9)
            elseif inventory.sorted then
                love.graphics.rectangle("fill", 372 + 3, 292 + 3 + draw_location, 3, 3)
            end
        end

        -- Draw arrows
        if not confirming then
            local sine_off = math.sin((Kristal.getTime() * 30) / 6) * 3
            if self.item_offset + 4 < (max - 1) then
                Draw.draw(self.arrow_sprite, 370, 149 + sine_off + 291)
            end
            if self.item_offset > 0 then
                Draw.draw(self.arrow_sprite, 370, 14 - sine_off + 291 - 25, 0, 1, -1)
            end
        end
    end
end

return SpamtogShopQuaintonRiverbed
