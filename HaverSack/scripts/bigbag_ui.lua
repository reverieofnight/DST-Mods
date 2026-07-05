---------------------------------------------------------------------------------------------------------
-----------------------------------------------新容器----------------------------------------------------
---------------------------------------------------------------------------------------------------------

local default_pos = Vector3(-150, -120, 0)

-- 各尺寸视觉配置
local size_visuals = {
    [1] = { animbank = "ui_krampusbag_2x8", animbuild = "ui_bigbag_3x8",    btn_pos = Vector3(-130, -320, 0) },
    [2] = { animbank = "ui_krampusbag_2x8", animbuild = "ui_bigbag_4x8",    btn_pos = Vector3(-130, -320, 0) },
    [3] = { bgatlas = "images/bigbagbg_8x6.xml", bgimage = "bigbagbg_8x6.tex", btn_pos = Vector3(0, 285, 0) },
    [4] = { bgatlas = "images/bigbagbg_8x8.xml", bgimage = "bigbagbg_8x8.tex", btn_pos = Vector3(0, 285, 0) },
}

-- 各尺寸格子位置生成器
local gridsize = 66
local mis = 3.5 * gridsize
local slot_generators = {
    [1] = function()  -- 8x3 (24格)
        local slots = {}
        for y = 0, 7 do
            table.insert(slots, Vector3(-131 - 75, -75 * y + 264, 0))
            table.insert(slots, Vector3(-131, -75 * y + 264, 0))
            table.insert(slots, Vector3(-131 + 75, -75 * y + 264, 0))
        end
        return slots
    end,
    [2] = function()  -- 8x4 (32格)
        local slots = {}
        for y = 0, 7 do
            table.insert(slots, Vector3(-168 - 75, -75 * y + 266, 0))
            table.insert(slots, Vector3(-168, -75 * y + 266, 0))
            table.insert(slots, Vector3(-168 + 75, -75 * y + 266, 0))
            table.insert(slots, Vector3(-168 + 150, -75 * y + 266, 0))
        end
        return slots
    end,
    [3] = function()  -- 8x6 (48格)
        local slots = {}
        for n = 0, 7 do
            for col = 1, 6 do
                table.insert(slots, Vector3(col * gridsize - mis, 462 - mis - n * gridsize, 0))
            end
        end
        return slots
    end,
    [4] = function()  -- 8x8 (64格)
        local slots = {}
        for n = 0, 7 do
            for col = 0, 7 do
                table.insert(slots, Vector3(col * gridsize - mis, 462 - mis - n * gridsize, 0))
            end
        end
        return slots
    end,
}

local params = {}
local vis = size_visuals[TUNING.ROOMCAR_HAVERSACK_BIGBAGSIZE]
local slots = slot_generators[TUNING.ROOMCAR_HAVERSACK_BIGBAGSIZE]()

