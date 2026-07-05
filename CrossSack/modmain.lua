GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- [Prefab Files]
PrefabFiles = {
    "crosssack",
}

-- [Assets]
Assets = {
    Asset("ANIM", "anim/elaina_bag.zip"),
    Asset("ANIM", "anim/ui_bigbag_3x8.zip"),
    Asset("ANIM", "anim/ui_bigbag_4x8.zip"),
    Asset("IMAGE", "images/inventoryimages/crosssack.tex"),
    Asset("ATLAS", "images/inventoryimages/crosssack.xml"),
    Asset("IMAGE", "images/inventoryimages/crosssack_open.tex"),
    Asset("ATLAS", "images/inventoryimages/crosssack_open.xml"),
    Asset("IMAGE", "minimap/crosssack.tex"),
    Asset("ATLAS", "minimap/crosssack.xml"),
    Asset("IMAGE", "images/bigbagbg_8x6.tex"),
    Asset("ATLAS", "images/bigbagbg_8x6.xml"),
    Asset("IMAGE", "images/bigbagbg_8x8.tex"),
    Asset("ATLAS", "images/bigbagbg_8x8.xml"),
}

-- [Global Strings]
STRINGS.NAMES.CROSSSACK = "挎包"
STRINGS.RECIPE_DESC.CROSSSACK = "空间大，功能多的背包。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROSSSACK = "有了这个，我可以很好地照顾自己！"

-- [Minimap Icon]
AddMinimapAtlas("minimap/crosssack.xml")

-- [Container Widget Setup]
local BAGSIZE = GetModConfigData("BAGSIZE")
local KEEPFRESH = GetModConfigData("KEEPFRESH")

GLOBAL.TUNING.ROOMCAR_BIGBAG_KEEPFRESH = KEEPFRESH
local CONTAINERDRAG_SWITCH = GetModConfigData("CONTAINERDRAG_SWITCH")
GLOBAL.TUNING.ROOMCAR_BIGBAG_CONTAINERDRAG_SWITCH = CONTAINERDRAG_SWITCH
local BAGINBAG = GetModConfigData("BAGINBAG")
GLOBAL.TUNING.ROOMCAR_BIGBAG_BAGINBAG = BAGINBAG

