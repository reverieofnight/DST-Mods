-- 更大的坎普斯背包 modmain.lua
-- 功能：将坎普斯背包的容器格子从 2x7（14格）修改为 3x8 或 4x8

-- 声明自定义背包容器动画资源
Assets = {
    Asset("ANIM", "anim/ui_bigbag_3x8.zip"),
    Asset("ANIM", "anim/ui_bigbag_4x8.zip"),
}

local containers = require "containers"

-- 读取用户配置
local BAGSIZE = GetModConfigData("BAGSIZE")
local NUM_COLS, NUM_ROWS
if BAGSIZE == "4x8" then
    NUM_COLS = 4
    NUM_ROWS = 8
else
    NUM_COLS = 3
    NUM_ROWS = 8
end

-- 修改坎普斯背包的容器布局
local config = containers.params.krampus_sack
if config then
    -- 清空原有格子位置，重新生成布局
    config.widget.slotpos = {}

    -- 根据列数计算居中偏移
    local col_offset
    if NUM_COLS == 4 then
        col_offset = -243   -- 4列居中：-243, -168, -93, -18
    else
        col_offset = -205   -- 3列居中：-205, -130, -55
    end

    for y = 0, NUM_ROWS - 1 do
        for x = 0, NUM_COLS - 1 do
            table.insert(config.widget.slotpos, GLOBAL.Vector3(col_offset + x * 75, -75 * y + 265, 0))
        end
    end

    -- 将容器整体往左移
    config.widget.pos = GLOBAL.Vector3(-50, 0, 0)

    -- 使用原版开/关动画骨架，自定义背包容器背景
    config.widget.animbank = "ui_krampusbag_2x8"
    if NUM_COLS == 4 then
        config.widget.animbuild = "ui_bigbag_4x8"
    else
        config.widget.animbuild = "ui_bigbag_3x8"
    end

    -- 更新全局最大格子数（防止格子数超出限制）
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, #config.widget.slotpos)
end
