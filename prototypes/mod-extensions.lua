-- Note: I probably can just import entity.lua, but better safe than sorry to just copy the function.
local function create_enemy_version(entity)
    if not entity then return nil end

    local mult = 0.05

    local enemy_entity = table.deepcopy(entity)
    enemy_entity.name = "castra-enemy-" .. entity.name
    enemy_entity.minable.result = nil
    local source = enemy_entity.energy_source
    if source and source.type == "electric" then
        if source.buffer_capacity then
            source.buffer_capacity = multiply_energy_amount(source.buffer_capacity, mult)
        end
        if source.input_flow_limit then
            source.input_flow_limit = multiply_energy_amount(source.input_flow_limit, mult)
        end
        if source.output_flow_limit then
            source.output_flow_limit = multiply_energy_amount(source.output_flow_limit, mult)
        end
        if source.drain then
            source.drain = multiply_energy_amount(source.drain, mult)
        end
    end
    if enemy_entity.energy_per_shot then
        enemy_entity.energy_per_shot = multiply_energy_amount(enemy_entity.energy_per_shot, mult)
    end
    local attack_param = enemy_entity.attack_parameters
    if attack_param then
        if attack_param.fluid_consumption then
            -- Reduce fluid consumption to 1% as they have a relatively small buffer
            attack_param.fluid_consumption = attack_param.fluid_consumption * 0.01
        end
        if attack_param.ammo_type then
            if attack_param.ammo_type.energy_consumption then
                attack_param.ammo_type.energy_consumption = multiply_energy_amount(
                attack_param.ammo_type.energy_consumption, mult)
            end
        end
    end
    return enemy_entity
end


if mods["Explosive_RC_Car"] and settings.startup["castra-edits-extend-RC"].value then
	local rc_clone = table.deepcopy(data.raw["unit"]["small-biter"])
	rc_clone.name = "castra-enemy-explosive-rc"
	rc_clone.icon = "__Explosive_RC_Car__/graphics/RCcar.png"
	-- Copy the relevant information from the explosive-rc-car mod
	rc_clone.max_health = data.raw["car"]["explosive-rc-car"].max_health
	rc_clone.factoriopedia_simulation = nil
	rc_clone.resistances = data.raw["car"]["explosive-rc-car"].resistances 
	rc_clone.absorptions_to_join_attack = { data = 500 }
	rc_clone.run_animation = data.raw["car"]["explosive-rc-car"].animation
	rc_clone.run_animation.tint = { r = 0, g = 0.5, b = 0.2, a = 1 }
	rc_clone.working_sound = data.raw["car"]["explosive-rc-car"].working_sound
	rc_clone.rotation_speed = data.raw["car"]["explosive-rc-car"].rotation_speed
	rc_clone.alternative_attacking_frame_sequence = nil
	rc_clone.corpse = data.raw["car"]["explosive-rc-car"].corpse
	rc_clone.dying_explosion = data.raw["car"]["explosive-rc-car"].dying_explosion
	rc_clone.dying_sound = nil
	rc_clone.walking_sound = nil
	rc_clone.water_reflection = nil
	rc_clone.movement_speed = 0.4
	rc_clone.collision_box = data.raw["car"]["explosive-rc-car"].collision_box
	rc_clone.selection_box = data.raw["car"]["explosive-rc-car"].selection_box
	
	rc_clone.attack_parameters = {
		type = "projectile",
		range = 3,
		cooldown = 100,
		cooldown_deviation = 0.1,
		ammo_category = "bullet",
		ammo_type = {
			target_type = "entity",
			action = {
			  category = "bullet",
			  action = {
				type = "direct",
				action_delivery = {
				  type = "instant",
				  target_effects = {
					{
					  type = "damage",
					  damage = { amount = 1, type = "physical" },
					  apply_damage_to_target = false 
					},
					-- Insta-kill the RC car to trigger the detonation
					{
					  type = "damage",
					  damage = { amount = 999999, type = "physical" },
					  force = "enemy"  
					}
				  }
				}
			  }
			}
		},
		animation = car.run_animation,
		range_mode = "bounding-box-to-bounding-box"
	}	

	data:extend({ rc_clone })	
end

--if mods["Mammoth-MK3"] then
--	local mammoth_clone = table.deepcopy(data.raw["unit"]["heavy-spitter"])
--end

if mods["PLORD_Prometheus_GrenadeLauncher"] and settings.startup["castra-edits-extend-GrenadeLauncher"].value then
	data:extend({
		create_enemy_version(data.raw["ammo-turret"]["PLORD_gl_40mm_turret"]),
	})
end

if mods["vtk-cannon-turret"] and settings.startup["castra-edits-extend-Cannons"].value then
	data:extend({
		create_enemy_version(data.raw["ammo-turret"]["vtk-cannon-turret"]),
		create_enemy_version(data.raw["ammo-turret"]["vtk-cannon-turret-heavy"]),
	})
end