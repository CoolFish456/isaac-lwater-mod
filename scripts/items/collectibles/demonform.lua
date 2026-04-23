local demonForm = {}
demonForm.name = "Demon Form" --道具名称
demonForm.ID = Isaac.GetItemIdByName("Demon Form") --道具ID
local json = require("json")
-- 贴图没画，，，
-- 已知问题：大退后伤害加成丢失的问题

local dataHolder = require("scripts.lib.dataholder")

function demonForm:demonFormEvaluateCache (mod, flag)
    local player=Isaac.GetPlayer()
    -- local data = player:GetData()
    local data = dataHolder:GetEntityData(player)
    LWaterMod.Config.PlayerInfo = data
    if data.addition == nil then
        data.addition = 2
    end
    if player:HasCollectible(demonForm.ID) then
        local multiplier = player:GetCollectibleNum(demonForm.ID)
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + data.addition * multiplier
            -- Isaac.ConsoleOutput(tostring(player.Damage).."\n")
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,demonForm.demonFormEvaluateCache)

function demonForm:demonFormNewLevel ()
    local player=Isaac.GetPlayer()
    -- local data = player:GetData()
    local data = dataHolder:GetEntityData(player)
    local sfx = SFXManager()
    if player:HasCollectible(demonForm.ID) then
        data.addition = data.addition + 3
        sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL,demonForm.demonFormNewLevel)

-- 手动销毁使用实体哈希表创建的数据
---@param entity Entity
function demonForm:demonFormClearData(entity)
    local ptrHash = GetPtrHash(entity)
    dataHolder.Data[ptrHash] = nil
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_GAME_END,demonForm.demonFormClearData)

-- 进入游戏时，手动加载数据
function demonForm:demonFormLoadData(continue)
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(demonForm.ID) then return end
    if not LWaterMod:HasData() then --若没有数据，则创建新的
        LWaterMod:savesetting()
        return
    end
    local dataSaveState = json.decode(LWaterMod:LoadData())
    local ptrHash = GetPtrHash(player)
    dataHolder.Data[ptrHash] = dataSaveState.PlayerInfo
    if not continue then
        dataHolder.Data[ptrHash] = nil
	end
    -- Isaac.ConsoleOutput(tostring(dataSaveState.PlayerInfo.addition).."\n")
end

LWaterMod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.EARLY, demonForm.demonFormLoadData)

return demonForm