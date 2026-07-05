GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- [Prefab Files]
PrefabFiles = {
    "crosssack",
}

-- [Assets]
Assets = {
    Asset("IMAGE", "images/inventoryimages/crosssack.tex"),
    Asset("ATLAS", "images/inventoryimages/crosssack.xml"),
}

-- [Container Widget Setup]
-- 14格挎包容器布局 (2列 x 7行)
local params = {}
params.crosssack = {
    widget = {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(-180, -75, 0),
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
}

-- 生成14个格子位置 (2列 x 7行)
for y = 0, 6 do
    table.insert(params.crosssack.widget.slotpos, Vector3(-75, -75 * y + 264, 0))
    table.insert(params.crosssack.widget.slotpos, Vector3(0, -75 * y + 264, 0))
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

local recipe = AddRecipe("crosssack",
    {
        Ingredient("cutgrass", 8),
        Ingredient("twigs", 4),
        Ingredient("silk", 2),
    },
    GLOBAL.RECIPETABS.SURVIVAL,
    GLOBAL.TECH.SCIENCE_ONE,
    nil,
    nil,
    nil,
    nil,
    nil,
    "images/inventoryimages/crosssack.xml",
    "crosssack.tex"
)