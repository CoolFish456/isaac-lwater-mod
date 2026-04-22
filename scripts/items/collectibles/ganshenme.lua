local ganShenMe = {}
ganShenMe.name = "Gan Shen Me!"
ganShenMe.ID = Isaac.GetItemIdByName("Gan Shen Me!")
local RECOMMENDED_SHIFT_IDX = 35
GanShenMeGuppyFlag=false

---@param player EntityPlayer
function ganShenMe:ganShenMeUse (collectibleID, rngObj, player, useFlags, activeSlot, varData)
    -- local player=Isaac.GetPlayer()
    if not player:HasCollectible(ganShenMe.ID) then
        return
    end
    local sfx = SFXManager()
    sfx:Play(ModSound.SOUND_ORIN,1.5)
    player.AddNullCostume(player,NullItemID.ID_GUPPY)
    GanShenMeGuppyFlag=true
    player.AddCacheFlags(player,CacheFlag.CACHE_FLYING)
    player:AddBlueFlies(1,player.Position,player)
    player.EvaluateItems(player)
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

LWaterMod:AddCallback(ModCallbacks.MC_USE_ITEM,ganShenMe.ganShenMeUse,ganShenMe.ID)

function ganShenMe:ganShenMePostNewRoom()
    -- 已知问题：在没有猫套的情况下，如果在房间内使用本道具并丢弃后离开该房间，猫套的外观仍然存在的问题
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(ganShenMe.ID) then
        return
    end
    GanShenMeGuppyFlag=false
    player.TryRemoveNullCostume(player,NullItemID.ID_GUPPY)
    player.AddCacheFlags(player,CacheFlag.CACHE_FLYING)
    player.EvaluateItems(player)
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,ganShenMe.ganShenMePostNewRoom)

function ganShenMe:ganShenMeEvaluateCache(mod, flag)
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(ganShenMe.ID) then
        return
    end
    if GanShenMeGuppyFlag == true then
        if flag==CacheFlag.CACHE_FLYING then
            player.CanFly=true
        end
    elseif GanShenMeGuppyFlag == false then
        if flag==CacheFlag.CACHE_FLYING then
            player.CanFly=false
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,ganShenMe.ganShenMeEvaluateCache)

-- fake guppy transformation
function ganShenMe:AddGuppyEffect(entity)
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(ganShenMe.ID) then
        return
    end
    if GanShenMeGuppyFlag == true then
        if entity:IsEnemy() then
            local rng = RNG()
            rng:SetSeed(Random(), RECOMMENDED_SHIFT_IDX)
            local ganShenMeRNG = rng:RandomInt(100)
            if ganShenMeRNG >= 33 then
                player:AddBlueFlies(1,player.Position,player)
            end
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,ganShenMe.AddGuppyEffect)

return ganShenMe

