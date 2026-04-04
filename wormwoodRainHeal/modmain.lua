-- modmain.lua
-- 配置常量
local CONFIG = {
    HEAL_INTERVAL = 1.0,         -- 治疗间隔(秒) 
    HEAL_AMOUNT = 1,             -- 单次治疗量（每秒1点）
    HEAL_SOURCE = "redamulet",   -- 治疗来源标识
    
    -- san值恢复配置（调整为每6秒恢复1点san值）
    SAN_RESTORE_INTERVAL = 6.0,  -- san值恢复间隔(秒)
    SAN_RESTORE_SOURCE = "rain_heal", -- san恢复来源标识
    
    -- 雨露值检测
    MOISTURE_THRESHOLD = 0.1,    -- 雨露值阈值(大于此值生效)
    
    -- 温度保护配置
    MOISTURE_TEMP_PENALTY = 0    -- 雨露值温度惩罚(设为0表示无惩罚)
}

-- 安全治疗函数（使用饥荒系统的regen机制）
local function safeHeal(inst, amount)
    if not inst or not inst.components or not inst.components.health then
        return false
    end
    -- 使用饥荒系统的AddRegenSource来添加回血效果
    inst.components.health:AddRegenSource("rain_heal", amount, CONFIG.HEAL_INTERVAL, "rain")
    return true
end

-- 停止治疗时移除回血源
local function stopHeal(inst)
    if not inst or not inst.components or not inst.components.health then
        return false
    end
    inst.components.health:RemoveRegenSource("rain_heal")
    return true
end

-- 安全san值恢复函数（使用externalmodifiers，不会影响装备dapperness）
local function safeSanRestore(inst, amount)
    if not inst or not inst.components or not inst.components.sanity then
        return false
    end
    -- 使用externalmodifiers来提供回san效果，不会影响装备的dapperness叠加
    -- 每分钟恢复10点san值 = 每6秒恢复1点san值
    inst.components.sanity.externalmodifiers:SetModifier("rain_heal", 10/60)
    return true
end

-- 停止san值恢复时移除externalmodifiers
local function stopSanRestore(inst)
    if not inst or not inst.components or not inst.components.sanity then
        return false
    end
    inst.components.sanity.externalmodifiers:RemoveModifier("rain_heal")
    return true
end



-- 检查是否满足保护条件（只需检查雨露值，调用者已确保是植物人或佩戴勋章）
local function checkProtectionConditions(inst)
    -- 检查是否有足够的雨露值
    if inst.components and inst.components.moisture then
        local moisture = inst.components.moisture:GetMoisture()
        return moisture > CONFIG.MOISTURE_THRESHOLD
    end
    
    return false
end

-- 设置全面保护（防止雨露值导致的降san和过冷）
local function setupProtection(inst)
    if not inst.components then
        return
    end
    
    -- 设置san值保护
    if inst.components.sanity then
        inst.components.sanity.no_moisture_penalty = true
    end
    
    -- 设置温度保护
    if inst.components.temperature then
        inst.components.temperature.maxmoisturepenalty = CONFIG.MOISTURE_TEMP_PENALTY
    end
end

-- 移除保护
local function removeProtection(inst)
    if not inst.components then
        return
    end
    
    -- 恢复默认的san值雨露值惩罚
    if inst.components.sanity then
        inst.components.sanity.no_moisture_penalty = false
    end
    
    -- 恢复默认的温度雨露值惩罚
    if inst.components.temperature then
        inst.components.temperature.maxmoisturepenalty = TUNING.MOISTURE_TEMP_PENALTY
    end
end

-- 更新雨露值相关效果（统一处理治疗和San值恢复）
local function updateRainMoistureEffects(inst)
    local shouldActivateMoistureEffects = checkProtectionConditions(inst)
    
    -- 统一处理治疗效果和San值恢复效果
    if shouldActivateMoistureEffects then
        safeHeal(inst, CONFIG.HEAL_AMOUNT)  -- 设置治疗效果
        safeSanRestore(inst)                -- 设置San值恢复效果
    else
        stopHeal(inst)      -- 停止治疗效果
        stopSanRestore(inst) -- 停止San值恢复效果
    end
end



-- 设置或清除雨露值保护系统
local function setupRainProtectionSystem(enable, inst)
    if not enable then
        stopHeal(inst)  -- 停止治疗效果
        stopSanRestore(inst)  -- 停止San值恢复效果
        
        -- 取消定时检查任务（如果存在）
        if inst.moistureCheckTask then
            inst.moistureCheckTask:Cancel()
            inst.moistureCheckTask = nil
        end
        
        return
    end
    
    -- 定时检查模式：每5秒检查一次雨露值状态
    
    -- 雨露值状态检查函数
    local function checkMoistureStatus(inst)
        -- 获取当前雨露值
        local newMoisture = inst.components.moisture:GetMoisture()
        
        -- 初始化旧雨露值
        if not inst.oldMoisture then
            inst.oldMoisture = 0
        end
        
        -- 计算相对于阈值的偏移量
        local oldOffset = inst.oldMoisture - CONFIG.MOISTURE_THRESHOLD
        local newOffset = newMoisture - CONFIG.MOISTURE_THRESHOLD
        
        -- 使用异或运算判断是否经过临界点
        -- (oldOffset > 0) ~= (newOffset > 0) 表示符号发生变化
        if (oldOffset > 0) ~= (newOffset > 0) then
            -- 雨露值经过临界点，需要更新状态
            updateRainMoistureEffects(inst)
        end
        
        -- 更新旧雨露值
        inst.oldMoisture = newMoisture
    end
    -- 初始检查
    updateRainMoistureEffects(inst)
    -- 启动5秒定时检查
    inst.moistureCheckTask = inst:DoPeriodicTask(5.0, checkMoistureStatus)
end

-- 植物人修改
AddPrefabPostInit("wormwood", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    setupRainProtectionSystem(true, inst)
    setupProtection(inst)
end)

-- 联动能力勋章内容,佩戴植物勋章也可享受雨疗效果
local function checkPlantMedalStatus(owner, eventType)
    if owner.prefab == 'wormwood' then return end
    local hasMedal = owner:HasTag("has_transplant_medal")
    setupRainProtectionSystem(hasMedal, owner)
    
    -- 设置或移除全面保护
    if hasMedal then
        setupProtection(owner)
    else
        removeProtection(owner)
    end
end

local function setupMedalEventListeners(inst)
    inst:ListenForEvent("equipped", function(inst, data)
        checkPlantMedalStatus(data.owner,'equipped')
    end)
    inst:ListenForEvent("unequipped", function(inst, data)
        checkPlantMedalStatus(data.owner,'unequipped')
    end)
    inst:ListenForEvent("itemget", function(inst, data)
        if data.item and data.item.prefab == 'transplant_certificate' and inst.parent ~= nil then
            checkPlantMedalStatus(inst.parent,'itemget')
        end
    end)
    inst:ListenForEvent("itemlose", function(inst, data)
        if data.prev_item and data.prev_item.prefab == 'transplant_certificate' and inst.parent ~= nil then
            checkPlantMedalStatus(inst.parent,'itemlose')
        end
    end)
end


-- 勋章配置表
local MEDAL_PREFABS = {
    "transplant_certificate",
    "multivariate_certificate", 
    "medium_multivariate_certificate",
    "large_multivariate_certificate"
}

-- 批量初始化勋章
for _, prefab in ipairs(MEDAL_PREFABS) do
    AddPrefabPostInit(prefab, function(inst)
        if not GLOBAL.TheWorld.ismastersim then return end
        setupMedalEventListeners(inst)
    end)
end