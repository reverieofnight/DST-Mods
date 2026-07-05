local assets =
{
    Asset("ANIM", "anim/elaina_bag.zip"),
    Asset("IMAGE", "images/inventoryimages/crosssack.tex"),
    Asset("ATLAS", "images/inventoryimages/crosssack.xml"),
    Asset("IMAGE", "images/inventoryimages/crosssack_open.tex"),
    Asset("ATLAS", "images/inventoryimages/crosssack_open.xml"),
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    if inst.components.inventoryitem then
        inst.components.inventoryitem.imagename = "crosssack_open"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/crosssack_open.xml"
    end
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    if inst.components.inventoryitem then
        inst.components.inventoryitem.imagename = "crosssack"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/crosssack.xml"
    end
end

local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
    inst.AnimState:SetBank("elaina_bag")
    inst.AnimState:SetBuild("elaina_bag")
    inst.AnimState:PlayAnimation("idle")
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "elaina_bag", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "elaina_bag", "swap_body")
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
    if inst.components.container and inst.components.container:IsOpen() then
        inst.components.inventoryitem.imagename = "crosssack_open"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/crosssack_open.xml"
    else
        inst.components.inventoryitem.imagename = "crosssack"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/crosssack.xml"
    end
end

local function onunequip(inst, owner)
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("crosssack.tex")

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("elaina_bag")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("backpack")
    inst:AddTag("crosssack")

    MakeInventoryFloatable(inst, "med", 0.1, 0.65)

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("crosssack")
        end
        return inst
    end

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/crosssack.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem.cangoincontainer = true
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("crosssack")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab("crosssack", fn, assets)