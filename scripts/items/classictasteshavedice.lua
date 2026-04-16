function LWaterMod:classicTasteShavedIceEvaluateCache (mod, flag)
    -- 改变属性：+0.5射速修正，-0.3移速
    local player=Isaac.GetPlayer()
    local multiplier = player:GetCollectibleNum(ItemID.classicTasteShavedIce)
    if player:HasCollectible(ItemID.classicTasteShavedIce) then
        if flag == CacheFlag.CACHE_FIREDELAY then
            local addition = 0.5
            LWaterMod:changePlayerFireRate(addition,multiplier)
        end
        if flag == CacheFlag.CACHE_SPEED then
            local addition = -0.3
            player.MoveSpeed = player.MoveSpeed + addition * multiplier
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,LWaterMod.classicTasteShavedIceEvaluateCache)

local RECOMMENDED_SHIFT_IDX = 35

---@param tearEntity EntityTear
function LWaterMod:classicTasteShavedIceTearEffect(tearEntity)
    -- TODO：20%的概率触发冰冻泪弹
    local player = Isaac.GetPlayer()
    local rng = RNG()
    rng:SetSeed(Random(), RECOMMENDED_SHIFT_IDX)
    if not player:HasCollectible(ItemID.classicTasteShavedIce) then
        return
    end
    local iceTearEffect= rng:RandomInt(4)
    if iceTearEffect == 0 then
        tearEntity:AddTearFlags(TearFlags.TEAR_ICE)
        tearEntity:ChangeVariant(TearVariant.ICE)
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,LWaterMod.classicTasteShavedIceTearEffect)
