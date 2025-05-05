local hit_effects = require("__base__.prototypes.entity.hit-effects")
local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
    {
      type = "recipe-category",
      name = "jammed-data-collector-process"
    },
    {
        type = "fuel-category",
        name = "castra-jammer"
    },
    {
        type = "burner-usage",
        name = "castra-jammer",
        empty_slot_sprite =
        {
            filename = "__core__/graphics/icons/mip/empty-robot-material-slot.png",
            priority = "extra-high-no-scale",
            size = 64,
            mipmap_count = 2,
            flags = { "gui-icon" },
        },
        empty_slot_caption = { "description.accepted-jammer" },
        empty_slot_description = { "description.accepted-jammer" },
        icon =
        {
            filename = "__core__/graphics/icons/alerts/electricity-icon-red.png",
            priority = "extra-high-no-scale",
            width = 64,
            height = 64,
            flags = { "icon" }
        },
        no_fuel_status = { "entity-status.no-jammer" },

        accepted_fuel_key = "description.accepted-jammer",
        burned_in_key = "jammed-by", -- factoriopedia
    },
    {
        type = "radar",
        name = "jammer-radar",
        icon = "__castra__/graphics/icons/jammer-radar.png",
        flags = { "placeable-player", "player-creation" },
        minable = { mining_time = 0.1, result = "jammer-radar" },
        fast_replaceable_group = "radar",
        max_health = 500,
        corpse = "radar-remnants",
        dying_explosion = "radar-explosion",
        resistances =
        {
            {
                type = "fire",
                percent = 70
            },
            {
                type = "impact",
                percent = 30
            }
        },
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        damaged_trigger_effect = hit_effects.entity(),
        energy_per_sector = "10MJ",
        max_distance_of_sector_revealed = 20,
        max_distance_of_nearby_sector_revealed = 5,
        energy_per_nearby_scan = "400kJ",
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input"
        },
        energy_usage = "1000kW",
        integration_patch =
        {
            filename = "__castra__/graphics/entity/jammer-radar/radar-integration.png",
            priority = "low",
            width = 238,
            height = 216,
            shift = util.by_pixel(1.5, 4.0),
            scale = 0.5
        },
        pictures =
        {
            layers =
            {
                {
                    filename = "__castra__/graphics/entity/jammer-radar/jammer-radar.png",
                    priority = "low",
                    width = 196,
                    height = 254,
                    apply_projection = false,
                    direction_count = 64,
                    line_length = 8,
                    shift = util.by_pixel(1.0, -16.0),
                    scale = 0.5
                },
                {
                    filename = "__castra__/graphics/entity/jammer-radar/radar-shadow.png",
                    priority = "low",
                    width = 336,
                    height = 170,
                    apply_projection = false,
                    direction_count = 64,
                    line_length = 8,
                    shift = util.by_pixel(39.0, 6.0),
                    draw_as_shadow = true,
                    scale = 0.5
                }
            }
        },
        impact_category = "metal",
        working_sound =
        {
            sound = { filename = "__base__/sound/radar.ogg", volume = 0.8, modifiers = volume_multiplier("main-menu", 2.0) },
            max_sounds_per_prototype = 3,
            use_doppler_shift = false
        },
        radius_minimap_visualisation_color = { 0.059, 0.092, 0.235, 0.275 },
        rotation_speed = 0.01,
        water_reflection =
        {
            pictures =
            {
                filename = "__castra__/graphics/entity/jammer-radar/radar-reflection.png",
                priority = "extra-high",
                width = 28,
                height = 32,
                shift = util.by_pixel(5, 35),
                variation_count = 1,
                scale = 5
            },
            rotate = false,
            orientation_to_variation = false
        },
        is_military_target = false,
        circuit_connector = circuit_connector_definitions["radar"],
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        connects_to_other_radars = false
    },
    {
        type = "item",
        name = "jammer-radar",
        icon = "__castra__/graphics/icons/jammer-radar.png",
        subgroup = "defensive-structure",
        order = "d[radar]-d[jammer-radar]",
        inventory_move_sound = item_sounds.metal_large_inventory_move,
        pick_sound = item_sounds.metal_large_inventory_pickup,
        drop_sound = item_sounds.metal_large_inventory_move,
        place_result = "jammer-radar",
        stack_size = 50,
        random_tint_color = item_tints.iron_rust,
        weight = 20 * kg
    },
}
)
