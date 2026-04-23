local SaveState = {} --中间表
local json = require("json")

LWaterMod.Config = { --为需要存储的数据设置
    PlayerInfo = {}
}

function LWaterMod:loadsetting(continue) --进入游戏时加载数据
    if not LWaterMod:HasData() then --若没有数据，则创建新的
        LWaterMod:savesetting()
        return
    end
    SaveState = json.decode(LWaterMod:LoadData()) --将数据文档中的字符串解码为表
    for i, v in pairs(SaveState) do
        LWaterMod.Config[tostring(i)] = SaveState[i]
    end
    if not continue then --如果是新一轮游戏的话，清除上一局的角色信息
        for i, v in pairs(LWaterMod.Config) do
            LWaterMod.Config[i] = nil
        end
	end
end

function LWaterMod:savesetting() --退出游戏时保存数据
    SaveState = {}
    for i, v in pairs(LWaterMod.Config) do
        SaveState[tostring(i)] = LWaterMod.Config[i]
    end
    LWaterMod:SaveData(json.encode(SaveState)) --将表编码为字符串，储存到（游戏根目录）/data/（mod名文件夹）/（存档栏位名）.dat
end

--和AddCallback不同的是，AddPriorityCallback可用于更改返回的优先级
--在运行同一种返回时，游戏会优先执行优先级更高的返回，而同一优先级的同种返回的触发顺序和普通的代码一样，都是按至上而下顺序逐个触发
LWaterMod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.EARLY, LWaterMod.loadsetting) --加载数据要早一些
LWaterMod:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, CallbackPriority.LATE, LWaterMod.savesetting) --保存数据要晚一些