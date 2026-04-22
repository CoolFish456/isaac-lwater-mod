local demonForm = {}
demonForm.name = "Demon Form" --道具名称
demonForm.ID = Isaac.GetItemIdByName("Demon Form") --道具ID

function demonForm:demonFormEvaluateCache (mod, flag)
    local player=Isaac.GetPlayer()
    local data = player:GetData()
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
    local data = player:GetData()
    local sfx = SFXManager()
    if player:HasCollectible(demonForm.ID) then
        data.addition = data.addition + 2
        sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL,demonForm.demonFormNewLevel)

return demonForm