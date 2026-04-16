function LWaterMod:classicTasteShavedIceEvaluateCache (mod, flag)
    -- TODO：改变属性
end

LWaterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,LWaterMod.classicTasteShavedIceEvaluateCache)

---@param tearEntity EntityTear
function LWaterMod:classicTasteShavedIceTearEffect(tearEntity)
    -- TODO：冰冻泪弹
end

LWaterMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT,LWaterMod.classicTasteShavedIceTearEffect)
