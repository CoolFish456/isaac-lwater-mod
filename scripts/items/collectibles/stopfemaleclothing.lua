local stopFemaleClothing = {}
stopFemaleClothing.name = "Stop Female Clothing"
stopFemaleClothing.ID = Isaac.GetItemIdByName("Stop Female Clothing")

function stopFemaleClothing:stopFemaleClothingGet ()
    -- 移除道具
    local player = Isaac.GetPlayer()
    -- local collectiblesCount = player:GetCollectibleCount()
    local collectiblesList = player:GetCollectiblesList()
    -- Isaac.ConsoleOutput(tostring(collectiblesList[CollectibleType.COLLECTIBLE_SAD_ONION]))
    for cType, num in pairs(collectiblesList) do
        if num > 0 then
            local itemConfig = Isaac.GetItemConfig():GetCollectible(cType)
            if itemConfig:HasTags(ItemConfig.TAG_MOM) then
                for i=1,num do
                    player:RemoveCollectible(cType)
                end
            end
        end
    end
    player.TryRemoveNullCostume(player,NullItemID.ID_MOM)
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE,stopFemaleClothing.stopFemaleClothingGet,stopFemaleClothing.ID)

function stopFemaleClothing:stopFemaleClothingNewRoom ()
    -- 进入新房间时，reroll含有妈妈标签的道具生成
    -- Test seed: W6QA REBX Greedier
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(stopFemaleClothing.ID) then
        return
    end
    stopFemaleClothing:stopFemaleClothingGet()
    local roomEntities = Isaac.GetRoomEntities()
    if next(roomEntities) == nil then return end
    for i, entity in ipairs(roomEntities) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local itemConfig = Isaac.GetItemConfig():GetCollectible(entity.SubType)
            if itemConfig:HasTags(ItemConfig.TAG_MOM) and not itemConfig:HasTags(ItemConfig.TAG_QUEST) then
                local newCollectibleId
                repeat
                    local lastItemPool = Game():GetItemPool():GetLastPool()
                    newCollectibleId = Game():GetItemPool():GetCollectible(lastItemPool, true, Game():GetSeeds():GetStartSeed())
                until not Isaac.GetItemConfig():GetCollectible(newCollectibleId):HasTags(ItemConfig.TAG_MOM)
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectibleId, true, true)
            end
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,stopFemaleClothing.stopFemaleClothingNewRoom)

---@param entity EntityPickup
function stopFemaleClothing:stopFemaleClothingGenItem (entity)
    -- 尝试生成含有妈妈标签的道具时，reroll生成
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(stopFemaleClothing.ID) then
        return
    end
    if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local itemConfig = Isaac.GetItemConfig():GetCollectible(entity.SubType)
        if itemConfig:HasTags(ItemConfig.TAG_MOM) and not itemConfig:HasTags(ItemConfig.TAG_QUEST) then
            local newCollectibleId
            repeat
                local lastItemPool = Game():GetItemPool():GetLastPool()
                newCollectibleId = Game():GetItemPool():GetCollectible(lastItemPool, true, Game():GetSeeds():GetStartSeed())
            until not Isaac.GetItemConfig():GetCollectible(newCollectibleId):HasTags(ItemConfig.TAG_MOM)
            entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectibleId, true, true)
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,stopFemaleClothing.stopFemaleClothingGenItem)
-- TODO: 增加其他有关联的道具（需要人工统计）

return stopFemaleClothing