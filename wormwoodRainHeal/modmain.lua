-- modmain.lua
-- 配置常量
local CONFIG = {
    DETECTION_INTERVAL = 5.0,    -- 检测间隔(秒)
    HEAL_INTERVAL = 2.0,         -- 治疗间隔(秒) 
    HEAL_AMOUNT = 4,             -- 单次治疗量
    HEAL_SOURCE = "redamulet"    -- 治疗来源标识
}

-- 安全治疗函数
local function safeHeal(inst, amount)
    if not inst or not inst.components or not inst.components.health then
        return false
    end
    inst.components.health:DoDelta(amount, false, CONFIG.HEAL_SOURCE)
    return true
end

-- 添加或者清除雨疗效果
local function rainHeal(enable, inst)
    if not enable then
        -- 清除所有定时器
        if inst.healTimer then
            inst.healTimer:Cancel()
            inst.healTimer = nil
        end
        if inst.rainHealTask then
            inst.rainHealTask:Cancel()
            inst.rainHealTask = nil
        end
        return
    end
    
    -- 如果已经存在检测任务，则不再创建
    if inst.rainHealTask then return end
    
    inst.rainHealTask = inst:DoPeriodicTask(CONFIG.DETECTION_INTERVAL, function(inst)
        local israining = GLOBAL.TheWorld.state.israining
        
        -- 统一处理治疗定时器
        if israining then
            if not inst.healTimer then
                inst.healTimer = inst:DoPeriodicTask(CONFIG.HEAL_INTERVAL, function(inst)
                    safeHeal(inst, CONFIG.HEAL_AMOUNT)
                end)
            end
        else
            if inst.healTimer then
                inst.healTimer:Cancel()
                inst.healTimer = nil
            end
        end
    end)
end

-- 植物人修改
AddPrefabPostInit("wormwood", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    rainHeal(true, inst)
end)

-- 联动能力勋章内容,佩戴植物勋章也可享受雨疗效果
local function checkPlantCertificate(owner, eventType)
    if owner.prefab == 'wormwood' then return end
    local hasMedal = owner:HasTag("has_transplant_medal")
    rainHeal(hasMedal, owner)
end

local function ListenMedalEvent(inst)
    inst:ListenForEvent("equipped", function(inst, data)
        checkPlantCertificate(data.owner,'equipped')
    end)
    inst:ListenForEvent("unequipped", function(inst, data)
        checkPlantCertificate(data.owner,'unequipped')
    end)
    inst:ListenForEvent("itemget", function(inst, data)
        if data.item and data.item.prefab == 'transplant_certificate' and inst.parent ~= nil then
            checkPlantCertificate(inst.parent,'itemget')
        end
    end)
    inst:ListenForEvent("itemlose", function(inst, data)
        if data.prev_item and data.prev_item.prefab == 'transplant_certificate' and inst.parent ~= nil then
            checkPlantCertificate(inst.parent,'itemlose')
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
        ListenMedalEvent(inst)
    end)
end