require("__base__.prototypes.entity.assemblerpipes")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.biter-animations")

local mod_functions = require("mod-functions")

local pipe_pic = assembler3pipepictures()
local pipecoverpic = pipecoverspictures()

local box48 = { { -2.4, -2.4 }, { 2.4, 2.4 } }

local box3 = { { -1.5, -1.5 }, { 1.5, 1.5 } }
local box4 = { { -2, -2 }, { 2, 2 } }
local box5 = { { -2.5, -2.5 }, { 2.5, 2.5 } }
local box6 = { { -3, -3 }, { 3, 3 } }
local box7 = { { -3.5, -3.5 }, { 3.5, 3.5 } }
local box8 = { { -4, -4 }, { 4, 4 } }
local box11 = { { -5.5, -5.5 }, { 5.5, 5.5 } }

-- Create enemy projectile variants
local enemy_shell = table.deepcopy(data.raw["projectile"]["cannon-projectile"])
enemy_shell.name = "castra-enemy-shell"
enemy_shell.action = {
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
data:extend({ enemy_shell })

-- Create Mod Entities
data:extend({
    {
        type = "assembling-machine",
        name = "forge",
        icon = "__castra__/graphics/atom-forge/atom-forge-icon.png",
        icon_size = 64,
        collision_box = { { -2.7, -2.7 }, { 2.7, 2.7 } },
        selection_box = { { -3, -3 }, { 3, 3 } },
        flags = { "placeable-neutral", "player-creation" },
        minable = { hardness = 0.2, mining_time = 1, result = "forge" },
        max_health = 2000,
        corpse = "big-remnants",
        dying_explosion = "big-explosion",
        resistances = { { type = "poison", percent = 90 } },
        effect_receiver = { base_effect = { productivity = 0.25, quality = 1 } },
        fluid_boxes = {
            {
                production_type = "input",
                volume = 1000,
                pipe_picture = pipe_pic,
                pipe_covers = pipecoverpic,
                pipe_connections = { { direction = defines.direction.north, flow_direction = "input", position = { -0.5, -2.5 } } },
                secondary_draw_orders = { north = -1 }
            },
            {
                production_type = "output",
                volume = 1000,
                pipe_picture = pipe_pic,
                pipe_covers = pipecoverpic,
                pipe_connections = { { direction = defines.direction.south, flow_direction = "output", position = { -0.5, 2.5 } } },
                secondary_draw_orders = { north = -1 }
            }
        },
        fluid_boxes_off_when_no_fluid_recipe = true,
        graphics_set = {
            animation = {
                layers = {
                    {
                        filename = "__castra__/graphics/atom-forge/atom-forge-hr-shadow.png",
                        priority = "high",
                        width = 900,
                        height = 500,
                        frame_count = 1,
                        line_length = 1,
                        repeat_count = 64,
                        draw_as_shadow = true,
                        animation_speed = 0.3,
                        scale = 0.5,
                        shift = { 0, -1 }
                    },
                    {
                        priority = "high",
                        width = 400,
                        height = 480,
                        animation_speed = 0.3,
                        scale = 0.5,
                        filename = "__castra__/graphics/atom-forge/atom-forge-hr-animation-1.png",
                        frame_count = 64,
                        line_length = 8,
                        shift = { 0, -1 }
                    }
                }
            },
            reset_animation_when_frozen = true
        },
        crafting_categories = { "castra-crafting", "castra-chemistry", "castra-electromagnetics", "castra-forge" },
        crafting_speed = 2,
        impact_category = "metal",
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = {
                pollution = 10
            }
        },
        circuit_connector = circuit_connector_definitions["assembling-machine"],
        circuit_wire_max_distance = 20,
        energy_usage = "3.6MW",
        ingredient_count = 6,
        module_slots = 6,
        allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" },
        heating_energy = feature_flags["freezing"] and "100kW" or nil,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        squeak_behaviour = false,
        working_sound = {
            audible_distance_modifier = 0.5,
            fade_in_ticks = 4,
            fade_out_ticks = 20,
            sound = {
                filename = "__base__/sound/assembling-machine-t3-1.ogg",
                volume = 0.45
            }
        }
    },
    {
        type = "unit-spawner",
        name = "data-collector",
        icon = "__castra__/graphics/fusion-reactor/fusion-reactor-icon.png",
        flags = { "placeable-player", "placeable-enemy", "not-repairable" },
        max_health = 7500,
        order = "f-g-b",
        subgroup = "enemies",
        resistances =
        {
            {
                type = "physical",
                decrease = 20,
                percent = 10
            },
            {
                type = "explosion",
                decrease = 10,
                percent = 40
            },
            {
                type = "laser",
                decrease = 20,
                percent = 65
            },
            {
                type = "poison",
                percent = 100
            }
        },
        working_sound = {
            audible_distance_modifier = 0.5,
            fade_in_ticks = 4,
            fade_out_ticks = 20,
            sound = {
                filename = "__base__/sound/assembling-machine-t3-1.ogg",
                volume = 0.45
            }
        },
        healing_per_tick = 20 / 60.0,
        collision_box = { { -2.7, -2.7 }, { 2.7, 2.7 } },
        map_generator_bounding_box = { { -3.7, -3.2 }, { 3.7, 3.2 } },
        selection_box = { { -3, -3 }, { 3, 3 } },
        impact_category = "metal",
        -- in ticks per 1 pu
        absorptions_per_second = { data = { absolute = 20, proportional = 0.01 } },
        max_count_of_owned_units = 12,
        max_friends_around_to_spawn = 5,
        graphics_set = {
            animations = {
                {
                    layers = {
                        {
                            filename = "__castra__/graphics/fusion-reactor/fusion-reactor-hr-shadow.png",
                            priority = "high",
                            width = 700,
                            height = 600,
                            frame_count = 1,
                            line_length = 1,
                            repeat_count = 60,
                            draw_as_shadow = true,
                            animation_speed = 0.3,
                            scale = 0.5,
                        },
                        {
                            priority = "high",
                            width = 400,
                            height = 400,
                            animation_speed = 0.3,
                            scale = 0.5,
                            filename =
                            "__castra__/graphics/fusion-reactor/fusion-reactor-hr-animation.png",
                            frame_count = 60,
                            line_length = 8
                        },
                        {
                            priority = "high",
                            width = 400,
                            height = 400,
                            animation_speed = 0.3,
                            scale = 0.5,
                            filename =
                            "__castra__/graphics/fusion-reactor/fusion-reactor-hr-animation-emission.png",
                            frame_count = 60,
                            line_length = 8,
                            draw_as_glow = true,
                            blend_mode = "additive"
                        }
                    }
                }
            },
            reset_animation_when_frozen = true
        },
        spawning_cooldown = { 480, 960 },
        spawning_radius = 6,
        spawning_spacing = 2,
        max_spawn_shift = 0,
        max_richness_for_spawn_shift = 100,
        call_for_help_radius = 0,
        result_units = (function()
            local res = {}
			local i = 1
			
            res[i] = { "data-collector-electronic-circuit", { { 0.0, 0.1 }, { 0.7, 0.05 }, { 1.0, 0.0 } } }; 
			i = i + 1
            
			res[i] = { "data-collector-advanced-circuit", { { 0.0, 0.0 }, { 0.4, 0.0 }, { 0.9, 0.4 } } };
			i = i + 1
			
            res[i] = { "data-collector-millerite", { { 0.0, 0.4 }, { 0.3, 0.2 }, { 0.6, 0.1 } } };
			i = i + 1
			
            res[i] = { "data-collector-gunpowder", { { 0.0, 0.8 }, { 0.5, 0.5 }, { 0.8, 0.0 } } };
			i = i + 1
			
            res[i] = { "data-collector-low-density-structure", { { 0.0, 0.15 }, { 0.2, 0.2 }, { 1.0, 0.3 } } };
			i = i + 1
			
            res[i] = { "data-collector-electric-engine-unit", { { 0.0, 0.05 }, { 0.2, 0.1 }, { 1.0, 0.1 } } };
			i = i + 1
			
            res[i] = { "data-collector-castra-data", { { 0.0, 0.1 }, { 0.5, 0.4 }, { 1.0, 1.0 } } };
			i = i + 1
			
			if settings.startup["castra-enemy-add-cars"].value then
				res[i] = { "castra-enemy-car", { { 0.0, 0.0 }, { 0.25, 0.075 }, { 0.4, 0.125 }, { 0.65, 0.2 }, { 1.0, 0.25 } } };
				i = i + 1		
			end			
			
            res[i] = { "castra-enemy-tank", { { 0.0, 0.0 }, { 0.4, 0.0 }, { 0.405, 0.05 }, { 1.0, 0.1 } } };
			i = i + 1
			
			if mods["Explosive_RC_Car"] and settings.startup["castra-edits-extend-RC"].value then
				res[i] = { "castra-enemy-explosive-rc", { { 0.0, 0.0 }, { 0.5, 0.005 }, { 0.65, 0.01 }, { 1.0, 0.05 } } };
				i = i + 1		
			end
			
            return res
        end)(),
        loot = {
            {
                item = "advanced-circuit",
                probability = 1,
                count_min = 5,
                count_max = 10
            },
            {
                item = "nickel-plate",
                probability = 1,
                count_min = 6,
                count_max = 20
            },
            {
                item = "electronic-circuit",
                probability = 1,
                count_min = 10,
                count_max = 30
            },
            {
                item = "low-density-structure",
                probability = 1,
                count_min = 5,
                count_max = 12
            },
            {
                item = "electric-engine-unit",
                probability = 1,
                count_min = 3,
                count_max = 8
            }
        }
    },
    mod_functions.createDataCollectorSpawn("electronic-circuit", "__base__/graphics/icons/electronic-circuit.png"),
    mod_functions.createDataCollectorSpawn("advanced-circuit", "__base__/graphics/icons/advanced-circuit.png"),
    mod_functions.createDataCollectorSpawn("millerite", "__castra__/graphics/icons/millerite.png"),
    mod_functions.createDataCollectorSpawn("gunpowder", "__castra__/graphics/icons/gunpowder.png"),
    mod_functions.createDataCollectorSpawn("low-density-structure", "__base__/graphics/icons/low-density-structure.png"),
    mod_functions.createDataCollectorSpawn("electric-engine-unit", "__base__/graphics/icons/electric-engine-unit.png"),
    mod_functions.createDataCollectorSpawn("castra-data", "__castra__/graphics/icons/castra-data.png"),
    {
        -- combat-roboport
        type = "container",
        name = "combat-roboport",
        icon = "__castra__/graphics/icons/combat-roboport.png",
        flags = { "placeable-player", "player-creation" },
        minable = { hardness = 0.2, mining_time = 1, result = "combat-roboport" },
        max_health = 2000,
        order = "f-g-b",
        corpse = "roboport-remnants",
        dying_explosion = "gun-turret-explosion",
        inventory_size = 1,
        surface_conditions = {
            {
                property = "gravity",
                min = 0.1
            }
        },
        resistances =
        {
            {
                type = "physical",
                decrease = 5,
                percent = 40
            },
            {
                type = "explosion",
                decrease = 40
            },
            {
                type = "fire",
                decrease = 3,
                percent = 30
            },
            {
                type = "electric",
                decrease = 10,
                percent = 50
            }
        },
        working_sound = {
            audible_distance_modifier = 0.5,
            fade_in_ticks = 4,
            fade_out_ticks = 20,
            sound = {
                filename = "__base__/sound/roboport-working.ogg",
                volume = 0.45
            }
        },
        picture = {
            layers = {
                {
                    filename = "__castra__/graphics/fusion-reactor/fusion-reactor-hr-shadow.png",
                    priority = "high",
                    width = 700,
                    height = 600,
                    frame_count = 1,
                    line_length = 1,
                    repeat_count = 60,
                    draw_as_shadow = true,
                    animation_speed = 0.3,
                    scale = 0.5,
                },
                {
                    priority = "high",
                    width = 400,
                    height = 400,
                    animation_speed = 0.3,
                    scale = 0.5,
                    filename =
                    "__castra__/graphics/fusion-reactor/fusion-reactor-hr-animation.png",
                    frame_count = 60,
                    line_length = 8
                },
                {
                    priority = "high",
                    width = 400,
                    height = 400,
                    animation_speed = 0.3,
                    scale = 0.5,
                    filename =
                    "__castra__/graphics/entity/combat-roboport/combat-roboport-hr-animation-emission.png",
                    frame_count = 60,
                    line_length = 8,
                    draw_as_glow = true,
                    blend_mode = "additive"
                }
            }
        },
        collision_box = { { -2.2, -2.2 }, { 2.2, 2.2 } },
        selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } },
        circuit_connector = circuit_connector_definitions["chest"],
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        quality_affects_inventory_size = false,
        is_military_target = true
    },
    {
        type = "assembling-machine",
        name = "jammed-data-collector",
        icons = {
            {
                icon = "__castra__/graphics/fusion-reactor/fusion-reactor-icon.png"
            },
            {
                icon = "__castra__/graphics/fusion-reactor/fusion-reactor-icon.png",
                tint = { r = 0.5, g = 0.1, b = 0.5, a = 0.3 }
            }
        },
        flags = { "placeable-neutral", "placeable-player", "player-creation", "not-repairable", "not-deconstructable" },
        max_health = 7500,
        create_ghost_on_death = false,
        show_recipe_icon = false,
        production_health_effect =
        {
            not_producing = -50,
            producing = 50
        },
        ignore_output_full = true,
        dying_trigger_effect =
        {
            type = "create-entity",
            entity_name = "data-collector",
            as_enemy = true,
            ignore_no_enemies_mode = true,
            protected = true,
            trigger_created_entity = true
        },
        resistances = {
            {
                type = "physical",
                decrease = 20,
                percent = 10
            },
            {
                type = "explosion",
                decrease = 10,
                percent = 40
            },
            {
                type = "laser",
                decrease = 20,
                percent = 65
            },
            {
                type = "poison",
                percent = 100
            }
        },
        working_sound = {
            audible_distance_modifier = 0.5,
            fade_in_ticks = 4,
            fade_out_ticks = 20,
            sound = {
                filename = "__base__/sound/assembling-machine-t3-1.ogg",
                volume = 0.45
            }
        },
        collision_box = { { -2.7, -2.7 }, { 2.7, 2.7 } },
        map_generator_bounding_box = { { -3.7, -3.2 }, { 3.7, 3.2 } },
        selection_box = { { -3, -3 }, { 3, 3 } },
        impact_category = "metal",
        graphics_set = {
            animation = {
                layers = {
                    {
                        filename = "__castra__/graphics/fusion-reactor/fusion-reactor-hr-shadow.png",
                        priority = "high",
                        width = 700,
                        height = 600,
                        frame_count = 1,
                        line_length = 1,
                        repeat_count = 60,
                        draw_as_shadow = true,
                        animation_speed = 0.3,
                        scale = 0.5,
                    },
                    {
                        priority = "high",
                        width = 400,
                        height = 400,
                        animation_speed = 0.3,
                        scale = 0.5,
                        filename =
                        "__castra__/graphics/fusion-reactor/fusion-reactor-hr-animation.png",
                        frame_count = 60,
                        line_length = 8
                    },
                    {
                        priority = "high",
                        width = 400,
                        height = 400,
                        animation_speed = 0.3,
                        scale = 0.5,
                        filename =
                        "__castra__/graphics/fusion-reactor/fusion-reactor-hr-animation.png",
                        frame_count = 60,
                        line_length = 8,
                        tint = { r = 0.5, g = 0.1, b = 0.5, a = 0.3 }
                    },
                    {
                        priority = "high",
                        width = 400,
                        height = 400,
                        animation_speed = 0.3,
                        scale = 0.5,
                        filename =
                        "__castra__/graphics/fusion-reactor/fusion-reactor-hr-animation-emission.png",
                        frame_count = 60,
                        line_length = 8,
                        draw_as_glow = true,
                        blend_mode = "additive",
                        tint = { r = 0.5, g = 0.1, b = 0.5, a = 0.3 }
                    }
                }
            },
            reset_animation_when_frozen = true
        },
        crafting_categories = { "jammed-data-collector-process" },
        fixed_recipe = "jammed-data-collector-process",
        crafting_speed = 1,
        energy_source =
        {
            type = "burner",
            fuel_categories = { "castra-jammer" },
            effectivity = 1,
            fuel_inventory_size = 1,
            emissions_per_minute = { data = -1000 },
            burner_usage = "castra-jammer",
            light_flicker =
            {
                minimum_intensity = 0,
                maximum_intensity = 0,
                derivation_change_frequency = 0,
                derivation_change_deviation = 0,
                border_fix_speed = 0,
                minimum_light_size = 0,
                light_intensity_to_size_coefficient = 0,
                color = { 0, 0, 0, 1 }
            }
        },
        energy_usage = "800kW",
        module_slots = 4,
        allowed_effects = { "quality" },
        allowed_module_categories = { "quality" },
        enable_logistic_control_behavior = false,
        surface_conditions =
        {
            {
                property = "pressure",
                min = 1254,
                max = 1254
            }
        },
    }
})

