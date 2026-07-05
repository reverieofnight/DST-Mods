GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- [TUNING]--------------------
TUNING.ROOMCAR_BIGBAG_BAGSIZE = GetModConfigData("BAGSIZE")
TUNING.ROOMCAR_BIGBAG_LANG = GetModConfigData("LANG")
--TUNING.ROOMCAR_BIGBAG_GIVE = GetModConfigData("GIVE")
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
	"bigbag",
	"gembigbag",
	"nicebigbag"
}

-- [Assets]--------------------
Assets=
{
	Asset("ANIM", "anim/swap_bigbag.zip"),
	Asset("ANIM", "anim/ui_bigbag_3x8.zip"),
	Asset("ANIM", "anim/ui_bigbag_4x8.zip"),
	--Asset("ANIM", "anim/bigbag_ui_8x6.zip"),
	--Asset("ANIM", "anim/bigbag_ui_8x8.zip"),

	Asset("IMAGE", "images/inventoryimages/bigbag.tex"),
	Asset("ATLAS", "images/inventoryimages/bigbag.xml"),

	Asset("IMAGE", "minimap/bigbag.tex"),
	Asset("ATLAS", "minimap/bigbag.xml"),

	--Asset("IMAGE", "images/bigbagbg.tex"),
	--Asset("ATLAS", "images/bigbagbg.xml"),
	
	Asset("IMAGE", "images/bigbagbg_8x8.tex"),
	Asset("ATLAS", "images/bigbagbg_8x8.xml"),
	
	Asset("IMAGE", "images/bigbagbg_8x6.tex"),
	Asset("ATLAS", "images/bigbagbg_8x6.xml"),
}

-- [Miniap Icon]--------------------
AddMinimapAtlas("minimap/bigbag.xml")

--------------------------------------------------------------------------------------------------------------------------
-- [Global Strings]
if TUNING.ROOMCAR_BIGBAG_LANG == 1 then
	GLOBAL.STRINGS.bigbag_BUTTON = "整理"
else
	GLOBAL.STRINGS.bigbag_BUTTON = "Sort"
end

--------------------
local Ingredient = GLOBAL.Ingredient
--------------------------------------------------------------------------------------------------------------------------
-- [Custom Recipe]
--------------------
local rcp = RcpN
local tec = GLOBAL.TECH.NONE
local RcpType = TUNING.ROOMCAR_BIGBAG_RECIPE

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

if TUNING.ROOMCAR_BIGBAG_FRESH and TUNING.ROOMCAR_BIGBAG_STACK then
    for _,v in ipairs(RcpPlus) do
        table.insert(rcp,v)
    end
end

local bigbag = AddRecipe("bigbag", -- name
rcp, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
GLOBAL.RECIPETABS.REFINE, -- tab ( FARM, WAR, DRESS etc)
tec, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/bigbag.xml", -- atlas
"bigbag.tex") -- image

local redbigbag = AddRecipe("redbigbag", -- name
{Ingredient("bigbag",1,"images/inventoryimages/bigbag.xml"), Ingredient("redgem", 1)}, -- ingredients Add more like so , 
GLOBAL.RECIPETABS.REFINE, -- tab ( FARM, WAR, DRESS etc)
tec, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/redbigbag.xml", -- atlas
"redbigbag.tex") -- image

local bluebigbag = AddRecipe("bluebigbag", -- name
{Ingredient("bigbag",1,"images/inventoryimages/bigbag.xml"), Ingredient("bluegem", 1)}, -- ingredients Add more like so , 
GLOBAL.RECIPETABS.REFINE, -- tab ( FARM, WAR, DRESS etc)
tec, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/bluebigbag.xml", -- atlas
"bluebigbag.tex") -- image

local nicebigbag = AddRecipe("nicebigbag", 
{Ingredient("goldnugget", 40), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 20)},
GLOBAL.RECIPETABS.SURVIVAL, -- tab ( FARM, WAR, DRESS etc)
tec, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
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

require("bigbag_debugcommands")--调试用指令


AddPrefabPostInit("redbigbag",function(inst)

	if not inst.components.insulator then
	inst:AddComponent("insulator") 
	inst.components.insulator:SetWinter()
	inst.components.insulator:SetInsulation(500)
	end
end)
AddPrefabPostInit("bluebigbag",function(inst)

	if not inst.components.insulator then
	inst:AddComponent("insulator") 
	inst.components.insulator:SetSummer()
	inst.components.insulator:SetInsulation(500)
	end
end) 