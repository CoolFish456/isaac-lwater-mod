local hugeCapsule = {}
hugeCapsule.name = "Huge Capsule"
hugeCapsule.ID = Isaac.GetItemIdByName("Huge Capsule")

local RECOMMENDED_SHIFT_IDX = 35

---@param player EntityPlayer
function hugeCapsule:hugeCapsuleUse (collectibleID, rngObj, player, useFlags, activeSlot, varData)
    -- local player=Isaac.GetPlayer()
    if not player:HasCollectible(hugeCapsule.ID) then
        return
    end
    -- 随机选择1份已有的道具，给予角色40份该道具的复制品
    local collectiblesList = player:GetCollectiblesList()
    if collectiblesList == nil then return end
    -- 先生成一个集约的列表，去掉数量为0的道具
    local compactCollectiblesList = {}
    for cType, num in pairs(collectiblesList) do
        if num > 0 then
            compactCollectiblesList[cType] = num
        end
    end
    -- 从集约的列表选取一个道具并记录，实际上就是随机选择表的索引（道具ID）
    local rng = RNG()
    rng:SetSeed(Random(), RECOMMENDED_SHIFT_IDX)
    local cTypeList = {}
    for cType, _ in pairs(compactCollectiblesList) do
        Isaac.ConsoleOutput(tostring(cType).."\n")
        table.insert(cTypeList, cType)
    end
    Isaac.ConsoleOutput(tostring(cTypeList).."\n")
    local randomIndex = rng:RandomInt(#cTypeList) + 1
    local selectedCType = cTypeList[randomIndex]
    rng:Next()
    if Isaac.GetItemConfig():GetCollectible(selectedCType).Type == ItemType.ITEM_ACTIVE then
        if #cTypeList <= 1 then
            -- 如果角色只有一个道具且是主动道具，则不执行任何操作
            return
        else
            -- 如果随机到主动道具则重新随机
            while Isaac.GetItemConfig():GetCollectible(selectedCType).Type == ItemType.ITEM_ACTIVE do
                randomIndex = rng:RandomInt(#cTypeList) + 1
                selectedCType = cTypeList[randomIndex]
                rng:Next()
            end
        end
    end
    -- 复制32份该道具并获得之（并且具有拾取时的效果）
    for _ = 1,32 do
        player:AddCollectible(selectedCType, 0, true)
    end
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

LWaterMod:AddCallback(ModCallbacks.MC_USE_ITEM,hugeCapsule.hugeCapsuleUse,hugeCapsule.ID)

return hugeCapsule