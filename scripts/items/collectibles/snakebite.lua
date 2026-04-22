local snakebite = {}
snakebite.name = "Snakebite"
snakebite.ID = Isaac.GetItemIdByName("Snakebite")

---@param player EntityPlayer
function snakebite:snakebiteUse(collectibleID, rngObj, player, useFlags, activeSlot, varData)
    -- 使用后，对所有的敌怪赋予2秒中毒
        -- local player=Isaac.GetPlayer()
        if not player:HasCollectible(snakebite.ID) then
            return
        end
        local entities=Isaac.GetRoomEntities()
        -- Isaac.ConsoleOutput("1\n")
        for i, entity in ipairs(entities) do
            if entity:IsVulnerableEnemy() and entity:IsActiveEnemy(false) and not entity:IsBoss() then
                entity:AddPoison(EntityRef(player), 60, 7.0)
            end
        end
        return {
            Discharge = true,
            Remove = false,
            ShowAnim = true
        }
end

LWaterMod:AddCallback(ModCallbacks.MC_USE_ITEM,snakebite.snakebiteUse,snakebite.ID)

return snakebite