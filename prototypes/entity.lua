require("__base__.prototypes.entity.assemblerpipes")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.biter-animations")

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
        max_health = 12000,
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
                percent = 95
            },
            {
                type = "laser",
                decrease = 20,
                percent = 90
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
        max_count_of_owned_units = 10,
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
            res[1] = { "data-collector-electronic-circuit", { { 0.0, 0.1 }, { 0.7, 0.05 }, { 1.0, 0.0 } } }
            res[2] = { "data-collector-advanced-circuit", { { 0.0, 0.0 }, { 0.4, 0.0 }, { 0.9, 0.4 } } }
            res[3] = { "data-collector-millerite", { { 0.0, 0.4 }, { 0.3, 0.2 }, { 0.6, 0.1 } } }
            res[4] = { "data-collector-gunpowder", { { 0.0, 0.8 }, { 0.5, 0.5 }, { 0.8, 0.0 } } }
            res[5] = { "data-collector-low-density-structure", { { 0.0, 0.15 }, { 0.2, 0.2 }, { 1.0, 0.3 } } }
            res[6] = { "data-collector-electric-engine-unit", { { 0.0, 0.05 }, { 0.2, 0.1 }, { 1.0, 0.1 } } }
            res[7] = { "data-collector-castra-data", { { 0.0, 0.1 }, { 0.5, 0.4 }, { 1.0, 1.0 } } }
            res[8] = { "castra-enemy-tank", { { 0.0, 0.0 }, { 0.4, 0.0 }, { 0.405, 0.05 }, { 1.0, 0.1 } } }
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
    createDataCollectorSpawn("electronic-circuit", "__base__/graphics/icons/electronic-circuit.png"),
    createDataCollectorSpawn("advanced-circuit", "__base__/graphics/icons/advanced-circuit.png"),
    createDataCollectorSpawn("millerite", "__castra__/graphics/icons/millerite.png"),
    createDataCollectorSpawn("gunpowder", "__castra__/graphics/icons/gunpowder.png"),
    createDataCollectorSpawn("low-density-structure", "__base__/graphics/icons/low-density-structure.png"),
    createDataCollectorSpawn("electric-engine-unit", "__base__/graphics/icons/electric-engine-unit.png"),
    createDataCollectorSpawn("castra-data", "__castra__/graphics/icons/castra-data.png"),
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
        max_health = 12000,
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
                percent = 95
            },
            {
                type = "laser",
                decrease = 20,
                percent = 90
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

-- Create a tank enemy based on the medium-spitter
local tank = table.deepcopy(data.raw["unit"]["medium-spitter"])
tank.name = "castra-enemy-tank"
tank.icon = "__base__/graphics/icons/tank.png"
-- Use the normal tank's health and resistances
tank.max_health = data.raw["car"]["tank"].max_health
tank.factoriopedia_simulation = nil
tank.resistances = {
    {
        type = "physical",
        decrease = 10,
        percent = 50
    },
    {
        type = "explosion",
        decrease = 10,
        percent = 50
    },
    {
        type = "fire",
        percent = 90
    },
    {
        type = "poison",
        percent = 99
    },
    {
        type = "laser",
        decrease = 20,
        percent = 90
    },
    {
        type = "electric",
        decrease = 10,
        percent = 60
    }
}
tank.absorptions_to_join_attack = { data = 1000 }
tank.run_animation = data.raw["car"]["tank"].animation
tank.run_animation.tint = { r = 0, g = 0.5, b = 0.2, a = 1 }
tank.working_sound = data.raw["car"]["tank"].working_sound
tank.rotation_speed = data.raw["car"]["tank"].rotation_speed
tank.alternative_attacking_frame_sequence = nil
tank.corpse = data.raw["car"]["tank"].corpse
tank.dying_explosion = data.raw["car"]["tank"].dying_explosion
tank.dying_sound = nil
tank.walking_sound = nil
tank.water_reflection = nil
tank.movement_speed = 0.08
tank.collision_box = data.raw["car"]["tank"].collision_box
tank.selection_box = data.raw["car"]["tank"].selection_box
tank.attack_parameters = {
    type = "projectile",
    range = 10,
    cooldown = 30,
    cooldown_deviation = 0.15,
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
                        damage = { amount = 24, type = "physical" }
                    },
                    {
                        type = "activate-impact",
                        deliver_category = "bullet"
                    }
                }
            }
        }
    },
    animation = tank.run_animation,
    range_mode = "bounding-box-to-bounding-box"
}

data:extend({ tank })

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

-- Create enemy versions of laser-turret, railgun, flamethrower
data:extend({
    create_enemy_version(data.raw["electric-turret"]["laser-turret"]),
    create_enemy_version(data.raw["ammo-turret"]["railgun-turret"]),
    create_enemy_version(data.raw["fluid-turret"]["flamethrower-turret"]),
    create_enemy_version(data.raw["electric-turret"]["tesla-turret"]),
})
