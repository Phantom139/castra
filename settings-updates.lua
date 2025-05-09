-- Tweak settings based on mods that are included
if not mods["Cerys-Moon-of-Fulgora"] then
	data.raw["bool-setting"]["castra-edits-claim-engine-productivity"].forced_value = false
	data.raw["bool-setting"]["castra-edits-claim-engine-productivity"].hidden = true
end

if not mods["Explosive_RC_Car"] then
	data.raw["bool-setting"]["castra-edits-extend-RC"].forced_value = false
	data.raw["bool-setting"]["castra-edits-extend-RC"].hidden = true
end

if not mods["PLORD_Prometheus_GrenadeLauncher"] then 
	data.raw["bool-setting"]["castra-edits-extend-GrenadeLauncher"].forced_value = false
	data.raw["bool-setting"]["castra-edits-extend-GrenadeLauncher"].hidden = true
end

if not mods["vtk-cannon-turret"] then 
	data.raw["bool-setting"]["castra-edits-extend-Cannons"].forced_value = false
	data.raw["bool-setting"]["castra-edits-extend-Cannons"].hidden = true
end