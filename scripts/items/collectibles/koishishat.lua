local koishisHat = {}
koishisHat.name = "Koishi's Hat"
koishisHat.ID = Isaac.GetItemIdByName("Koishi's Hat")

KoishisHatLiftFlag = false

---@param player EntityPlayer
function koishisHat:koishisHatUse(collectibleID, rngObj, player, useFlags, activeSlot, varData)
    -- 使用后举起
    if not player:HasCollectible(koishisHat.ID) then
        return
    end
    local data = player:GetData()
    KoishisHatLiftFlag = data.KoishisHatLiftFlag or false
    if not KoishisHatLiftFlag then
        player:AnimateCollectible(koishisHat.ID ,"LiftItem","PlayerPickup")
        KoishisHatLiftFlag = true
    else
        player:AnimateCollectible(koishisHat.ID ,"HideItem","PlayerPickup")
        KoishisHatLiftFlag = false
    end
    data.KoishisHatLiftFlag = KoishisHatLiftFlag
    return {
        Discharge = false,
        Remove = false,
        ShowAnim = false
    }
end

LWaterMod:AddCallback(ModCallbacks.MC_USE_ITEM,koishisHat.koishisHatUse,koishisHat.ID)

---@param player EntityPlayer
function koishisHat:koishisHatThrow(player)
    -- 举起后，检测按键并丢出帽子射弹
    if not player:HasCollectible(koishisHat.ID) then
        return
    end
    local data = player:GetData()
    KoishisHatLiftFlag = data.KoishisHatLiftFlag or false
    if KoishisHatLiftFlag then
        if (
            (Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex)) or
            (Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex)) or
            (Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex)) or
            (Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex))
        )then
            -- 丢出帽子射弹
            -- TODO：道具兼容
            player:AnimateCollectible(koishisHat.ID ,"HideItem","PlayerPickup")
            -- Isaac.ConsoleOutput("Throw\n")
            player:DischargeActiveItem()
            KoishisHatLiftFlag = false
            local direction = player:GetFireDirection()
            local directionVector = LWaterMod:GetFireDirectionVector(direction)
            -- Isaac.ConsoleOutput("Direction: "..direction.."\n")
            Isaac.Spawn(
                Isaac.GetEntityTypeByName("Koishi's Hat Projectile"),
                Isaac.GetEntityVariantByName("Koishi's Hat Projectile"),
                Isaac.GetEntitySubTypeByName("Koishi's Hat Projectile"),
                player.Position,
                directionVector,
                player
            )
        end
    end
    data.KoishisHatLiftFlag = KoishisHatLiftFlag
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,koishisHat.koishisHatThrow)

-- 定义帽子射弹行为：直线类回旋镖射弹，根据玩家的发射方向发射，直线飞出一段距离（跟随射程）/碰到墙壁后返回玩家，对路径上的敌人按帧造成伤害

---@param direction Direction
function LWaterMod:GetFireDirectionVector(direction)
    local vector_direction
    local base_speed = 18
    if direction == Direction.UP then
        vector_direction = Vector(0,-base_speed)
    elseif direction == Direction.DOWN then
        vector_direction = Vector(0,base_speed)
    elseif direction == Direction.LEFT then
        vector_direction = Vector(-base_speed,0)
    elseif direction == Direction.RIGHT then
        vector_direction = Vector(base_speed,0)
    else -- Default position
        vector_direction = Vector(0,base_speed)
    end
    return vector_direction
end

---@param effect EntityEffect
function koishisHat:ProjectileInit(effect)
    local data = effect:GetData()
    local spawner = effect.SpawnerEntity
    -- Isaac.ConsoleOutput("Projectile Init\n")
    if spawner and spawner:ToPlayer() then
        data.Owner = spawner:ToPlayer()
        -- 根据玩家射击方向设置初始速度
        local direction = data.Owner:GetFireDirection()
        local directionVector = LWaterMod:GetFireDirectionVector(direction)
        effect.Velocity = directionVector
        data.Velocity = directionVector
    end
    -- 初始参数
    data.Accel = -0.5
    data.MaxDistance = 233
    data.Travelled = 0
    data.State = "forward"
    data.ReturnSpeed = 25
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, koishisHat.ProjectileInit, Isaac.GetEntityVariantByName("Koishi's Hat Projectile"))
---@param effect EntityEffect
function koishisHat:ProjectileUpdate(effect)
    local data = effect:GetData()
    if not data.Owner then return end
    -- Isaac.ConsoleOutput("Projectile Update\n")
    -- Isaac.ConsoleOutput(tostring(effect.Velocity).." "..tostring(data.State).."\n")
    if data.State == "forward" then
        -- 匀减速：速度大小逐渐减小
        local speed = data.Velocity:Length()
        -- Isaac.ConsoleOutput("Speed Before:"..tostring(speed).."\n")
        speed = speed + data.Accel  -- data.Accel 是负数
        if speed < 0 then speed = 0 end
        data.Velocity = data.Velocity:Resized(speed)
        effect.Velocity = data.Velocity   -- 每帧同步给实体
        -- Isaac.ConsoleOutput("Speed:"..tostring(speed).." Velocity:"..tostring(effect.Velocity).." Travelled:"..tostring(data.Travelled).." \n")
        effect.Position = effect.Position + effect.Velocity
        data.Travelled = data.Travelled + effect.Velocity:Length()

        -- 达到最大距离或速度耗尽时切换为返回
        if data.Travelled >= data.MaxDistance or speed <= 0.1 then
            data.State = "return"
        end
        if effect:CollidesWithGrid() then
            -- 撞墙后立即返回
            data.State = "return"
        end

    elseif data.State == "return" then
        -- 返回玩家
        local dir = (data.Owner.Position - effect.Position):Normalized()
        effect.Velocity = dir * data.ReturnSpeed
        effect.Position = effect.Position + effect.Velocity
        -- Isaac.ConsoleOutput(tostring(effect.Velocity).." \n")
        if effect.Position:Distance(data.Owner.Position) < 20 then
            effect:Remove()
        end
    end
    -- 持续伤害敌人
    data.HitTimer = (data.HitTimer or 0) + 1
    if data.HitTimer >= 2 then
        data.HitTimer = 0
        local enemies = Isaac.FindInRadius(effect.Position, effect.Size or 20, EntityPartition.ENEMY)
        for _, enemy in ipairs(enemies) do
            enemy:TakeDamage(5.5, DamageFlag.DAMAGE_CLONES, EntityRef(effect), 0)
            -- TODO：少量击退
            enemy.Velocity = enemy.Velocity + (enemy.Position - effect.Position):Normalized() * 2
        end
    end
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, koishisHat.ProjectileUpdate, Isaac.GetEntityVariantByName("Koishi's Hat Projectile"))



return koishisHat