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
    if TUNING.ROOMCAR_BIGBAG_KEEPFRESH then
        for i = 1, inst.components.container:GetNumSlots() do
            local item = inst.components.container.slots[i]
            if item ~= nil then
                if item:HasTag("spoiled") then
                    item.components.perishable:SetPercent(1)
                elseif item:HasTag("stale") then
                    item.components.perishable:SetPercent(1)
                elseif item:HasTag("fresh") then
                    item.components.perishable:SetPercent(1)
                end
                if item.components.finiteuses then
                    item.components.finiteuses:SetPercent(1)
                end
            end
        end
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

    inst.AnimState:SetBank("elaina_bag")
    inst.AnimState:SetBuild("elaina_bag")
    inst.AnimState:PlayAnimation("idle")

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
    inst.components.equippable.walkspeedmult = TUNING.ROOMCAR_BIGBAG_WALKSPEED

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
    local _CanTakeItemInSlot = inst.components.container.CanTakeItemInSlot
    inst.components.container.CanTakeItemInSlot = function(self, item, slot)
        if item:HasTag("crosssack") then
            return TUNING.ROOMCAR_BIGBAG_BAGINBAG
        end
        return _CanTakeItemInSlot(self, item, slot)
    end

    if TUNING.ROOMCAR_BIGBAG_KEEPFRESH then
        if inst.components.preserver == nil then
            inst:AddComponent("preserver")
        end
        inst.components.preserver:SetPerishRateMultiplier(function(inst, item)
            return (item ~= nil) and 0 or nil
        end)
    end

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab("crosssack", fn, assets)