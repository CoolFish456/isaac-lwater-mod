local cols = LWaterMod.Collectibles
local ItemEID = {}
local function EIDAddItem(id, content)
    if id then
        ItemEID[id] = content
    end
end

EIDAddItem(cols.ganShenMe.ID,{
    Name="干什么!",
    Descriptions=[[在当前房间内，获得{{Collectible145}}嗝屁猫!的效果并生成一只蓝苍蝇
    #使用时，阿燐会哈气
    ]]
})
EIDAddItem(cols.classicTasteShavedIce.ID,{
    Name="老味刨冰",
    Descriptions=[[#{{Tears}} {{ArrowUp}}+0.5射速修正
    #{{Speed}} {{ArrowDown}}-0.3移速
    #有20%的概率触发冰冻泪弹，不受幸运影响
    ]]
})
EIDAddItem(cols.oneLWater.ID,{
    Name="1L水",
    Descriptions=[[{{SoulHeart}} +1魂心
    #{{Tears}} {{ArrowUp}}+0.2射速修正
    #发射泪弹有12%概率在泪弹飞行过程中留下绿色水迹
    #{{Luck}} 幸运15：75%概率
    ]]
})
EIDAddItem(cols.somebodysQuotation.ID,{
    Name="某人的语录",
    Descriptions=[[
    #有10%概率发射聊天框泪弹
    #{{Luck}} 幸运12：100%概率
    #每一个聊天框泪弹具有随机的不同效果，同时角色会背诵对应的台词
    ]]
})
EIDAddItem(cols.virtualShare.ID,{
    Name="虚拟股票",
    Descriptions=[[{{Coin}} 拾取时，+15硬币
    #在进入下一层时，有40%的概率翻倍你的硬币数量，有50%的概率减少一半的硬币数量，有10%的概率失去所有硬币
    ]]
})
EIDAddItem(cols.koishisHat.ID,{
    Name="恋恋的帽子",
    Descriptions=[[{{Battery}}充能时间2秒
    #使用时，丢出一个恋恋的帽子，对路径上的敌人造成每次3.5点的伤害
    #飞出一定距离后飞回玩家手中，回收过程中对路径上的敌人造成每次6.5点的伤害
    ]]
})
EIDAddItem(cols.stopFemaleClothing.ID,{
    Name="不准女装",
    Descriptions=[[拾取时，移除玩家身上所有含有{{Mom}}“妈妈”标签的道具
    #本局游戏内也无法遇见这些道具
    ]]
})
EIDAddItem(cols.lilHina.ID,{
    Name="雏人偶宝宝",
    Descriptions=[[获得“雏人偶宝宝”跟班
    #“雏人偶宝宝”跟班跟随角色，角色攻击时，每隔3秒进行自转，向周围随机喷洒大量泪弹，造成4.5点伤害
    #{{Luck}} {{ArrowDown}}持有时，-1幸运
    ]]
})
EIDAddItem(cols.snakebite.ID,{
    Name="蛇咬",
    Descriptions=[[使用后，对所有的敌怪赋予2秒{{Poison}}中毒效果
    #{{Poison}} 中毒效果：每次造成7点伤害
    #{{Warning}} 对头目无效
    ]]
})
EIDAddItem(cols.demonForm.ID,{
    Name="恶魔形态",
    Descriptions=[[{{Damage}} {{ArrowUp}}+2伤害修正
    #{{Damage}} 进入新的楼层时，{{ArrowUp}}+3伤害修正
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
