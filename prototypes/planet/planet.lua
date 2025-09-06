local effects = require("__core__/lualib/surface-render-parameter-effects")
local planet_map_gen = require("planet-map-gen")
local procession_graphic_catalogue_types = require("__base__/prototypes/planet/procession-graphic-catalogue-types")
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

asteroid_util.castra_ratio       = {6, 2, 0 , 0}
asteroid_util.castra_chunks    = 0.0010
asteroid_util.castra_medium    = 0.0035

asteroid_util.vulcanus_castra =
{
  probability_on_range_chunk =
  {
    {position = 0.1, probability = asteroid_util.vulcanus_chunks, angle_when_stopped = asteroid_util.chunk_angle},
    {position = 0.9, probability = asteroid_util.castra_chunks, angle_when_stopped = asteroid_util.chunk_angle}
  },
  probability_on_range_medium =
  {
    {position = 0.1, probability = asteroid_util.vulcanus_medium, angle_when_stopped = asteroid_util.medium_angle},
    {position = 0.5, probability = asteroid_util.weighted_average(asteroid_util.vulcanus_medium, asteroid_util.castra_medium, 0.5) * 3, angle_when_stopped = asteroid_util.medium_angle},
    {position = 0.9, probability = asteroid_util.castra_medium, angle_when_stopped = asteroid_util.medium_angle}
  },
  type_ratios =
  {
    {position = 0.1, ratios = asteroid_util.vulcanus_ratio},
    {position = 0.9, ratios = asteroid_util.castra_ratio},
  }
}

asteroid_util.gleba_castra =
{
  probability_on_range_chunk =
  {
    {position = 0.1, probability = asteroid_util.gleba_chunks, angle_when_stopped = asteroid_util.chunk_angle},
    {position = 0.9, probability = asteroid_util.castra_chunks, angle_when_stopped = asteroid_util.chunk_angle}
  },
  probability_on_range_medium =
  {
    {position = 0.1, probability = asteroid_util.gleba_medium, angle_when_stopped = asteroid_util.medium_angle},
    {position = 0.5, probability = asteroid_util.weighted_average(asteroid_util.gleba_medium, asteroid_util.castra_medium, 0.5) * 3, angle_when_stopped = asteroid_util.medium_angle},
    {position = 0.9, probability = asteroid_util.castra_medium, angle_when_stopped = asteroid_util.medium_angle}
  },
  type_ratios =
  {
    {position = 0.1, ratios = asteroid_util.gleba_ratio},
    {position = 0.9, ratios = asteroid_util.castra_ratio},
  }
}

asteroid_util.castra_corrundum =
{
  probability_on_range_chunk =
  {
	{position = 0.1, probability = asteroid_util.castra_chunks, angle_when_stopped = asteroid_util.chunk_angle},
	{position = 0.9, probability = asteroid_util.vulcanus_chunks, angle_when_stopped = asteroid_util.chunk_angle}
  },
  probability_on_range_medium =
  {
	{position = 0.1, probability = asteroid_util.castra_medium, angle_when_stopped = asteroid_util.medium_angle},
	{position = 0.5, probability = asteroid_util.weighted_average(asteroid_util.castra_medium, asteroid_util.vulcanus_medium, 0.5) * 3, angle_when_stopped = asteroid_util.medium_angle},
	{position = 0.9, probability = asteroid_util.vulcanus_medium, angle_when_stopped = asteroid_util.medium_angle}
  },
  type_ratios =
  {
	{position = 0.1, ratios = asteroid_util.castra_ratio},
	{position = 0.9, ratios = asteroid_util.vulcanus_ratio},
  }
}

