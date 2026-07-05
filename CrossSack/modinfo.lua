--------------------------------------------------------------------------------------------------------------------------
name = "CrossSack（挎包）"
author = "rainyNight"
version = "1.0.0"
description = "一个可调节大小的挎包，支持24/32/48/64格物品栏。\nA adjustable size backpack with 24/32/48/64 slots."

api_version = 10
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = {"CrossSack", "rainyNight", "backpack"}

forumthread = ""

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 0

configuration_options = {
    {
        name = "BAGSIZE",
        label = "Size of bag(背包大小)",
        hover = "Choose your size of crosssack.",
        options = {
            { description = "8x3 (24格)", data = 1, },
            { description = "8x4 (32格)", data = 2, },
            { description = "8x6 (48格)", data = 3, },
            { description = "8x8 (64格)", data = 4, },
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
        name = "CONTAINERDRAG_SWITCH",
        label = "Container Drag(背包拖拽)",
        hover = "After opening, right-click and drag to move the crosssack's UI",
        options =
        {
            {description = "Close(关闭)", data = false, hover = "关闭容器拖拽"},
            {description = "Open(开启)", data = true, hover = "右键拖拽移动UI"},
        },
        default = true,
    },
    {
        name = "BAGINBAG",
        label = "Bag in bag(包中包)",
        hover = "Put the backpack into the crosssack.",
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
}

--------------------------------------------------------------------------------------------------------------------------