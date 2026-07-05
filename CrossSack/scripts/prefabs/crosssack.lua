local assets =
{
    Asset("ANIM", "anim/backpack.zip"),
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
    inst.AnimState:SetBank("backpack")
    inst.AnimState:SetBuild("backpack")
    inst.AnimState:PlayAnimation("anim")
end

local function onequip(inst, equiper)
    equiper.AnimState:OverrideSymbol("swap_body", "backpack", "swap_body")
    if inst.components.container ~= nil then
        inst.components.container:Open(equiper)
    end
end

local function onunequip(inst, equiper)
    if inst.components.container ~= nil then
        inst.components.container:Close(equiper)
    end
    equiper.AnimState:ClearOverrideSymbol("swap_body")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("backpack")
    inst.AnimState:SetBuild("backpack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
    inst:AddTag("crosssack")

    MakeInventoryFloatable(inst)

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem.cangoincontainer = true

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("crosssack")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab("crosssack", fn, assets)