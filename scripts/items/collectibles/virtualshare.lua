local virtualShare = {}
virtualShare.name = "Virtual Share"
virtualShare.ID = Isaac.GetItemIdByName("Virtual Share")

function virtualShare:virtualShareGet ()
    local player=Isaac.GetPlayer()
    player:AddCoins(15)
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE,virtualShare.virtualShareGet,virtualShare.ID)

function virtualShare:virtualShareChangeCoin ()
    local player=Isaac.GetPlayer()
    local RECOMMENDED_SHIFT_IDX = 35
    if player:HasCollectible(virtualShare.ID) then
        local sfx = SFXManager()
        local coinNum = player:GetNumCoins()
        local rng = RNG()
        rng:SetSeed(Random(), RECOMMENDED_SHIFT_IDX)
        local randomResult = rng:RandomInt(10)
        if randomResult < 4 then
            player:AddCoins(coinNum)
            sfx:Play(SoundEffect.SOUND_THUMBSUP)
            player:PlayExtraAnimation("Happy")
        elseif randomResult < 9 then
            player:AddCoins(-math.floor(coinNum/2))
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
            player:PlayExtraAnimation("Sad")
        else
            player:AddCoins(-coinNum)
            sfx:Play(SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED)
            player:PlayExtraAnimation("Sad")
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL,virtualShare.virtualShareChangeCoin)

return virtualShare