-- 构建容器参数
params.haver_sack = {
    widget = {
        slotpos = slots,
        pos = default_pos,
        -- dragtyp 在容器打开时手动设置，避免与 origin mod 冲突
        buttoninfo = {
            text = STRINGS.haver_sack_BUTTON,
            position = vis.btn_pos,
        },
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
}
-- 视觉：动画渲染 vs 背景图
if vis.animbank then
    params.haver_sack.widget.animbank = vis.animbank
    params.haver_sack.widget.animbuild = vis.animbuild
else
    params.haver_sack.widget.bgatlas = vis.bgatlas
    params.haver_sack.widget.bgimage = vis.bgimage
end


---代码抄自能力勋章
---------------------------------------------容器整理功能-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--按字母排序
local function cmp_prefab(a, b)
   if a and b then
       a = tostring(a.prefab)
       b = tostring(b.prefab)
       local patt = '^(.-)%s*(%d+)$'
       local _, _, col1, num1 = a:find(patt)
       local _, col2, num2 = b:find(patt)
       if (col1 and col2) and col1 == col2 then
          return tonumber(num1) < tonumber(num2)
       end
       return a < b
   end
end

--容器排序
local function slotsSort(inst)
    if inst and inst.components.container then
        local keys = table.getkeys(inst.components.container.slots)
        if #keys > 0 then
            table.sort(keys)
            for k, v in ipairs(keys) do
                if k ~= v then
                    local item = inst.components.container:RemoveItemBySlot(v)
                    if item then
                        inst.components.container:GiveItem(item, k)
                    end
                end
            end
        end
        table.sort(inst.components.container.slots, cmp_prefab)
        for k, v in ipairs(inst.components.container.slots) do
            local item = inst.components.container:RemoveItemBySlot(k)
            if item then
                inst.components.container:GiveItem(item)
            end
        end
    end
end

--整理按钮逻辑
function params.haver_sack.widget.buttoninfo.fn(inst)
    if inst.components.container ~= nil then
        if not inst.components.container:IsEmpty() then
            slotsSort(inst)
        end
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
    end
end

--整理按钮亮起规则
function params.haver_sack.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
end

-- 放入时检测设定
function params.haver_sack.itemtestfn(container, item, slot)
    return item.prefab ~= "haver_sack"
end


--加入容器
local containers = require("containers")
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local oldwidgetsetup = containers.widgetsetup
function containers.widgetsetup(container, prefab, data, ...)
    local name = data or params[prefab or container.inst.prefab]
    if name ~= nil then
        for k, v in pairs(name) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        return oldwidgetsetup(container, prefab, data, ...)
    end
end


---------------------------------------------------------------------------------------------------------
----------------------------------------------容器拖拽---------------------------------------------------
---------------------------------------------------------------------------------------------------------
--获取拖拽坐标
local function GetDragPos(key)
    local saved = ThePlayer and ThePlayer.haver_sack_drag_pos and ThePlayer.haver_sack_drag_pos:value()
    if not saved then return end
    local parts = string.split(saved, ";")
    for _, part in ipairs(parts) do
        if string.find(part, key, 1, true) then
            local info = string.split(part, ",")
            return Vector3(info[2], info[3], info[4])
        end
    end
end

local dragpos_cache = {}

--更新同步拖拽坐标
local function RefreshDragPos()
    local saved = ThePlayer and ThePlayer.haver_sack_drag_pos and ThePlayer.haver_sack_drag_pos:value()
    if saved and saved ~= "" then
        local parts = string.split(saved, ";")
        for _, part in ipairs(parts) do
            local info = string.split(part, ",")
            if info[1] and dragpos_cache[info[1]] == nil then
                dragpos_cache[info[1]] = Vector3(info[2], info[3], info[4])
            end
        end
    end
end

--记录拖拽坐标
local function SaveDragPos()
    RefreshDragPos()
    local parts = {}
    for k, v in pairs(dragpos_cache) do
        table.insert(parts, k .. "," .. v.x .. "," .. v.y .. "," .. v.z)
    end
    if #parts > 0 then
        SendModRPCToServer(MOD_RPC.HaverSack.HaverSack_SetDragPos, table.concat(parts, ";"))
    end
end

--设置UI可拖拽
local function MakeDraggable(self, dragtyp)
    --添加拖拽提示
    local is_large = TUNING.ROOMCAR_HAVERSACK_BIGBAGSIZE == 3 or TUNING.ROOMCAR_HAVERSACK_BIGBAGSIZE == 4
    local is_small = TUNING.ROOMCAR_HAVERSACK_BIGBAGSIZE == 1 or TUNING.ROOMCAR_HAVERSACK_BIGBAGSIZE == 2
    if TUNING.ROOMCAR_HAVERSACK_CONTAINERDRAG_SWITCH then
        local tip = STRINGS.haver_sack_UI.DRAGABLETIPS1 .. string.sub(TUNING.ROOMCAR_HAVERSACK_CONTAINERDRAG_SWITCH, -2) .. STRINGS.haver_sack_UI.DRAGABLETIPS2
        if self.bgimage and is_large then
            self.bgimage:SetTooltip(tip)
        elseif self.bganim and is_small then
            self.bganim:SetTooltip(tip)
        end
    end

    local oldOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        if TheInput:IsKeyDown(GLOBAL[TUNING.ROOMCAR_HAVERSACK_CONTAINERDRAG_SWITCH or "KEY_F1"]) then
            self:Drag_OnControl(control, down)
        end
        return oldOnControl(self, control, down)
    end

    self:MoveToBack()

    function self:Drag_OnControl(control, down)
        if control == CONTROL_ACCEPT then
            if down then self:Drag_Start() else self:Drag_Stop() end
        end
    end

    function self:Drag_SetPos(x, y, z)
        local pos = type(x) == "number" and Vector3(x, y, z) or x
        self:SetPosition(pos + self.dragOffset)
        if dragtyp then
            dragpos_cache[dragtyp] = pos + self.dragOffset
        end
    end

    function self:Drag_Start()
        if not self.followhandler then
            local mouse = TheInput:GetScreenPosition()
            self.dragOffset = self:GetPosition() - mouse
            self.followhandler = TheInput:AddMoveHandler(function(x, y)
                self:Drag_SetPos(x, y, 0)
                if not TheInput:IsKeyDown(GLOBAL[TUNING.ROOMCAR_HAVERSACK_CONTAINERDRAG_SWITCH or "KEY_F1"]) then
                    self:Drag_Stop()
                end
            end)
            self:Drag_SetPos(mouse)
        end
    end

    function self:Drag_Stop()
        if self.followhandler then
            self.followhandler:Remove()
        end
        self.followhandler = nil
        self.dragOffset = nil
        self:MoveToBack()
        SaveDragPos()
    end

    function self:Drag_Scale(delta)
        self.scale = math.max(self.scale + delta, 0.1)
        self:SetScale(self.scale, self.scale, self.scale)
        self:MoveToBack()
    end
end

--给容器添加拖拽功能
if TUNING.ROOMCAR_HAVERSACK_CONTAINERDRAG_SWITCH then
    AddClassPostConstruct("widgets/containerwidget", function(self)
        local oldOpen = self.Open
        self.Open = function(self, ...)
            local container = self.container
            local is_haver_sack = container and container.prefab == "haver_sack"
            local widget = is_haver_sack and container.replica and container.replica.container and container.replica.container:GetWidget()
            local old_dragtyp = nil
            if widget and widget.dragtyp then
                old_dragtyp = widget.dragtyp
                widget.dragtyp = nil
            end
            oldOpen(self, ...)
            if not is_haver_sack then return end
            if not widget then return end
            widget.dragtyp = "haver_sack"

            if dragpos_cache["haver_sack"] == nil then
                dragpos_cache["haver_sack"] = GetDragPos("haver_sack")
            end
            --可装备的容器首次打开延迟加载(否则读档时读不到坐标)
            if container:HasTag("_equippable") and not container.isopended then
                container:DoTaskInTime(0, function()
                    self:SetPosition(dragpos_cache["haver_sack"] or default_pos)
                end)
                container.isopended = true
            else
                self:SetPosition(dragpos_cache["haver_sack"] or default_pos)
            end
            MakeDraggable(self, "haver_sack")
        end
    end)
end

--重置拖拽坐标
function ResetBagUIPos()
    dragpos_cache = {}
    SendModRPCToServer(MOD_RPC.HaverSack.HaverSack_SetDragPos, "")
end
GLOBAL.ResetHaverSackBagUIPos = ResetBagUIPos
