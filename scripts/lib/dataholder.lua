-- 使用哈希指针持久化存储数据
-- 获取某个实体哈希指针：GetPtrHash(entity)
-- 实体被创建时，和唯一一个哈希指针对应，可以用于实体的追踪和数据处理等操作，防止UB
-- !!!需要手动销毁!!!
-- 使用时必须require本模块确保持久化
local dataHolder = {}
-- 存储数据的位置：dataHolder.Data[ptrHash]
-- Store the data within its own table in the data holder for easy access
dataHolder.Data = {}

--[[
    调用方式：
    local dataHolder = require("scripts.lib.dataholder")
    dataHolder:GetEntityData(entity)
--]]
--- @param entity Entity
function dataHolder:GetEntityData(entity)
    -- Obtain the entity's pointer hash to easily reference it in a table.
    local ptrHash = GetPtrHash(entity)
    -- Instantiate the data if it doesn't exist
    if not dataHolder.Data[ptrHash] then
        dataHolder.Data[ptrHash] = {}
        local entityData = dataHolder.Data[ptrHash]
        --[[
            Provide a default value of the entity's pointer to the data.
            The pointer helps us later be able to check if the entity exists.

            For looping purposes, it may be inconvenient to store it here.
            If this is the case, making another table to store the pointer
            may be preferable.
        --]]
        entityData.Pointer = ptrHash
        -- You may also add additional initialization steps here
        -- This may include defining default variables for your data
    end
    return dataHolder.Data[ptrHash]
end

return dataHolder

-- 建议：如果有复杂的数据结构/跨房间持久化存储需求，建议使用Entity Data Holder存储
-- GetData()的坏处：强易失性、数据共享（相当于全局变量）、有一点额外开销（C++端）、无法控制销毁时间（自动在实体销毁时和退出游戏时销毁）