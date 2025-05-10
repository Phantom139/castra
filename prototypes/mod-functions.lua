 -- Phantom139 Edit
 --  mod-functions.lua
 --  Moving shared functions across the prototype stage to one file for ease of access / use.
require("__base__.prototypes.entity.assemblerpipes")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.biter-animations")
 
local function createDataCollectorSpawn(item_name, icon)
    return {
        type = "unit",
        name = "data-collector-" .. item_name,
        icons =
        {
            -- data collector as the main icon and the icon as the sub
            {
                icon = "__castra__/graphics/fusion-reactor/fusion-reactor-icon.png",
                scale = 0.7,
                shift = { 0, -10 }
            },
            {
                icon = icon,
                scale = 0.5,
                shift = { -10, 10 }
            }
        },
        loot = {
            {
                item = item_name,
                probability = 1,
                count_min = 1,
                count_max = 1
            }
        },
        flags = { "placeable-player", "placeable-enemy", "placeable-off-grid", "not-repairable", "breaths-air" },
        max_health = 1,
        order = "n-a-a",
        subgroup = "enemies",
        resistances = {},
        healing_per_tick = 0.01,
        collision_box = { { -0.2, -0.2 }, { 0.2, 0.2 } },
        selection_box = { { -0.4, -0.7 }, { 0.4, 0.4 } },
        impact_category = "metal",
        vision_distance = 30,
        distance_per_frame = 0.125,
        distraction_cooldown = 300,
        absorptions_to_join_attack = { data = 100 },
        movement_speed = 0,
        run_animation =
        {
            layers =
            {
                {
                    filename = icon,
                    priority = "high",
                    width = 64,
                    height = 64,
                    frame_count = 1,
                    direction_count = 1,
                    shift = { 0, 0 },
                    scale = 1
                }
            }
        },

        attack_parameters =
        {
            type = "projectile",
            range = 0,
            cooldown = 0,
            cooldown_deviation = 0.15,
            ammo_category = "melee",
            ammo_type = {
                target_type = "entity",
                action =
                {
                    type = "direct",
                    action_delivery =
                    {
                        type = "instant",
                        target_effects =
                        {
                            type = "damage",
                            damage = { amount = 0, type = "physical" }
                        }
                    }
                }
            },
            animation = biterattackanimation(small_biter_scale, small_biter_tint1, small_biter_tint2),
            range_mode = "bounding-box-to-bounding-box"
        },
    }
end
 
local function multiply_energy_amount(energy_string, multiplier)
    -- Extract the number and unit from the energy string
    local number, unit = energy_string:match("^(%d+%.?%d*)(%a*)$")
    if not number or not unit then return energy_string end

    -- Convert the number to a number type and multiply it
    number = tonumber(number) * multiplier

    -- Return the new energy string
    return number .. unit
end

-- Create enemy copy of an entity and reduce energy consumption to 5%
local function create_enemy_version(entity)
    if not entity then return nil end

    local mult = 0.05

    local enemy_entity = table.deepcopy(entity)
    enemy_entity.name = "castra-enemy-" .. entity.name
	enemy_entity.subgroup = "enemies"
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

-- Create enemy copy of a vehicle entity for unit
local function create_enemy_unit(baseUnit, cloneEntity)
	if not baseUnit then return nil end
	if not cloneEntity then return nil end
	
	local newUnit = table.deepcopy(baseUnit)
	
	newUnit.max_health = cloneEntity.max_health
	newUnit.factoriopedia_simulation = nil
	newUnit.resistances = cloneEntity.resistances
	newUnit.run_animation = cloneEntity.animation
	newUnit.run_animation.tint = { r = 0, g = 0.5, b = 0.2, a = 1 }
	newUnit.working_sound = cloneEntity.working_sound
	newUnit.rotation_speed = cloneEntity.rotation_speed
	newUnit.alternative_attacking_frame_sequence = nil
	newUnit.corpse = cloneEntity.corpse
	newUnit.dying_explosion = cloneEntity.dying_explosion
	newUnit.dying_sound = nil
	newUnit.walking_sound = nil
	newUnit.water_reflection = nil
	newUnit.collision_box = cloneEntity.collision_box
	newUnit.selection_box = cloneEntity.selection_box	
	
	return newUnit
end

return {
    createDataCollectorSpawn = createDataCollectorSpawn,
    multiply_energy_amount = multiply_energy_amount,
    create_enemy_version = create_enemy_version,
    create_enemy_unit = create_enemy_unit
}