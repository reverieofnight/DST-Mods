GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- [TUNING]--------------------
TUNING.ROOMCAR_BIGBAG_LANG = GetModConfigData("LANG")
TUNING.ROOMCAR_BIGBAG_STACK = GetModConfigData("STACK")
TUNING.ROOMCAR_BIGBAG_FRESH = GetModConfigData("FRESH")
TUNING.ROOMCAR_BIGBAG_KEEPFRESH = GetModConfigData("KEEPFRESH")
TUNING.ROOMCAR_BIGBAG_LIGHT = GetModConfigData("LIGHT")
TUNING.ROOMCAR_BIGBAG_RECIPE = GetModConfigData("RECIPE")
TUNING.ROOMCAR_BIGBAG_WALKSPEED = GetModConfigData("WALKSPEED")
TUNING.ROOMCAR_BIGBAG_CONTAINERDRAG_SWITCH = GetModConfigData("CONTAINERDRAG_SWITCH")
TUNING.ROOMCAR_BIGBAG_BAGINBAG = GetModConfigData("BAGINBAG")
TUNING.ROOMCAR_BIGBAG_HEATROCKTEMPERATURE = GetModConfigData("HEATROCKTEMPERATURE")
TUNING.ROOMCAR_BIGBAG_WATER = GetModConfigData("BIGBAGWATER")
TUNING.ROOMCAR_BIGBAG_PICK = GetModConfigData("BIGBAGPICK")
TUNING.NICE_BIGBAGSIZE = GetModConfigData("NICEBIGBAGSIZE")
TUNING.NICE_BAGREFRESH = GetModConfigData("NICEBAGREFRESH")
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
if TUNING.ROOMCAR_BIGBAG_LANG == 1 then
	GLOBAL.STRINGS.bigbag_BUTTON = "整理"
else
	GLOBAL.STRINGS.bigbag_BUTTON = "Sort"
end

local Ingredient = GLOBAL.Ingredient

--------------------------------------------------------------------------------------------------------------------------
-- [Recipe]
local tec = GLOBAL.TECH.NONE
local RcpType = TUNING.ROOMCAR_BIGBAG_RECIPE

if RcpType == 1 then
    tec = GLOBAL.TECH.NONE
elseif  RcpType == 2 then
    tec = GLOBAL.TECH.SCIENCE_ONE
elseif  RcpType == 3 then
    tec = GLOBAL.TECH.SCIENCE_TWO
elseif  RcpType == 4 then
    tec = GLOBAL.TECH.MAGIC_ONE
elseif  RcpType == 5 then
    tec = GLOBAL.TECH.MAGIC_TWO
end

local nicebigbag = AddRecipe("nicebigbag", 
{Ingredient("goldnugget", 40), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 20)},
GLOBAL.RECIPETABS.SURVIVAL, -- tab
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
