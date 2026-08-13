name = '避茄针'
author = 'rainyNight'
version = '1.0.0'
description = '给避雷针和冰眼结晶器添加阻止亮茄在其范围内寄生的特性。\n\
核心原理：亮茄（致命亮茄）不会在已寄生的亮茄周围再次寄生（原版机制）。\n\
本 mod 让避雷针与冰眼结晶器被前来寄生的月灵误认为是已寄生的亮茄，\n\
从而不会选择其屏蔽范围内的植物作为寄生目标，保护基地植物。\n\
屏蔽范围与结构自身范围对齐：避雷针 40 单位、冰眼结晶器 35 单位、真亮茄 30 单位。'

api_version = 10
dst_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_filter_tags = {"LunarplantRod", "lightningrod", "brightshade"}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

forumthread = ""

priority = 0
