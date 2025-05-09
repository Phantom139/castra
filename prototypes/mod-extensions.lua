-- Note: I probably can just import entity.lua, but better safe than sorry to just copy the function.
local mod_functions = require("mod-functions")

if mods["Explosive_RC_Car"] and settings.startup["castra-edits-extend-RC"].value then

	local rc_clone = mod_functions.create_enemy_unit(data.raw["unit"]["small-biter"], data.raw["car"]["explosive-rc-car"])
	rc_clone.name = "castra-enemy-explosive-rc"
	rc_clone.icon = "__Explosive_RC_Car__/graphics/RCcar.png"
	-- Copy the relevant information from the explosive-rc-car mod
	rc_clone.absorptions_to_join_attack = { data = 500 }
	rc_clone.movement_speed = 0.3
	rc_clone.vision_distance = 50
	
	rc_clone.attack_parameters = {
		type = "projectile",
		range = 3,
		cooldown = 100,
		cooldown_deviation = 0.1,
		ammo_category = "bullet",
		ammo_type = {
		  category = "bullet",
		  action = {
			type = "direct",
			action_delivery = {
			  type = "instant",
			  source_effects = {
				{
				  type = "damage",
				  damage = { amount = 99999, type = "physical" },
				}
			  }
			}
		  }
		},
		animation = rc_clone.run_animation,
		range_mode = "bounding-box-to-bounding-box"
	}	

	data:extend({ rc_clone })	
end

--if mods["Mammoth-MK3"] then
--	local mammoth_clone = table.deepcopy(data.raw["unit"]["heavy-spitter"])
--end

if mods["PLORD_Prometheus_GrenadeLauncher"] and settings.startup["castra-edits-extend-GrenadeLauncher"].value then
	data:extend({
		mod_functions.create_enemy_version(data.raw["ammo-turret"]["PLORD_gl_40mm_turret"]),
	})
end

if mods["vtk-cannon-turret"] and settings.startup["castra-edits-extend-Cannons"].value then
	data:extend({
		mod_functions.create_enemy_version(data.raw["ammo-turret"]["vtk-cannon-turret"]),
		mod_functions.create_enemy_version(data.raw["ammo-turret"]["vtk-cannon-turret-heavy"]),
	})
end