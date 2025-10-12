-- Note: I probably can just import entity.lua, but better safe than sorry to just copy the function.
local mod_functions = require("mod-functions")

if mods["Explosive_RC_Car"] and settings.startup["castra-edits-extend-RC"].value then

	local explosionClone = table.deepcopy(data.raw["explosion"]["rc-car-explosion"])
	explosionClone.name = "castra-enemy-rc-car-explosion"
	explosionClone.created_effect.action_delivery.target_effects[1].action.radius = 10
	data:extend({ explosionClone })	

	local rc_clone = mod_functions.create_enemy_unit(data.raw["unit"]["small-biter"], data.raw["car"]["explosive-rc-car"])
	rc_clone.name = "castra-enemy-explosive-rc"
	rc_clone.icon = "__Explosive_RC_Car__/graphics/RCcar.png"
	-- Copy the relevant information from the explosive-rc-car mod
	rc_clone.absorptions_to_join_attack = { data = 1500 }
	rc_clone.movement_speed = 0.33
	rc_clone.vision_distance = 50
	
	rc_clone.dying_explosion = "castra-enemy-rc-car-explosion"
	
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

	-- Create custom clones of the ammo types, otherwise it will one-shot anything due to how damage scales.
	local cannon_proj = table.deepcopy(data.raw["projectile"]["cannon-projectile"])
	cannon_proj.name = "castra-enemy-cannon-projectile"
	cannon_proj.flags = {}
	cannon_proj.direction_only = true
	cannon_proj.force_condition = "not-same"
	cannon_proj.action = {
	  type = "direct",
	  action_delivery = {
		type = "instant",
		target_effects = {
		  {
			type = "damage",
			damage = { amount = 25, type = "physical" },
			force = "enemy"
		  },
		  {
			type = "damage",
			damage = { amount = 10, type = "explosion" },
			force = "enemy"
		  },	  
		  {
			type = "create-entity",
			entity_name = "explosion",
			force = "enemy"
		  }
		}
	  }
	}		

	local u_cannon_proj = table.deepcopy(data.raw["projectile"]["uranium-cannon-projectile"])
	u_cannon_proj.name = "castra-enemy-uranium-cannon-projectile"
	u_cannon_proj.flags = {}
	u_cannon_proj.direction_only = true -- make projectile vectorized instead of exploding on target
	u_cannon_proj.force_condition = "not-same"
	u_cannon_proj.action = {
	  type = "direct",
	  action_delivery = {
		type = "instant",
		target_effects = {
		  {
			type = "damage",
			damage = { amount = 35, type = "physical" },
			force = "enemy"
		  },
		  {
			type = "damage",
			damage = { amount = 15, type = "explosion" },
			force = "enemy"
		  },	  
		  {
			type = "create-entity",
			entity_name = "explosion",
			force = "enemy"
		  }
		}
	  }
	}	

	local explosive_cannon_proj = table.deepcopy(data.raw["projectile"]["explosive-cannon-projectile"])
	explosive_cannon_proj.name = "castra-enemy-explosive-cannon-projectile"
	explosive_cannon_proj.flags = {}
	explosive_cannon_proj.direction_only = true
	explosive_cannon_proj.force_condition = "not-same"
	explosive_cannon_proj.action = {
	  type = "direct",
	  action_delivery = {
		type = "instant",
		target_effects = {
		  {
			type = "damage",
			damage = { amount = 15, type = "physical" },
			force = "enemy"
		  },
		  {
			type = "damage",
			damage = { amount = 40, type = "explosion" },
			force = "enemy"
		  },	  
		  {
			type = "create-entity",
			entity_name = "explosion",
			force = "enemy"
		  }
		}
	  }
	}		

	local explosive_u_cannon_proj = table.deepcopy(data.raw["projectile"]["explosive-uranium-cannon-projectile"])
	explosive_u_cannon_proj.name = "castra-enemy-explosive-uranium-cannon-projectile"
	explosive_u_cannon_proj.flags = {}
	explosive_u_cannon_proj.direction_only = true
	explosive_u_cannon_proj.force_condition = "not-same"
	explosive_u_cannon_proj.action = {
	  type = "direct",
	  action_delivery = {
		type = "instant",
		target_effects = {
		  {
			type = "damage",
			damage = { amount = 20, type = "physical" },
			force = "enemy"
		  },
		  {
			type = "damage",
			damage = { amount = 50, type = "explosion" },
			force = "enemy"
		  },	  
		  {
			type = "create-entity",
			entity_name = "explosion",
			force = "enemy"
		  }
		}
	  }
	}	
	
	data:extend({
		cannon_proj,
		u_cannon_proj,
		explosive_cannon_proj,
		explosive_u_cannon_proj,
	})
	
	if settings.startup["vtk-cannon-turret-ammo-use"].value == 1 or 3 then
		-- Copy the base recipes
		local cannon_mag = table.deepcopy(data.raw["ammo"]["cannon-shell-magazine"])
		local u_cannon_mag = table.deepcopy(data.raw["ammo"]["uranium-cannon-shell-magazine"])
		local expl_cannon_mag = table.deepcopy(data.raw["ammo"]["explosive-cannon-shell-magazine"])
		local expl_u_cannon_mag = table.deepcopy(data.raw["ammo"]["explosive-uranium-cannon-shell-magazine"])
		-- Change the projectiles to their modded versions
		cannon_mag.name = "castra-enemy-cannon-shell-magazine"
		u_cannon_mag.name = "castra-enemy-uranium-cannon-shell-magazine"
		expl_cannon_mag.name = "castra-enemy-explosive-cannon-shell-magazine"
		expl_u_cannon_mag.name = "castra-enemy-explosive-uranium-cannon-shell-magazine"
		
		cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-cannon-projectile"
		u_cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-uranium-cannon-projectile"
		expl_cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-explosive-cannon-projectile"
		expl_u_cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-explosive-uranium-cannon-projectile"
		
		data:extend({
			cannon_mag,
			u_cannon_mag,
			expl_cannon_mag,
			expl_u_cannon_mag,
		})		
	else
		-- Copy the base recipes
		local cannon_mag = table.deepcopy(data.raw["ammo"]["cannon-shell"])
		local u_cannon_mag = table.deepcopy(data.raw["ammo"]["uranium-cannon-shell"])
		local expl_cannon_mag = table.deepcopy(data.raw["ammo"]["explosive-cannon-shell"])
		local expl_u_cannon_mag = table.deepcopy(data.raw["ammo"]["explosive-uranium-cannon-shell"])
		-- Change the projectiles to their modded versions
		cannon_mag.name = "castra-enemy-cannon-shell"
		u_cannon_mag.name = "castra-enemy-uranium-cannon-shell"
		expl_cannon_mag.name = "castra-enemy-explosive-cannon-shell"
		expl_u_cannon_mag.name = "castra-enemy-explosive-uranium-cannon-shell"
		
		cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-cannon-projectile"
		u_cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-uranium-cannon-projectile"
		expl_cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-explosive-cannon-projectile"
		expl_u_cannon_mag.ammo_type.action.action_delivery.projectile = "castra-enemy-explosive-uranium-cannon-projectile"
		
		data:extend({
			cannon_mag,
			u_cannon_mag,
			expl_cannon_mag,
			expl_u_cannon_mag,
		})	
	end	
	
	-- Create "ghost" recipes for the special enemy variants so they can use them when the respective technologies are unlocked.
	--  The players themselves will not see these recipes, and the technologies are updated to add these recipes to them.
	if settings.startup["vtk-cannon-turret-ammo-use"].value == 1 or 3 then
		local cannon_mag = table.deepcopy(data.raw["recipe"]["cannon-shell-magazine"])
		local u_cannon_mag = table.deepcopy(data.raw["recipe"]["uranium-cannon-shell-magazine"])
		local expl_cannon_mag = table.deepcopy(data.raw["recipe"]["explosive-cannon-shell-magazine"])
		local expl_u_cannon_mag = table.deepcopy(data.raw["recipe"]["explosive-uranium-cannon-shell-magazine"])		
		
		cannon_mag.name = "castra-enemy-cannon-shell-magazine"
		u_cannon_mag.name = "castra-enemy-uranium-cannon-shell-magazine"
		expl_cannon_mag.name = "castra-enemy-explosive-cannon-shell-magazine"
		expl_u_cannon_mag.name = "castra-enemy-explosive-uranium-cannon-shell-magazine"
		
		cannon_mag.results[1].name = "castra-enemy-cannon-shell-magazine"
		u_cannon_mag.results[1].name = "castra-enemy-uranium-cannon-shell-magazine"
		expl_cannon_mag.results[1].name = "castra-enemy-explosive-cannon-shell-magazine"
		expl_u_cannon_mag.results[1].name = "castra-enemy-explosive-uranium-cannon-shell-magazine"
		
		cannon_mag.hidden = true
		cannon_mag.hidden_in_factoriopedia = true
		cannon_mag.hide_from_signal_gui = true
		cannon_mag.hide_from_player_crafting = true
		cannon_mag.hide_from_stats = true

		u_cannon_mag.hidden = true
		u_cannon_mag.hidden_in_factoriopedia = true
		u_cannon_mag.hide_from_signal_gui = true
		u_cannon_mag.hide_from_player_crafting = true
		u_cannon_mag.hide_from_stats = true

		expl_cannon_mag.hidden = true
		expl_cannon_mag.hidden_in_factoriopedia = true
		expl_cannon_mag.hide_from_signal_gui = true
		expl_cannon_mag.hide_from_player_crafting = true
		expl_cannon_mag.hide_from_stats = true
		
		expl_u_cannon_mag.hidden = true
		expl_u_cannon_mag.hidden_in_factoriopedia = true
		expl_u_cannon_mag.hide_from_signal_gui = true
		expl_u_cannon_mag.hide_from_player_crafting = true
		expl_u_cannon_mag.hide_from_stats = true
		
		data:extend({
			cannon_mag,
			u_cannon_mag,
			expl_cannon_mag,
			expl_u_cannon_mag,
		})			
	else
		local cannon_mag = table.deepcopy(data.raw["recipe"]["cannon-shell"])
		local u_cannon_mag = table.deepcopy(data.raw["recipe"]["uranium-cannon-shell"])
		local expl_cannon_mag = table.deepcopy(data.raw["recipe"]["explosive-cannon-shell"])
		local expl_u_cannon_mag = table.deepcopy(data.raw["recipe"]["explosive-uranium-cannon-shell"])		
		
		cannon_mag.name = "castra-enemy-cannon-shell"
		u_cannon_mag.name = "castra-enemy-uranium-cannon-shell"
		expl_cannon_mag.name = "castra-enemy-explosive-cannon-shell"
		expl_u_cannon_mag.name = "castra-enemy-explosive-uranium-cannon-shell"
		
		cannon_mag.results[1].name = "castra-enemy-cannon-shell"
		u_cannon_mag.results[1].name = "castra-enemy-uranium-cannon-shell"
		expl_cannon_mag.results[1].name = "castra-enemy-explosive-cannon-shell"
		expl_u_cannon_mag.results[1].name = "castra-enemy-explosive-uranium-cannon-shell"
		
		cannon_mag.hidden = true
		cannon_mag.hidden_in_factoriopedia = true
		cannon_mag.hide_from_signal_gui = true
		cannon_mag.hide_from_player_crafting = true
		cannon_mag.hide_from_stats = true

		u_cannon_mag.hidden = true
		u_cannon_mag.hidden_in_factoriopedia = true
		u_cannon_mag.hide_from_signal_gui = true
		u_cannon_mag.hide_from_player_crafting = true
		u_cannon_mag.hide_from_stats = true

		expl_cannon_mag.hidden = true
		expl_cannon_mag.hidden_in_factoriopedia = true
		expl_cannon_mag.hide_from_signal_gui = true
		expl_cannon_mag.hide_from_player_crafting = true
		expl_cannon_mag.hide_from_stats = true
		
		expl_u_cannon_mag.hidden = true
		expl_u_cannon_mag.hidden_in_factoriopedia = true
		expl_u_cannon_mag.hide_from_signal_gui = true
		expl_u_cannon_mag.hide_from_player_crafting = true
		expl_u_cannon_mag.hide_from_stats = true
		
		data:extend({
			cannon_mag,
			u_cannon_mag,
			expl_cannon_mag,
			expl_u_cannon_mag,
		})		
	end

end