local planet = {
  {
    type = "planet",
    name = "castra",
    icon = "__castra__/graphics/icons/castra.png",
    starmap_icon = "__castra__/graphics/icons/starmap-planet-castra.png",
    starmap_icon_size = 512,
    gravity_pull = 15,
    distance = 21,
    orientation = 0.05,
    magnitude = 1,
    order = "d[castra]",
    subgroup = "planets",
    map_seed_offset = 420354692,
    map_gen_settings = planet_map_gen.castra(),
    solar_power_in_space = 150,
    asteroid_spawn_influence = 1,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.vulcanus_castra, 0.9),
    platform_procession_set =
    {
      arrival = {"planet-to-platform-b"},
      departure = {"platform-to-planet-a"}
    },
    planet_procession_set =
    {
      arrival = {"platform-to-planet-b"},
      departure = {"planet-to-platform-a"}
    },
    surface_properties =
    {
      ["day-night-cycle"] = 18 * minute,
      ["solar-power"] = 80,
      ["pressure"] = 1254
    },
    pollutant_type = "data",
    surface_render_parameters =
    {
      clouds = effects.default_clouds_effect_properties()
    },
    persistent_ambient_sounds =
    {
      base_ambience = { filename = "__base__/sound/world/world_base_wind.ogg", volume = 0.3 },
      wind = { filename = "__base__/sound/wind/wind.ogg", volume = 0.8 },
      crossfade =
      {
        order = { "wind", "base_ambience" },
        curve_type = "cosine",
        from = { control = 0.35, volume_percentage = 0.0 },
        to = { control = 2, volume_percentage = 100.0 }
      }
    },
    procession_graphic_catalogue =
    {
	  -- CLOUDS
	  {
		index = procession_graphic_catalogue_types.planet_cloudscape,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/vulcanus-cloudscape.png",
		  width = 960,
		  height = 960,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },
	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_mask,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/mask-cloudscape.png",
		  width = 960,
		  height = 960,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },

	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl0,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/vulcanus-cloudscape-layered-0.png",
		  width = 2000,
		  height = 1500,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },
	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl0_mask,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-0.png",
		  width = 2000,
		  height = 1500,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },

	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl1,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/vulcanus-cloudscape-layered-1.png",
		  width = 1600,
		  height = 1200,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },
	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl1_mask,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-1.png",
		  width = 1600,
		  height = 1200,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },


	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl2,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/vulcanus-cloudscape-layered-2.png",
		  width = 1400,
		  height = 1050,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },
	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl2_mask,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-2.png",
		  width = 1400,
		  height = 1050,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },

	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl3,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/vulcanus-cloudscape-layered-3.png",
		  width = 1200,
		  height = 900,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },
	  {
		index = procession_graphic_catalogue_types.planet_cloudscape_lvl3_mask,
		type = "sprite",
		sprite = {
		  filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-3.png",
		  width = 1200,
		  height = 900,
		  priority = "no-atlas",
		  flags = { "group=effect-texture", "linear-minification", "linear-magnification" },
		}
	  },	
	
      {
        index = procession_graphic_catalogue_types.planet_hatch_emission_in_1,
        sprite = util.sprite_load("__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-A",
        {
          priority = "medium",
          draw_as_glow = true,
          blend_mode = "additive",     
          scale = 0.5,
          shift = util.by_pixel(-16, 96) --32 x ({0.5, -3.5} + {0, 0.5})
        })
      },
      {
        index = procession_graphic_catalogue_types.planet_hatch_emission_in_2,
        sprite = util.sprite_load("__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-B",
        {
          priority = "medium",
          draw_as_glow = true,
          blend_mode = "additive",     
          scale = 0.5,
          shift = util.by_pixel(-64, 96) --32 x ({2, -3.5} + {0, 0.5})
        })
      },
      {
        index = procession_graphic_catalogue_types.planet_hatch_emission_in_3,
        sprite = util.sprite_load("__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-C",
        {
          priority = "medium",
          draw_as_glow = true,
          blend_mode = "additive",     
          scale = 0.5,
          shift = util.by_pixel(-40, 64) --32 x ({1.25, -2.5} + {0, 0.5})
        })
      }
    }
  },
  -------------------------- CONNECTIONS --------------------------
  {
    type = "space-connection",
    name = "vulcanus-castra",
    subgroup = "planet-connections",
    from = "vulcanus",
    to = "castra",
    order = "c",
    length = 20000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.vulcanus_castra)
  },
  {
    type = "space-connection",
    name = "gleba-castra",
    subgroup = "planet-connections",
    from = "gleba",
    to = "castra",
    order = "c",
    length = 20000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_castra)
  }
  
}

if mods["corrundum"] then

table.insert(planet, 
	{
	  type = "space-connection",
	  name = "castra-corrundum",
	  subgroup = "planet-connections",
	  from = "castra",
	  to = "corrundum",
	  order = "c",
	  length = 10000, 
	  asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.castra_corrundum)
	}
)

end

data:extend(planet)