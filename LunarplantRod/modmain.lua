------------------------------------------------------------------------------------------------
-- 避茄针 modmain.lua
------------------------------------------------------------------------------------------------
-- 核心原理：
-- 月灵（入侵型虚影 lunarthrall_plant_gestalt）会挑选植物进行寄生，使其变成致命亮茄
-- （lunarthrall_plant）。原版的寄生目标选择逻辑位于 TheWorld 的
-- lunarthrall_plantspawner 组件中：它不会选择距离"已存在的亮茄"
-- （带 lunarthrall_plant 标签的实体）一定范围以内的植物作为寄生目标
-- （EXISTING_PLANT_SPACE = 30，见 lunarthrall_plantspawner.lua）。
--
-- 因此本 mod 给避雷针和冰眼结晶器添加 "lunarthrall_plant" 标签，
-- 让月灵误认为它们是已经寄生的亮茄，从而不会在其周围寄生，达到"避茄"的效果。
--
-- 屏蔽范围按结构自身范围对齐（原版统一为 30）：
--   避雷针     ：40 单位
--   冰眼结晶器 ：35 单位
--   真亮茄     ：30 单位（保持原版）
-- 实现方式：在结构上记录专属半径 bqzhen_blockradius，并替换
-- lunarthrall_plantspawner 组件的寄生判定方法，改为按每个"屏蔽实体"
-- （结构或真亮茄）各自的专属半径做逐实体距离判断。
------------------------------------------------------------------------------------------------

local GLOBAL = GLOBAL or _G

-- TheWorld 全局变量在 PrefabPostInit 阶段（世界加载/生成 prefab 时）可能尚未创建，
-- 访问其字段前必须判空。
local function IsMasterSim()
    local world = GLOBAL.TheWorld
    return world ~= nil and world.ismastersim
end

-- 需要被"伪装"成亮茄的结构及其专属屏蔽半径
local MASK_PREFABS = {
    { name = "lightning_rod",               radius = 40 },  -- 避雷针
    { name = "deerclopseyeball_sentryward", radius = 35 },  -- 冰眼结晶器
}

for i, data in ipairs(MASK_PREFABS) do
    AddPrefabPostInit(data.name, function(inst)
        if IsMasterSim() then
            inst:AddTag("lunarthrall_plant")
            inst.bqzhen_blockradius = data.radius
        end
    end)
end

local TUNING      = GLOBAL.TUNING
local Vector3     = GLOBAL.Vector3
local TWOPI       = GLOBAL.TWOPI
local FindEntity  = GLOBAL.FindEntity
local SpawnPrefab = GLOBAL.SpawnPrefab
local TheSim      = GLOBAL.TheSim

-- 真亮茄的默认屏蔽半径（对应原版 EXISTING_PLANT_SPACE）
local DEFAULT_BLOCK_RADIUS = 30
-- 所有屏蔽实体中的最大半径，用作 FindEntities 的搜索半径
local MAX_BLOCK_RADIUS     = 40

-- 判断目标（植物）是否位于任意"屏蔽实体"（避雷针/结晶器/真亮茄）的专属半径内。
-- 真亮茄没有 bqzhen_blockradius 字段，回退到原版 30。
local function IsBlockedByShielder(target)
    if target == nil or not target:IsValid() then
        return false
    end
    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, MAX_BLOCK_RADIUS, { "lunarthrall_plant" })
    for i, ent in ipairs(ents) do
        local radius = ent.bqzhen_blockradius or DEFAULT_BLOCK_RADIUS
        if target:GetDistanceSqToInst(ent) < radius * radius then
            return true
        end
    end
    return false
end

