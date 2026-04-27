local cols = LWaterMod.Collectibles
local ItemEID = {}
local function EIDAddItem(id, content)
    if id then
        ItemEID[id] = content
    end
end

EIDAddItem(cols.ganShenMe.ID,{
    Name="Gan Shen Me!",
    Descriptions=[[Usage: gain the effect of{{Collectible145}}Guppy! and spawn a blue fly in the current room
    #Has a special sound effect when used
    ]]
})
EIDAddItem(cols.classicTasteShavedIce.ID,{
    Name="Classic Taste Shaved Ice",
    Descriptions=[[#{{Tears}} {{ArrowUp}}+0.5 tears
    #{{Speed}} {{ArrowDown}}-0.3 speed
    #20% chance to trigger frozen tears, not affected by luck
    ]]
})
EIDAddItem(cols.oneLWater.ID,{
    Name="1L Water",
    Descriptions=[[{{SoulHeart}} +1 soul heart
    #{{Tears}} {{ArrowUp}}+0.35 tears
    #12% chance to leave a green water trail when firing tears
    #{{Luck}} luck 15：75% possibility
    ]]
})
EIDAddItem(cols.somebodysQuotation.ID,{
    Name="Somebody's Quotation",
    Descriptions=[[
    #10% chance to fire a chat box tear
    #{{Luck}} luck 12：100% possibility
    #Each chat box tear has a different random effect, and the character will recite the corresponding lines
    ]]
})
EIDAddItem(cols.virtualShare.ID,{
    Name="Virtual Share",
    Descriptions=[[{{Coin}} +15 coins when picked up
    #When entering the next floor, there is a 40% chance to double your coins, a 50% chance to reduce your coins by half, and a 10% chance to lose all your coins
    ]]
})
EIDAddItem(cols.koishisHat.ID,{
    Name="Koishi's Hat",
    Descriptions=[[{{Battery}} Charge time 2 seconds
    #When used, throw a Koishi's Hat that deals 3.5 damage per hit to enemies on the path
    #The hat will fly back to the player's hand after flying a certain distance, dealing 6.5 damage per hit to enemies on the path during the return process
    ]]
})
EIDAddItem(cols.stopFemaleClothing.ID,{
    Name="Stop Female Clothing",
    Descriptions=[[Remove all items with the {{Mom}} "Mom" tag from the player when picked up
    #These items will also not appear in the current run
    #Lose 8 coins when picked up, but why?
    ]]
})
EIDAddItem(cols.lilHina.ID,{
    Name="Lil' Hina",
    Descriptions=[[Gain the "Lil' Hina" follower
    #The "Lil' Hina" follower follows the character and sprays a large number of tears around every 3 seconds when the character attacks, dealing 4.5 damage
    #{{Luck}} {{ArrowDown}}-1 luck
    ]]
})
EIDAddItem(cols.snakebite.ID,{
    Name="蛇咬",
    Descriptions=[[After use, all enemies in the room are inflicted with 2 seconds of {{Poison}} poison effect
    #{{Poison}} The poison effect: deals 7 damage each time
    #{{Warning}} No effect on bosses
    ]]
})
EIDAddItem(cols.demonForm.ID,{
    Name="恶魔形态",
    Descriptions=[[{{Damage}} {{ArrowUp}}+2 damage
    #{{Damage}} {{ArrowUp}}+3 damage when entering the next floor
    ]]
})

local language = "en_us"
local descriptions = EID.descriptions[language]
for id,item in pairs(ItemEID) do
    EID:addCollectible(id,item.Descriptions,item.Name,language)
    if (item.BookOfVirtues and descriptions.bookOfVirtuesWisps) then
        descriptions.bookOfVirtuesWisps[id] = item.BookOfVirtues
    end
end
