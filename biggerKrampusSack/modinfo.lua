name = "更大的坎普斯背包"
description = "可配置坎普斯背包格子大小：原始2x7 / 3x8 / 4x8"
author = "RainyNight"
version = "1.0.0"
api_version = 10
api_version_dst = 10
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_only_mod = false
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- 兼容性
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false

configuration_options = {
    {
        name = "BAGSIZE",
        label = "背包大小",
        hover = "选择坎普斯背包的格子布局",
        options = {
            {description = "原始 2x7 (14格)", data = "2x7"},
            {description = "3x8 (24格)", data = "3x8"},
            {description = "4x8 (32格)", data = "4x8"},
        },
        default = "3x8",
    },
    {
        name = "CONTAINERDRAG",
        label = "容器拖拽",
        hover = "开启后可以右键拖拽背包容器UI到任意位置",
        options = {
            {description = "关闭", data = false},
            {description = "开启", data = true},
        },
        default = false,
    },
}
