GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- [TUNING]--------------------
TUNING.ROOMCAR_HAVERSACK_LANG = GetModConfigData("LANG")
TUNING.ROOMCAR_HAVERSACK_STACK = GetModConfigData("STACK")
TUNING.ROOMCAR_HAVERSACK_FRESH = GetModConfigData("FRESH")
TUNING.ROOMCAR_HAVERSACK_KEEPFRESH = GetModConfigData("KEEPFRESH")
TUNING.ROOMCAR_HAVERSACK_LIGHT = GetModConfigData("LIGHT")
TUNING.ROOMCAR_HAVERSACK_RECIPE = GetModConfigData("RECIPE")
TUNING.ROOMCAR_HAVERSACK_WALKSPEED = GetModConfigData("WALKSPEED")
TUNING.ROOMCAR_HAVERSACK_CONTAINERDRAG_SWITCH = GetModConfigData("CONTAINERDRAG_SWITCH")
TUNING.ROOMCAR_HAVERSACK_BAGINBAG = GetModConfigData("BAGINBAG")
TUNING.ROOMCAR_HAVERSACK_HEATROCKTEMPERATURE = GetModConfigData("HEATROCKTEMPERATURE")
TUNING.ROOMCAR_HAVERSACK_WATER = GetModConfigData("BIGBAGWATER")
TUNING.ROOMCAR_HAVERSACK_PICK = GetModConfigData("BIGBAGPICK")
TUNING.ROOMCAR_HAVERSACK_BIGBAGSIZE = GetModConfigData("NICEBIGBAGSIZE")
TUNING.ROOMCAR_HAVERSACK_BAGREFRESH = GetModConfigData("NICEBAGREFRESH")
-- [Prefab Files]--------------------
PrefabFiles = {
	"nicebigbag"
}

-- [Assets]--------------------
Assets=
{
	Asset("ANIM", "anim/ui_bigbag_3x8.zip"),
	Asset("ANIM", "anim/ui_bigbag_4x8.zip"),

	Asset("IMAGE", "images/bigbagbg_8x8.tex"),
	Asset("ATLAS", "images/bigbagbg_8x8.xml"),
	
	Asset("IMAGE", "images/bigbagbg_8x6.tex"),
	Asset("ATLAS", "images/bigbagbg_8x6.xml"),
}

-- [Minimap Icon]--------------------
AddMinimapAtlas("minimap/bigbag.xml")

--------------------------------------------------------------------------------------------------------------------------
-- [Global Strings]
if TUNING.ROOMCAR_HAVERSACK_LANG == 1 then
	GLOBAL.STRINGS.haver_sack_BUTTON = "整理"
else
	GLOBAL.STRINGS.haver_sack_BUTTON = "Sort"
end

local Ingredient = GLOBAL.Ingredient
--------------------------------------------------------------------------------------------------------------------------
-- [Recipe]
local rcp = nil
local tec = GLOBAL.TECH.NONE
local RcpType = TUNING.ROOMCAR_HAVERSACK_RECIPE

local RcpPlus = {Ingredient("purplegem", 1)}
local RcpVC = {Ingredient("cutgrass", 1)}
local RcpC = {Ingredient("pigskin", 5)}
local RcpN = {Ingredient("goldnugget", 10), Ingredient("pigskin", 10)}
local RcpE = {Ingredient("goldnugget", 20), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 5)}
local RcpVE = {Ingredient("goldnugget", 40), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 20)}

if RcpType == 1 then
    rcp = RcpVC
    tec = GLOBAL.TECH.NONE
elseif  RcpType == 2 then
    rcp = RcpC
    tec = GLOBAL.TECH.SCIENCE_ONE
elseif  RcpType == 3 then
    rcp = RcpN
    tec = GLOBAL.TECH.SCIENCE_TWO
elseif  RcpType == 4 then
    rcp = RcpE
    tec = GLOBAL.TECH.MAGIC_ONE
elseif  RcpType == 5 then
    rcp = RcpVE
    tec = GLOBAL.TECH.MAGIC_TWO
end

if TUNING.ROOMCAR_HAVERSACK_FRESH and TUNING.ROOMCAR_HAVERSACK_STACK then
    for _,v in ipairs(RcpPlus) do
        table.insert(rcp,v)
    end
end

AddRecipe("haver_sack",
rcp,
GLOBAL.RECIPETABS.REFINE, -- tab
tec, -- level
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/nicebigbag.xml", -- atlas
"nicebigbag.tex") -- image
--------------------------------------------------------------------------------------------------------------------------
modimport("scripts/strings_bigbag.lua")
modimport("scripts/bigbag_rpc.lua")
modimport("scripts/bigbag_hook.lua")
modimport("scripts/bigbag_ui.lua")--UI、容器等

modimport("scripts/bigbag_debugcommands.lua")--调试用指令
