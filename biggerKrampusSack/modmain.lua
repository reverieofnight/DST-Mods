-- 更大的坎普斯背包 modmain.lua
-- 功能：将坎普斯背包的容器格子从 2x7（14格）修改为 8x3（24格）

-- 声明自定义背包容器动画资源
Assets = {
    Asset("ANIM", "anim/ui_bigbag_3x8.zip"),
}

local containers = require "containers"

-- 修改坎普斯背包的容器布局为 8行 x 3列
local config = containers.params.krampus_sack
if config then
    -- 清空原有格子位置，重新生成 8x3 布局
    config.widget.slotpos = {}

    for y = 0, 7 do
        for x = 0, 2 do
            table.insert(config.widget.slotpos, GLOBAL.Vector3(-200 + x * 75, -75 * y + 240, 0))
        end
    end
    -- 将容器整体往左移
    config.widget.pos = GLOBAL.Vector3(-100, -100, 0)

    -- 替换为自定义背包容器背景动画
    config.widget.animbank = "ui_bigbag_3x8"
    config.widget.animbuild = "ui_bigbag_3x8"

    -- 更新全局最大格子数（防止格子数超出限制）
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, #config.widget.slotpos)
end
