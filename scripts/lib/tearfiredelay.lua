---@param addition number
---@param multiplier number
function LWaterMod:changePlayerFireRate(addition,multiplier)
    -- 修正值的加成，射速和射击延迟的换算见wiki
    -- https://isaac.huijiwiki.com/wiki/%E5%B0%84%E9%80%9F
    local player=Isaac.GetPlayer()
    player.MaxFireDelay = 30 / (30 / (player.MaxFireDelay + 1) + addition * multiplier) - 1
end

---@param addition number
---@param multiplier number
function LWaterMod:changePlayerTearDelay(addition,multiplier)
    -- TODO：非修正值的加成，射速和射击延迟的换算见wiki
    -- https://isaac.huijiwiki.com/wiki/%E5%B0%84%E9%80%9F
    -- local player=Isaac.GetPlayer()
    -- player.MaxFireDelay = player.MaxFireDelay - ((multiplier * (player.MaxFireDelay + 1)^2) / ( (1 / addition) * 30 + multiplier * (player.MaxFireDelay + 1) ))
    return
end