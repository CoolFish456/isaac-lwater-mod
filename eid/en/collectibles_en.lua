-- Item
local ItemEID = {}
local function EIDAddItem(id, content)
    if id then
        ItemEID[id] = content
    end
end

EIDAddItem(ItemID.ganShenMe,{
    Name="Gan Shen Me!",
    Descriptions=[[Usage: gain the effect of{{Collectible145}}Guppy! and spawn a blue fly in the current room
    #Has a special sound effect when used
    ]]
})
EIDAddItem(ItemID.classicTasteShavedIce,{
    Name="Classic Taste Shaved Ice",
    Descriptions=[[#{{Tears}} {{ArrowUp}}+0.5 tears
    #{{Speed}} {{ArrowDown}}-0.3 speed
    #20% chance to trigger frozen tears, not affected by luck
    ]]
})
EIDAddItem(ItemID.oneLWater,{
    Name="1L Water",
    Descriptions=[[{{SoulHeart}} +1 soul heart
    #{{Tears}} {{ArrowUp}}+0.35 tears
    #20% chance to leave a green water trail when firing tears
    #{{Luck}} luck 15：75% possibility
    ]]
})
EIDAddItem(ItemID.somebodysQuotation,{
    Name="Somebody's Quotation",
    Descriptions=[[
    #10% chance to fire a chat box tear
    #{{Luck}} luck 12：100% possibility
    #Each chat box tear has a different random effect, and the character will recite the corresponding lines
    ]]
})
EIDAddItem(ItemID.virtualShare,{
    Name="Virtual Share",
    Descriptions=[[{{Coin}} +15 coins when picked up
    #When entering the next floor, there is a 40% chance to double your coins, a 50% chance to reduce your coins by half, and a 10% chance to lose all your coins
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
