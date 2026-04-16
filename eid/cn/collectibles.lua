-- Item
local ItemEID = {}
local function EIDAddItem(id, content)
    if id then
        ItemEID[id] = content
    end
end

EIDAddItem(ItemID.ganShenMe,{
    Name="干什么!",
    Descriptions=[[在当前房间内，获得{{Collectible145}}嗝屁猫!的效果并生成一只蓝苍蝇
    #使用时，阿燐会哈气
    ]]
})
EIDAddItem(ItemID.classicTasteShavedIce,{
    Name="老味刨冰",
    Descriptions=[[#{{Tears}} {{ArrowUp}}+0.7射速
    #{{Speed}} {{ArrowDown}}-0.3移速
    #冰冻泪弹
    ]]
})
EIDAddItem(ItemID.oneLWater,{
    Name="1L水",
    Descriptions=[[{{SoulHeart}} +1魂心
    #{{Tears}} {{ArrowUp}}+0.35射速修正
    #发射泪弹有20%概率在泪弹飞行过程中留下绿色水迹
    #{{Luck}} 幸运15：75%概率
    ]]
})
EIDAddItem(ItemID.somebodysQuotation,{
    Name="某人的语录",
    Descriptions=[[
    #有10%概率发射聊天框泪弹
    #{{Luck}} 幸运12：100%概率
    #每一个聊天框泪弹具有随机的不同效果，同时角色会背诵对应的台词
    ]]
})
EIDAddItem(ItemID.virtualShare,{
    Name="虚拟股票",
    Descriptions=[[{{Coin}} 拾取时，+15硬币
    #在进入下一层时，有40%的概率翻倍你的硬币数量，有50%的概率减少一半的硬币数量，有10%的概率失去所有硬币
    ]]
})


local language = "zh_cn"
local descriptions = EID.descriptions[language]
for id,item in pairs(ItemEID) do
    EID:addCollectible(id,item.Descriptions,item.Name,language)
    if (item.BookOfVirtues and descriptions.bookOfVirtuesWisps) then
        descriptions.bookOfVirtuesWisps[id] = item.BookOfVirtues
    end
end
