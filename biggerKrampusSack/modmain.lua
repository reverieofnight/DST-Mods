-- 更大的坎普斯背包 modmain.lua
-- 功能：将坎普斯背包的容器格子从 2x7（14格）修改为 3x8 或 4x8

-- 声明自定义背包容器动画资源
Assets = {
    Asset("ANIM", "anim/ui_bigbag_3x8.zip"),
    Asset("ANIM", "anim/ui_bigbag_4x8.zip"),
}

local containers = require "containers"

-- 读取用户配置
local BAGSIZE = GetModConfigData("BAGSIZE")
local CONTAINERDRAG = GetModConfigData("CONTAINERDRAG")

-- 选择原始大小则不修改布局
if BAGSIZE ~= "2x7" then
    local NUM_COLS, NUM_ROWS
    if BAGSIZE == "4x8" then
        NUM_COLS = 4
        NUM_ROWS = 8
    else
        NUM_COLS = 3
        NUM_ROWS = 8
    end

    -- 修改坎普斯背包的容器布局
    local config = containers.params.krampus_sack
    if config then
        -- 清空原有格子位置，重新生成布局
        config.widget.slotpos = {}

        -- 根据列数计算居中偏移
        local col_offset
        if NUM_COLS == 4 then
            col_offset = -243   -- 4列居中：-243, -168, -93, -18
        else
            col_offset = -205   -- 3列居中：-205, -130, -55
        end

        for y = 0, NUM_ROWS - 1 do
            for x = 0, NUM_COLS - 1 do
                table.insert(config.widget.slotpos, GLOBAL.Vector3(col_offset + x * 75, -75 * y + 265, 0))
            end
        end

        -- 将容器整体往左移
        config.widget.pos = GLOBAL.Vector3(-50, 0, 0)

        -- 使用原版开/关动画骨架，自定义背包容器背景
        config.widget.animbank = "ui_krampusbag_2x8"
        if NUM_COLS == 4 then
            config.widget.animbuild = "ui_bigbag_4x8"
        else
            config.widget.animbuild = "ui_bigbag_3x8"
        end

        -- 更新全局最大格子数（防止格子数超出限制）
        containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, #config.widget.slotpos)
    end
end

-------------------------------------------------------------------------------
-- [容器拖拽功能]
-------------------------------------------------------------------------------

GLOBAL.STRINGS.BIGGERKRAMPUSSACK_UI = {
    DRAGABLETIPS = "右键拖拽移动UI",
}

-- 容器默认坐标
local default_pos = {
    krampus_sack = GLOBAL.Vector3(-150, -120, 0),
}

-- 拖拽坐标本地存储
local dragpos = {}

local function loadDragPos()
    GLOBAL.TheSim:GetPersistentString("biggerkrampussack_drag_pos", function(load_success, data)
        if load_success and data ~= nil then
            local success, allpos = GLOBAL.RunInSandbox(data)
            if success and allpos then
                for k, v in pairs(allpos) do
                    if dragpos[k] == nil then
                        dragpos[k] = GLOBAL.Vector3(v.x or 0, v.y or 0, v.z or 0)
                    end
                end
            end
        end
    end)
end

local function saveDragPos()
    if GLOBAL.next(dragpos) then
        local str = GLOBAL.DataDumper(dragpos, nil, true)
        GLOBAL.TheSim:SetPersistentString("biggerkrampussack_drag_pos", str, false)
    end
end

local function GetBagDragPos(dragtyp)
    if dragpos[dragtyp] == nil then
        loadDragPos()
    end
    return dragpos[dragtyp]
end

-- 设置UI可拖拽
local function MakeBagDragable(self, dragtarget, dragtyp)
    self.candrag = true

    -- 给拖拽目标添加拖拽提示和鼠标控制
    if dragtarget then
        dragtarget:SetTooltip(GLOBAL.STRINGS.BIGGERKRAMPUSSACK_UI.DRAGABLETIPS)
        local oldOnControl = dragtarget.OnControl
        dragtarget.OnControl = function(self, control, down, ...)
            local parentwidget = self:GetParent()
            if parentwidget and parentwidget.Passive_OnControl then
                parentwidget:Passive_OnControl(control, down)
            end
            if oldOnControl then
                return oldOnControl(self, control, down, ...)
            end
        end
    end

    function self:Passive_OnControl(control, down)
        if control == GLOBAL.CONTROL_SECONDARY then
            if down then
                self:StartDrag()
            else
                self:EndDrag()
            end
        end
    end

    function self:SetDragPosition(x, y, z)
        local pos
        if type(x) == "number" then
            pos = GLOBAL.Vector3(x, y, z)
        else
            pos = x
        end
        local self_scale = self:GetScale()
        local offset = 0.6 -- 容器偏移修正
        local newpos = self.p_startpos + (pos - self.m_startpos) / (self_scale.x / offset)
        self:SetPosition(newpos)
    end

    function self:StartDrag()
        if not self.followhandler then
            local mousepos = GLOBAL.TheInput:GetScreenPosition()
            self.m_startpos = mousepos
            self.p_startpos = self:GetPosition()
            self.followhandler = GLOBAL.TheInput:AddMoveHandler(function(x, y)
                self:SetDragPosition(x, y, 0)
                if not GLOBAL.TheInput:IsMouseDown(GLOBAL.MOUSEBUTTON_RIGHT) then
                    self:EndDrag()
                end
            end)
            self:SetDragPosition(mousepos)
        end
    end

    function self:EndDrag()
        if self.followhandler then
            self.followhandler:Remove()
        end
        self.followhandler = nil
        self.m_startpos = nil
        self.p_startpos = nil
        if dragtyp then
            dragpos[dragtyp] = self:GetPosition()
        end
        saveDragPos()
    end
end

-- 为坎普斯背包容器添加拖拽功能
if CONTAINERDRAG then
    AddClassPostConstruct("widgets/containerwidget", function(self)
        local oldOpen = self.Open
        self.Open = function(self, container, doer, ...)
            oldOpen(self, container, doer, ...)
            if self.container and self.container.replica.container then
                local widget = self.container.replica.container:GetWidget()
                if widget and container.prefab == "krampus_sack" then
                    -- 设置容器坐标（可装备容器第一次打开延迟处理）
                    local newpos = GetBagDragPos("krampus_sack") or default_pos["krampus_sack"]
                    if newpos then
                        if self.container:HasTag("_equippable") and not self.container.isopended then
                            self.container:DoTaskInTime(0, function()
                                self:SetPosition(newpos)
                            end)
                            self.container.isopended = true
                        else
                            self:SetPosition(newpos)
                        end
                    end
                    -- 添加拖拽功能
                    if not self.candrag then
                        MakeBagDragable(self, self.bgimage, "krampus_sack")
                        MakeBagDragable(self, self.bganim, "krampus_sack")
                    end
                end
            end
        end
    end)
end

-- 重置拖拽坐标
function ResetBigBagUIPos()
    dragpos = {}
    GLOBAL.TheSim:SetPersistentString("biggerkrampussack_drag_pos", "", false)
end