------------------------------------------------------------------------------------------------
-- 按结构对齐：替换 lunarthrall_plantspawner 的寄生判定方法。
-- 该组件全游戏唯一（挂在 TheWorld 上）。SpawnThralls 是局部函数（内部写死 30），
-- 选好目标后通过类方法 SpawnGestalt / InvadeTarget 放行寄生，这里在放行前按专属半径
-- 做最后拦截，覆盖 30 与结构半径之间的"环带"；同时让 FindHerd 的 herd 统计
-- 也使用专属半径判定，保证选择逻辑与最终效果一致。
------------------------------------------------------------------------------------------------
AddComponentPostInit("lunarthrall_plantspawner", function(self)
    -- 兜底拦截：结构/亮茄屏蔽范围内的植物绝不寄生
    local origSpawnGestalt = self.SpawnGestalt
    function self:SpawnGestalt(target, rift)
        if IsBlockedByShielder(target) then
            return
        end
        return origSpawnGestalt(self, target, rift)
    end

    local origInvadeTarget = self.InvadeTarget
    function self:InvadeTarget(target)
        if IsBlockedByShielder(target) then
            return
        end
        return origInvadeTarget(self, target)
    end

    -- herd 统计：只把不在任何屏蔽半径内的植物计入可寄生数量
    local origFindHerd = self.FindHerd
    function self:FindHerd()
        local choices = {}
        for i, herd in ipairs(self.plantherds) do
            table.insert(choices, herd)
        end

        local choice = {}
        for i, herd in ipairs(choices) do
            local count = 0
            for member, i in pairs(herd.components.herd.members) do
                if not IsBlockedByShielder(member) then
                    if not member.lunarthrall_plant and
                        (not member.components.witherable or not member.components.witherable:IsWithered()) then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                table.insert(choice, { herd = herd, count = count })
            end
        end

        table.sort(choice, function(a, b) return a.count > b.count end)
        if #choice > 0 then
            return choice[math.random(1, math.min(5, #choice))].herd
        end
    end
end)

------------------------------------------------------------------------------------------------
-- 副作用修复：
-- 致命亮茄在战斗索敌（Retarget）时，会搜索 15 单位内带 "lunarthrall_plant" 标签的实体，
-- 并访问 plant.components.combat.target 来统计协同攻击目标（见 lunarthrall_plant.lua）。
-- 避雷针等结构没有 combat 组件，若亮茄恰好与这类结构距离很近（例如先被寄生、后放置避雷针），
-- 会导致原版索敌报错。这里用兼容版本替换原索敌函数：逻辑与原版完全一致，仅增加 nil 保护。
------------------------------------------------------------------------------------------------
local PLANT_MUST        = { "lunarthrall_plant" }
local TARGET_MUST_TAGS  = { "_combat", "character" }
local TARGET_CANT_TAGS  = { "INLIMBO", "lunarthrall_plant", "lunarthrall_plant_end" }

-- 与原版 lunarthrall_plant.lua 中的 vine_addcoldness 一致：
-- 藤蔓受到的冻结效果转移到本体上
local function vine_addcoldness(vine, ...)
    local inst = vine.parentplant
    if inst ~= nil and inst:IsValid() then
        inst.components.freezable:AddColdness(...)
        return true
    end
    return false
end

-- 兼容版索敌（基于原版 Retarget，仅增加 combat 判空保护）
local function SafePlantRetarget(inst)
    -- 注意：mod 环境中 "TheWorld" 全局名被初始化为 nil 遮蔽（GLOBAL.TheWorld 才是真实世界实体），
    -- 运行时必须通过 GLOBAL 获取并判空。
    local world = GLOBAL.TheWorld
    if world == nil then
        return
    end
    if not inst.no_targeting then
        local target = FindEntity(
            inst,
            TUNING.LUNARTHRALL_PLANT_RANGE,
            function(guy)
                if inst.tired then
                    return nil
                end

                local total = 0
                local x, y, z = inst.Transform:GetWorldPosition()
                local plants = TheSim:FindEntities(x, y, z, 15, PLANT_MUST)
                for i, plant in ipairs(plants) do
                    if plant ~= inst and plant.components.combat ~= nil then
                        local plantcombat = plant.components.combat
                        if plantcombat.target ~= nil and plantcombat.target == guy then
                            total = total + 1
                        end
                    end
                end

                if total < 3 then
                    return inst.components.combat:CanTarget(guy)
                end
            end,
            TARGET_MUST_TAGS,
            TARGET_CANT_TAGS
        )

        if inst.vinelimit > 0 and target ~= nil
            and (not inst.components.freezable or not inst.components.freezable:IsFrozen()) then

            local pos = inst:GetPosition()
            local theta = math.random() * TWOPI
            local radius = TUNING.LUNARTHRALL_PLANT_MOVEDIST
            local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
            pos = pos + offset

            if world.Map:IsVisualGroundAtPoint(pos.x, pos.y, pos.z) then
                local vine = SpawnPrefab("lunarthrall_plant_vine_end")
                vine.Transform:SetPosition(pos.x, pos.y, pos.z)
                vine.Transform:SetRotation(inst:GetAngleToPoint(pos.x, pos.y, pos.z))
                vine.components.freezable:SetRedirectFn(vine_addcoldness)
                vine.sg:RemoveStateTag("nub")
                if inst.tintcolor then
                    vine.AnimState:SetMultColour(inst.tintcolor, inst.tintcolor, inst.tintcolor, 1)
                    vine.tintcolor = inst.tintcolor
                end
                inst.components.colouradder:AttachChild(vine)
                vine.parentplant = inst
                table.insert(inst.vines, vine)
                inst.vinelimit = inst.vinelimit - 1
                inst:DoTaskInTime(0, function()
                    vine:ChooseAction()
                end)

                return target
            end
        end
    end
end

AddPrefabPostInit("lunarthrall_plant", function(inst)
    if not IsMasterSim() or inst.components.combat == nil then
        return
    end
    inst.components.combat:SetRetargetFunction(inst.components.combat.retargetperiod, SafePlantRetarget)
end)
