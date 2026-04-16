local RECOMMENDED_SHIFT_IDX = 35
GanShenMeGuppyFlag=false

function LWaterMod:ganShenMeUse ()
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(ItemID.ganShenMe) then
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

LWaterMod:AddCallback(ModCallbacks.MC_USE_ITEM,LWaterMod.ganShenMeUse,ItemID.ganShenMe)

function LWaterMod:ganShenMePostNewRoom()
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(ItemID.ganShenMe) then
        return
    end
    GanShenMeGuppyFlag=false
    player.TryRemoveNullCostume(player,NullItemID.ID_GUPPY)
    player.AddCacheFlags(player,CacheFlag.CACHE_FLYING)
    player.EvaluateItems(player)
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,LWaterMod.ganShenMePostNewRoom)

function LWaterMod:ganShenMeEvaluateCache(mod, flag)
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(ItemID.ganShenMe) then
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

LWaterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,LWaterMod.ganShenMeEvaluateCache)

-- fake guppy transformation
function LWaterMod:AddGuppyEffect(entity)
    local player=Isaac.GetPlayer()
    if not player:HasCollectible(ItemID.ganShenMe) then
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

LWaterMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,LWaterMod.AddGuppyEffect)

