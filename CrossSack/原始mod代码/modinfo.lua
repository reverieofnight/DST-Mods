--------------------------------------------------------------------------------------------------------------------------
name = "A Big Bag（大背包）"
author = "Roomcar&Sunny"
version = "2.3.2"
description = "A New 8x4 or 8x6 or 8x8 Big Bag.\n8x4或8x6或8x8的大背包。\n\
Keep food fresh.\n可选：食物保鲜。\n\
Make things fresh again.\n可选：让物品和食物恢复新鲜。\n\
Get full stack of things.\n可选：让物品自动堆叠至最大。\n\
Light to survive in the dark.\n可选：保命微光。\n\
Drag the bigbag's UI using the shortcut keys and mouse.\n可选：使用快捷键加鼠标拖拽你的大背包位置。\n\
Bag in bag.\n可选：支持包中包。"

api_version = 10
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = {"A Big Bag", "roomcar%sunny", "bigbag"}

forumthread = ""
icon_atlas = "bigbagicon.xml"
icon = "bigbagicon.tex"

priority = 0

configuration_options = {
	{
		name = "LANG",
		label = "Language (语言)",
		hover = "Change display language.",
		options = {
			{ description = "English", data = 0, },
			{ description = "简体中文", data = 1, },
		},
		default = 1,
	},
	{
		name = "BAGSIZE",
		label = "Size of bag(背包大小)",
		hover = "Size of bag",
		options = {
			{ description = "8x3", data = 4, },
			{ description = "8x4", data = 1, },
			{ description = "8x6", data = 2, },
			{ description = "8x8", data = 3, },
		},
		default = 1,
	},
	{
		name = "NICEBIGBAGSIZE",
		label = "Size of haversack(挎包大小)",
		hover = "Choose your size of haversack.",
		options = {
			{ description = "8x3", data = 1, },
			{ description = "8x4", data = 2, },
		},
		default = 2,
	},
	{
		name = "KEEPFRESH",
		label = "KeepFresh (保鲜)",
		hover = "Keep the food fresh.",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	{
		name = "LIGHT",
		label = "Light (保命微光)",
		hover = "Let the bag give off light.",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	{
		name = "BIGBAGWATER",
		label = "Rainproof(防雨)",
		hover = "Protect you from the rain.",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	{
		name = "BIGBAGPICK",
		label = "Fastpickup(快采)",
		hover = "Let you pick up items quickly.",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	{
		name = "HEATROCKTEMPERATURE",
		label = "HeatrockTemp(暖石升降温)",
		hover = "Change the heatrock's temperature automatically.",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	{
		name = "WALKSPEED",
		label = "Walk Speed (移速)",
		hover = "Walk speed while taking this bag.",
		options = {
			{ description = "Much Slower(超慢)", data = 0.5, },
			{ description = "Slower(慢)", data = 0.75, },
			{ description = "No Change(不变)", data = 1, },
			{ description = "Faster(快)", data = 1.25, },
			{ description = "Much Faster(超快)", data = 1.5, },
		},
		default = 0.75,
	},
	{
		name = "STACK",
		label = "Full Stack (自动堆满)",
		hover = "Get full stack when reopen the bag.",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	{
		name = "FRESH",
		label = "ReFresh (恢复新鲜)",
		hover = "ReFresh food and tools when reopen the bag.",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	-- {
		-- name = "GIVE",
		-- label = "Give Items (获得物品)",
		-- hover = "!!! SEVER ONLY !!!  Give Items Directly If Can't Build Something. !!! SEVER ONLY !!!",
		-- options = {
			-- { description = "Off", data = false, },
			-- { description = "On", data = true, },
		-- },
		-- default = false,
	-- },
	{
		name = "NICEBAGREFRESH",
		label = "Refresh on full moons(月圆刷新)",
		hover = "After opening, you can get the items with full durability or freshness",
		options =
		{
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},
	{
		name = "RECIPE",
		label = "Recipe (耗材)",
		hover = "Recipe cost.",
		options = {
			{ description = "Very Cheap(超便宜)", data = 1, },
			{ description = "Cheap(便宜)", data = 2, },
			{ description = "Normal(正常)", data = 3, },
			{ description = "Expensive(贵)", data = 4, },
			{ description = "More Expensive(超贵)", data = 5, },
		},
		default = 3,
	},
	{
		name = "CONTAINERDRAG_SWITCH",
		label = "BigBag Drag(背包拖拽)",
		hover = "After opening, you can drag the bigbag's UI",
		options =
		{
			{description = "Close(关闭)", data = false, hover = "关闭容器拖拽"},
			{description = "Open(F1开启)", data = "KEY_F1", hover = "默认按住F1拖动"},
			{description = "F2", data = "KEY_F2", hover = "按住F2拖动"},
			{description = "F3", data = "KEY_F3", hover = "按住F3拖动"},
			{description = "F4", data = "KEY_F4", hover = "按住F4拖动"},
			{description = "F5", data = "KEY_F5", hover = "按住F5拖动"},
			{description = "F6", data = "KEY_F6", hover = "按住F6拖动"},
			{description = "F7", data = "KEY_F7", hover = "按住F7拖动"},
			{description = "F8", data = "KEY_F8", hover = "按住F8拖动"},
			{description = "F9", data = "KEY_F9", hover = "按住F9拖动"},
		},
		default = "KEY_F1",
	},
	-- {
		-- name = "EASYSWITCH",
		-- label = "Easy switch(快捷开关)",
		-- hover = "After opening, you can open the bigbag quickly",
		-- options =
		-- {
			-- {description = "Close", data = false, hover = "关闭快捷开关"},
			-- {description = "O", data = "KEY_O", hover = "使用快捷键O"},
			-- {description = "0", data = "KEY_0", hover = "使用快捷键0"},
			-- {description = "F1", data = "KEY_F1", hover = "使用快捷键F1"},
			-- {description = "F2", data = "KEY_F2", hover = "使用快捷键F2"},
			-- {description = "F3", data = "KEY_F3", hover = "使用快捷键F3"},
			-- {description = "F4", data = "KEY_F4", hover = "使用快捷键F4"},
			-- {description = "F5", data = "KEY_F5", hover = "使用快捷键F5"},
			-- {description = "F6", data = "KEY_F6", hover = "使用快捷键F6"},
			-- {description = "F7", data = "KEY_F7", hover = "使用快捷键F7"},
			-- {description = "F8", data = "KEY_F8", hover = "使用快捷键F8"},
			-- {description = "F9", data = "KEY_F9", hover = "使用快捷键F9"},
		-- },
		-- default = "KEY_O",
	-- },
	{
		name = "BAGINBAG",
		label = "Bag in bag(包中包)",
		hover = "Bag in bag",
		options = {
			{ description = "Off(关闭)", data = false, },
			{ description = "On(开启)", data = true, },
		},
		default = false,
	},

}



--------------------------------------------------------------------------------------------------------------------------