-- Create a car enemy based on the small-spitter
local car = mod_functions.create_enemy_unit(data.raw["unit"]["small-spitter"], data.raw["car"]["car"])
car.name = "castra-enemy-car"
car.icon = "__base__/graphics/icons/car.png"
car.resistances = {
    {
        type = "physical",
        decrease = 5,
        percent = 30
    },
    {
        type = "explosion",
        decrease = 5,
        percent = 50
    },
    {
        type = "fire",
        percent = 95
    },
    {
        type = "poison",
        percent = 95
    },
}
-- Additiontal parameters
car.absorptions_to_join_attack = { data = 250 }
car.movement_speed = 0.28
car.attack_parameters = {
    type = "projectile",
    range = 17,
    cooldown = 10,
    cooldown_deviation = 0.1,
    ammo_category = "bullet",
    ammo_type = {
        target_type = "entity",
        action =
        {
            type = "direct",
            action_delivery =
            {
                type = "instant",
                source_effects =
                {
                    type = "create-explosion",
                    entity_name = "explosion-gunshot"
                },
                target_effects =
                {
                    {
                        type = "create-entity",
                        entity_name = "explosion-hit",
                        offsets = { { 0, 1 } },
                        offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } }
                    },
                    {
                        type = "damage",
                        damage = { amount = 11, type = "physical" }
                    },
                    {
                        type = "activate-impact",
                        deliver_category = "bullet"
                    }
                }
            }
        }
	},
    animation = car.run_animation,
    range_mode = "bounding-box-to-bounding-box"	
}

