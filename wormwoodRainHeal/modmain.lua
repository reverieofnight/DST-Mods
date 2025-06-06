-- modmain.lua

AddPrefabPostInit("wormwood", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    local healTimer = nil
    inst:DoPeriodicTask(5.0, function(inst)
        local israining = GLOBAL.TheWorld.state.israining
        -- 停止下雨，结束治疗
        if healTimer ~= nil and not israining then
            healTimer:Cancel()
            healTimer = nil
        end
        -- 下雨，开始治疗
        if israining and healTimer == nil then
            healTimer = inst:DoPeriodicTask(2.0,function(inst)
                inst.components.health:DoDelta(4,false,"redamulet")
            end)
        end

    end)
end)
