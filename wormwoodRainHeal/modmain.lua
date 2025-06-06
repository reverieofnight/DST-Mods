-- modmain.lua
local function CheckForRain(inst)
    if not GLOBAL.TheWorld.state.israining and inst:HasTag("activerain") then
        inst.components.health:StartRegen(0, 0)
        inst:AddTag("notactiverain")
        inst:RemoveTag("activerain")
    end
    if GLOBAL.TheWorld.state.israining and inst:HasTag("notactiverain") then
        inst.components.health:StartRegen(2, 1)
        inst:AddTag("activerain")
        inst:RemoveTag("notactiverain")
    end
end
AddPrefabPostInit("wormwood", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    inst:AddTag("notactiverain")
    inst:DoPeriodicTask(5.0, function(inst)
        CheckForRain(inst)
    end)
end)