data:extend({ car })

-- Create a tank enemy based on the medium-spitter
local tank = mod_functions.create_enemy_unit(data.raw["unit"]["medium-spitter"], data.raw["car"]["tank"])
tank.name = "castra-enemy-tank"
tank.icon = "__base__/graphics/icons/tank.png"
tank.resistances = {
    {
        type = "physical",
        decrease = 10,
        percent = 65
    },
    {
        type = "explosion",
        decrease = 10,
        percent = 65
    },
    {
        type = "fire",
        percent = 99
    },
    {
        type = "poison",
        percent = 99
    },
    {
        type = "laser",
        percent = 90
    },
    {
        type = "electric",
        percent = 65
    }
}
tank.absorptions_to_join_attack = { data = 1000 }
tank.movement_speed = 0.13
tank.attack_parameters = {
	type = "projectile",
	range = 24,
	cooldown = 90,
	cooldown_deviation = 0.15,
	ammo_category = "cannon-shell", 
	ammo_type = {
	category = "cannon-shell",
	target_type = "entity",
	action = {
	type = "direct",
		action_delivery = {
			type = "projectile",
				projectile = "castra-enemy-shell",
				starting_speed = 1,
				max_range = 30
			}
		}
	},
	animation = tank.run_animation, 
	range_mode = "bounding-box-to-bounding-box"
}

data:extend({ tank })

-- Create enemy versions of laser-turret, railgun, flamethrower
data:extend({
    mod_functions.create_enemy_version(data.raw["electric-turret"]["laser-turret"]),
    mod_functions.create_enemy_version(data.raw["ammo-turret"]["railgun-turret"]),
    mod_functions.create_enemy_version(data.raw["fluid-turret"]["flamethrower-turret"]),
    mod_functions.create_enemy_version(data.raw["electric-turret"]["tesla-turret"]),
})