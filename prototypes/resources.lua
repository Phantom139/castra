local resource_autoplace = require("resource-autoplace")
local sounds = require("__base__.prototypes.entity.sounds")

local function resource(resource_parameters, autoplace_parameters)
  return
  {
    type = "resource",
    name = resource_parameters.name,
    icon = "__castra__/graphics/icons/" .. resource_parameters.name .. ".png",
    flags = {"placeable-neutral"},
    order="a-b-"..resource_parameters.order,
    tree_removal_probability = 0.8,
    tree_removal_max_distance = 32 * 32,
    minable = resource_parameters.minable or
    {
      mining_time = resource_parameters.mining_time,
      result = resource_parameters.name
    },
    category = resource_parameters.category,
    subgroup = resource_parameters.subgroup,
    walking_sound = resource_parameters.walking_sound,
    collision_mask = resource_parameters.collision_mask,
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    resource_patch_search_radius = resource_parameters.resource_patch_search_radius,
    autoplace = autoplace_parameters.probability_expression ~= nil and
    {
      --control = resource_parameters.name,
      order = resource_parameters.order,
      probability_expression = autoplace_parameters.probability_expression,
      richness_expression = autoplace_parameters.richness_expression
    }
    or resource_autoplace.resource_autoplace_settings
    {
      name = resource_parameters.name,
      order = resource_parameters.order,
      autoplace_control_name = resource_parameters.autoplace_control_name,
      base_density = autoplace_parameters.base_density,
      base_spots_per_km = autoplace_parameters.base_spots_per_km2,
      regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier,
      starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
      candidate_spot_count = autoplace_parameters.candidate_spot_count,
      tile_restriction = autoplace_parameters.tile_restriction
    },
    stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
    stages =
    {
      sheet =
      {
        filename = "__castra__/graphics/entity/" .. resource_parameters.name .. "/" .. resource_parameters.name .. ".png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5
      }
    },
    map_color = resource_parameters.map_color,
    mining_visualisation_tint = resource_parameters.mining_visualisation_tint
  }
end

data:extend({
  resource(
    {
      name = "millerite",
      order = "e",
      map_color = {r = 211/256, g = 190/256, b = 105/256, a = 1.000},
      mining_time = 3,
      walking_sound = sounds.ore,
      mining_visualisation_tint = {r=211/256, g = 190/256, b = 105/256, a = 1.000},
    },
    {
      base_density = 12,
      regular_rq_factor_multiplier = 1.07,
      starting_rq_factor_multiplier = 1.4,
      candidate_spot_count = 18, -- To match 0.17.50 placement
      has_starting_area_placement = true
    }
  ),
  {
    type = "resource",
    name = "hydrogen-sulfide-vent",
    icon = "__castra__/graphics/icons/hydrogen-sulfide-vent.png",
    flags = {"placeable-neutral"},
    category = "basic-fluid",
    subgroup = "mineable-fluids",
    order="b",
    highlight = true,
    resource_patch_search_radius = 16,
    tree_removal_probability = 0.7,
    tree_removal_max_distance = 32 * 32,
    minable =
    {
      mining_time = 0.1,
      results =
      {
        {
          type = "fluid",
          name = "hydrogen-sulfide",
          amount_min = 1,
          amount_max = 1,
          probability = 1
        }
      }
    },
    walking_sound = sounds.oil,
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings {
      name = "hydrogen-sulfide-vent",
      order="a[resources]-c[hydrogen-sulfide]",
      --default_enabled = false,
      base_density = 8.2,
      base_spots_per_km2 = 1.2,
      random_probability = 1/24,
      random_spot_size_minimum = 1,
      random_spot_size_maximum = 1, -- don't randomize spot size
      additional_richness = 640000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1
    },
    stage_counts = {0},
    stages =
    {
      layers =
      {
        util.sprite_load("__castra__/graphics/entity/hydrogen-sulfide-vent/hydrogen-sulfide-vent",
        {
          priority = "extra-high",
          frame_count = 4,
          scale = 0.5
        })
      }
    },
    draw_stateless_visualisation_under_building = false,
    stateless_visualisation =
    {
      {
        count = 1,
        render_layer = "smoke",
        animation = util.sprite_load("__space-age__/graphics/entity/lithium-brine/smoke-1",
        {
          priority = "extra-high",
          frame_count = 64,
          animation_speed = 0.35,
          tint = {r=196/256, g=207/256, b=51/256,a= 1},
          scale = 0.75,
          shift = {0,-0.23}
        })
      },
      {
        count = 1,
        render_layer = "smoke",
        animation = util.sprite_load("__space-age__/graphics/entity/lithium-brine/smoke-2",
        {
          priority = "extra-high",
          frame_count = 64,
          animation_speed = 0.35,
          tint = {r=196/256, g=207/256, b=51/256,a= 0.35},
          scale = 0.75,
          shift = {0,-0.23}
        })
      }
    },
    map_color = {196/256, 207/256, 51/256},
    map_grid = false
  },
  resource(
    {
      name = "gunpowder",
      order = "e",
      map_color = {r = 70/256, g = 70/256, b = 70/256, a = 1.000},
      mining_time = 0.5,
      walking_sound = sounds.ore,
      mining_visualisation_tint = {r=70/256, g = 70/256, b = 70/256, a = 1.000},
    },
    {
      base_density = 14,
      regular_rq_factor_multiplier = 1.02,
      starting_rq_factor_multiplier = 1.1,
      candidate_spot_count = 10,
      has_starting_area_placement = true
    }
  )
})