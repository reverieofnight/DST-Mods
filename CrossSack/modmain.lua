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

local params = {}
if BAGSIZE == 1 then
    -- 8x3 (24格)
    params.crosssack = {
        widget = {
            slotpos = {},
            animbank = "ui_krampusbag_2x8",
            animbuild = "ui_bigbag_3x8",
            pos = Vector3(-180, -75, 0),
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