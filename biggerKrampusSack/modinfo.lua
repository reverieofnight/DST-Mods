name = "更大的坎普斯背包"
description = "将坎普斯背包的格子大小修改为3x8（共24格）"
author = "YourName"
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
            {description = "3x8 (24格)", data = "3x8"},
            {description = "4x8 (32格)", data = "4x8"},
        },
        default = "3x8",
    },
}
