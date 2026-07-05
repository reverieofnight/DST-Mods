---------------------------------------------------------------------------------------------------------
--------------------------------------------修改玩家相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--玩家初始化
AddPlayerPostInit(function(inst)
--拖拽后坐标
	inst.haver_sack_drag_pos = GLOBAL.net_string(inst.GUID, "haver_sack_drag_pos", "haver_sack_drag_posdirty")
	if GLOBAL.TheWorld.ismastersim then
		--存储拖拽坐标数据
		local oldOnSaveFn=inst.OnSave
		local oldOnLoadFn=inst.OnLoad
		inst.OnSave=function(inst,data)
			data.haver_sackdargpos=inst.haver_sack_drag_pos:value()
			if oldOnSaveFn then
				oldOnSaveFn(inst,data)
			end
		end
		inst.OnLoad=function(inst,data)
			if data.haver_sackdargpos then
				inst.haver_sack_drag_pos:set(data.haver_sackdargpos)
			end
			if oldOnLoadFn then
				oldOnLoadFn(inst,data)
			end
		end
	end
end)