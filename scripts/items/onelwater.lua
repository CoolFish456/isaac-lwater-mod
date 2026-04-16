function LWaterMod:oneLWaterGet ()
    local player=Isaac.GetPlayer()
    player.AddSoulHearts(player,2)
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE,LWaterMod.oneLWaterGet,ItemID.oneLWater)

function LWaterMod:oneLWaterEvaluateCache (mod, flag)
    local player=Isaac.GetPlayer()
    local multiplier = player:GetCollectibleNum(ItemID.oneLWater)
    if player:HasCollectible(ItemID.oneLWater) then
        if flag == CacheFlag.CACHE_FIREDELAY then
            local addition = 0.35
            -- 修正，射速和射击延迟的换算见wiki
            LWaterMod:changePlayerFireRate(addition,multiplier)
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,LWaterMod.oneLWaterEvaluateCache)

-- ---@param direction Direction
-- function LWaterMod:GetFireDirectionVector(direction)
--     local vector_direction
--     local base_speed = 20
--     if direction == Direction.UP then
--         vector_direction = Vector(0,-base_speed)
--     elseif direction == Direction.DOWN then
--         vector_direction = Vector(0,base_speed)
--     elseif direction == Direction.LEFT then
--         vector_direction = Vector(-base_speed,0)
--     elseif direction == Direction.RIGHT then
--         vector_direction = Vector(base_speed,0)
--     end
--     return vector_direction
-- end

local RECOMMENDED_SHIFT_IDX = 35

---@param tearEntity EntityTear
function LWaterMod:oneLWaterTearCreep(tearEntity)
    -- 在泪弹下生成水迹
    local data = tearEntity:GetData()
    if not data.oneLWaterTearShouldCreep then
        return
    end
    local player=Isaac.GetPlayer()
    local rng = RNG()
    rng:SetSeed(Random(), RECOMMENDED_SHIFT_IDX)
    if player:HasCollectible(ItemID.oneLWater) then
        local tearCreepRNG = rng:RandomInt(6)
        if tearCreepRNG >= 3 then
            local tearCreepTrail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, tearEntity.Position, Vector.Zero, player)
            tearCreepTrail:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end
end

---@param tearEntity EntityTear
function LWaterMod:oneLWaterTearCreepGen(tearEntity)
    -- 在泪弹生成时，决定是否生成水迹（1/4）
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(ItemID.oneLWater) then
        return
    end
    -- 计算 Luck → 概率（线性插值）
    local luck = player.Luck
    local clampedLuck = math.max(0, math.min(luck, 15))  -- 限制在 0~15
    local probability = 0.20 + (0.75 - 0.20) * (clampedLuck / 10)  -- 20% → 75%
    -- 使用 RNG() 生成随机数
    local rng = RNG()
    rng:SetSeed(Random(), RECOMMENDED_SHIFT_IDX)
    local roll = rng:RandomInt(100) / 100.0  -- 0~0.99
    -- 判定是否生成水迹
    local shouldCreep = (roll < probability)
    -- 结果写入tearEntity的GetData()表中，供MC_POST_TEAR_UPDATE时读取
    local data = tearEntity:GetData()
    data.oneLWaterTearShouldCreep = shouldCreep
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT,LWaterMod.oneLWaterTearCreepGen)
LWaterMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,LWaterMod.oneLWaterTearCreep)

