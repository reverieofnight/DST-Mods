-- modmain.lua
-- 添加或者清除雨疗效果
local function rainHeal(type, inst)
    if type then
        if inst.rainHealTask == nil then
            inst.rainHealTask = inst:DoPeriodicTask(5.0, function(inst)
                local israining = GLOBAL.TheWorld.state.israining
                -- 停止下雨，结束治疗
                if inst.healTimer ~= nil and not israining then
                    inst.healTimer:Cancel()
                    inst.healTimer = nil
                end
                -- 下雨，开始治疗
                if israining and inst.healTimer == nil then
                    inst.healTimer = inst:DoPeriodicTask(2.0, function(inst)
                        inst.components.health:DoDelta(4, false, "redamulet")
                    end)
                end
            end)
        end
    else
        if inst.healTimer ~= nil then
            inst.healTimer:Cancel()
            inst.healTimer = nil
        end
        if inst.rainHealTask ~= nil then
            inst.rainHealTask:Cancel()
            inst.rainHealTask = nil
        end
    end
end

-- 植物人修改
AddPrefabPostInit("wormwood", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    rainHeal(true, inst)
end)

-- 联动能力勋章内容,佩戴植物勋章也可享受雨疗效果
local function checkPlantCertificate(owner)
    if owner.prefab == 'wormwood' then
        return
    end
    if owner:HasTag("has_transplant_medal") then
        rainHeal(true, owner)
    end
    if not owner:HasTag("has_transplant_medal") then
        rainHeal(false, owner)
    end
end
local function printTable(t)
    for k, v in pairs(t) do
        print(k,'=', v)
    end
end
local function ListenMedalEvent(inst)
    inst:ListenForEvent("equipped", function(inst, data)
        inst:DoTaskInTime(1, checkPlantCertificate(data.owner))
    end)
    inst:ListenForEvent("unequipped", function(inst, data)
        inst:DoTaskInTime(1, checkPlantCertificate(data.owner))
    end)
    inst:ListenForEvent("itemget", function(inst, data)
        if data.item and data.item.prefab == 'transplant_certificate' and inst.parent ~= nil then
            inst:DoTaskInTime(1, checkPlantCertificate(inst.parent))
        end
    end)
    inst:ListenForEvent("itemlose", function(inst, data)
        if data.prev_item and data.prev_item.prefab == 'transplant_certificate' and inst.parent ~= nil then
            inst:DoTaskInTime(1, checkPlantCertificate(inst.parent))
        end
        if data.item and data.item.prefab == 'transplant_certificate' and inst.parent ~= nil then
            inst:DoTaskInTime(1, checkPlantCertificate(inst.parent))
        end
    end)
end


AddPrefabPostInit("transplant_certificate", function(inst)
    ListenMedalEvent(inst)
end)
AddPrefabPostInit("multivariate_certificate", function(inst)
    ListenMedalEvent(inst)
end)
AddPrefabPostInit("medium_multivariate_certificate", function(inst)
    ListenMedalEvent(inst)
end)
AddPrefabPostInit("large_multivariate_certificate", function(inst)
    ListenMedalEvent(inst)
end)