local params = {}
if BAGSIZE == 1 then
    -- 8x3 (24格)
    params.crosssack = {
        widget = {
            slotpos = {},
            animbank = "ui_krampusbag_2x8",
            animbuild = "ui_bigbag_3x8",
            pos = Vector3(-180, -75, 0),
            dragtyp = "crosssack",
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1,
    }
    for y = 0, 7 do
        table.insert(params.crosssack.widget.slotpos, Vector3(-131 - 75, -75 * y + 264, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(-131, -75 * y + 264, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(-131 + 75, -75 * y + 264, 0))
    end
elseif BAGSIZE == 2 then
    -- 8x4 (32格) - 默认
    params.crosssack = {
        widget = {
            slotpos = {},
            animbank = "ui_krampusbag_2x8",
            animbuild = "ui_bigbag_4x8",
            pos = Vector3(-180, -75, 0),
            dragtyp = "crosssack",
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1,
    }
    for y = 0, 7 do
        table.insert(params.crosssack.widget.slotpos, Vector3(-168 - 75, -75 * y + 266, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(-168, -75 * y + 266, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(-168 + 75, -75 * y + 266, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(-168 + 150, -75 * y + 266, 0))
    end
elseif BAGSIZE == 3 then
    -- 8x6 (48格)
    local gridsize = 66
    local mis = 3.5 * gridsize
    params.crosssack = {
        widget = {
            slotpos = {},
            animbank = nil,
            animbuild = nil,
            bgatlas = "images/bigbagbg_8x6.xml",
            bgimage = "bigbagbg_8x6.tex",
            pos = Vector3(-180, -75, 0),
            dragtyp = "crosssack",
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1,
    }
    for n = 0, 7 do
        table.insert(params.crosssack.widget.slotpos, Vector3(1*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(2*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(3*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(4*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(5*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(6*gridsize - mis, 462 - mis - n*gridsize, 0))
    end
else
    -- 8x8 (64格) - 默认
    local gridsize = 66
    local mis = 3.5 * gridsize
    params.crosssack = {
        widget = {
            slotpos = {},
            animbank = nil,
            animbuild = nil,
            bgatlas = "images/bigbagbg_8x8.xml",
            bgimage = "bigbagbg_8x8.tex",
            pos = Vector3(-180, -75, 0),
            dragtyp = "crosssack",
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1,
    }
    for n = 0, 7 do
        table.insert(params.crosssack.widget.slotpos, Vector3(0*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(1*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(2*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(3*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(4*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(5*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(6*gridsize - mis, 462 - mis - n*gridsize, 0))
        table.insert(params.crosssack.widget.slotpos, Vector3(7*gridsize - mis, 462 - mis - n*gridsize, 0))
    end
end

-- 覆写容器widget设置
local containers = require("containers")
containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, #params.crosssack.widget.slotpos)

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

-- [Crafting Recipe]
local Ingredient = GLOBAL.Ingredient

local RcpType = GetModConfigData("RECIPE")

local RcpVC = {Ingredient("cutgrass", 1)}
local RcpC = {Ingredient("pigskin", 5)}
local RcpN = {Ingredient("goldnugget", 10), Ingredient("pigskin", 10)}
local RcpE = {Ingredient("goldnugget", 20), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 5)}
local RcpVE = {Ingredient("goldnugget", 40), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 20)}

local rcp = RcpN
local tec = GLOBAL.TECH.SCIENCE_TWO

if RcpType == 1 then
    rcp = RcpVC
    tec = GLOBAL.TECH.NONE
elseif RcpType == 2 then
    rcp = RcpC
    tec = GLOBAL.TECH.SCIENCE_TWO
elseif RcpType == 3 then
    rcp = RcpN
    tec = GLOBAL.TECH.SCIENCE_TWO
elseif RcpType == 4 then
    rcp = RcpE
    tec = GLOBAL.TECH.MAGIC_ONE
elseif RcpType == 5 then
    rcp = RcpVE
    tec = GLOBAL.TECH.MAGIC_TWO
end

AddRecipe("crosssack",
    rcp,
    GLOBAL.RECIPETABS.SURVIVAL,
    tec,
    nil,
    nil,
    nil,
    nil,
    nil,
    "images/inventoryimages/crosssack.xml",
    "crosssack.tex"
)

-- 注册到"储物方案"筛选器
AddRecipeToFilter("crosssack", "CONTAINERS")

--------------------------------------------------------------------------------------------------------------------------
-- [Container Drag 背包拖拽]
--------------------------------------------------------------------------------------------------------------------------
STRINGS.CROSSSACK_UI = {
    DRAGABLETIPS = "右键拖拽移动UI",
}

-- 容器默认坐标
local default_pos = {
    crosssack = Vector3(-150, -120, 0),
}

-- 拖拽坐标本地存储
local dragpos = {}

local function loadDragPos()
    TheSim:GetPersistentString("crosssack_drag_pos", function(load_success, data)
        if load_success and data ~= nil then
            local success, allpos = RunInSandbox(data)
            if success and allpos then
                for k, v in pairs(allpos) do
                    if dragpos[k] == nil then
                        dragpos[k] = Vector3(v.x or 0, v.y or 0, v.z or 0)
                    end
                end
            end
        end
    end)
end

local function saveDragPos()
    if next(dragpos) then
        local str = DataDumper(dragpos, nil, true)
        TheSim:SetPersistentString("crosssack_drag_pos", str, false)
    end
end

local function GetCrossSackDragPos(dragtyp)
    if dragpos[dragtyp] == nil then
        loadDragPos()
    end
    return dragpos[dragtyp]
end

-- 设置UI可拖拽（参考能力勋章的坐标算法）
local function MakeCrossSackDragable(self, dragtarget, dragtyp)
    self.candrag = true

    -- 给拖拽目标添加拖拽提示和鼠标控制
    if dragtarget then
        dragtarget:SetTooltip(STRINGS.CROSSSACK_UI.DRAGABLETIPS)
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
        if control == CONTROL_SECONDARY then
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
            pos = Vector3(x, y, z)
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
            local mousepos = TheInput:GetScreenPosition()
            self.m_startpos = mousepos
            self.p_startpos = self:GetPosition()
            self.followhandler = TheInput:AddMoveHandler(function(x, y)
                self:SetDragPosition(x, y, 0)
                if not TheInput:IsMouseDown(MOUSEBUTTON_RIGHT) then
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

-- 只对CrossSack容器添加拖拽功能
if CONTAINERDRAG_SWITCH then
    AddClassPostConstruct("widgets/containerwidget", function(self)
        local oldOpen = self.Open
        self.Open = function(self, container, doer, ...)
            oldOpen(self, container, doer, ...)
            if self.container and self.container.replica.container then
                local widget = self.container.replica.container:GetWidget()
                if widget and widget.dragtyp == "crosssack" then
                    -- 设置容器坐标（可装备容器第一次打开延迟处理）
                    local newpos = GetCrossSackDragPos("crosssack") or default_pos["crosssack"]
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
                        MakeCrossSackDragable(self, self.bgimage, "crosssack")
                        MakeCrossSackDragable(self, self.bganim, "crosssack")
                    end
                end
            end
        end
    end)
end

-- 重置拖拽坐标（gm指令）
function ResetCrossSackUIPos()
    dragpos = {}
    TheSim:SetPersistentString("crosssack_drag_pos", "", false)
end
GLOBAL.ResetCrossSackUIPos = ResetCrossSackUIPos