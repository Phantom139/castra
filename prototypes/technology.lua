data:extend(
  {
    {
      type = "technology",
      name = "planet-discovery-castra",
      icons = util.technology_icon_constant_planet("__castra__/graphics/icons/technology-castra.png"),
      icon_size = 256,
      essential = true,
      effects =
      {
        {
          type = "unlock-space-location",
          space_location = "castra",
          use_icon_overlay_constant = true
        },
        {
          type = "unlock-recipe",
          recipe = "electronic-circuit-battlefield-data"
        },
        {
          type = "unlock-recipe",
          recipe = "advanced-circuit-battlefield-data"
        },
        {
          type = "unlock-recipe",
          recipe = "processing-unit-battlefield-data"
        }
      },
      prerequisites = { "space-platform-thruster", "military-science-pack" },
      unit =
      {
        count = 1000,
        ingredients =
        {
          { "automation-science-pack", 1 },
          { "logistic-science-pack",   1 },
          { "chemical-science-pack",   1 },
          { "space-science-pack",      1 },
          { "military-science-pack",   1 }
        },
        time = 60
      }
    },
    {
      type = "technology",
      name = "millerite-processing",
      icon = "__castra__/graphics/technology/millerite.png",
      icon_size = 256,
      prerequisites = { "planet-discovery-castra" },
      research_trigger =
      {
        type = "mine-entity",
        entity = "millerite"
      },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "nickel-extraction"
        },
        {
          type = "unlock-recipe",
          recipe = "firearm-magazine-nickel"
        },
        {
          type = "unlock-recipe",
          recipe = "piercing-rounds-catalyzing"
        },
        {
          type = "unlock-recipe",
          recipe = "battery-nickel"
        },
        {
          type = "unlock-recipe",
          recipe = "tank-nickel"
        },
        {
          type = "unlock-recipe",
          recipe = "nickel-sulfide-reduction"
        }
      }
    },
    {
      type = "technology",
      name = "hydrogen-sulfide-processing",
      icon = "__castra__/graphics/technology/hydrogen-sulfide-vent.png",
      icon_size = 256,
      prerequisites = { "planet-discovery-castra" },
      research_trigger =
      {
        type = "mine-entity",
        entity = "hydrogen-sulfide-vent"
      },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "hydrogen-sulfide-electrolysis"
        },
        {
          type = "unlock-recipe",
          recipe = "hydrogen-sulfide-carbon-extraction"
        },
        {
          type = "unlock-recipe",
          recipe = "plastic-hydrogen-sulfide"
        },
        {
          type = "unlock-recipe",
          recipe = "rocket-fuel-sulfur"
        }
      }
    },
    {
      type = "technology",
      name = "gunpowder-processing",
      icon = "__castra__/graphics/technology/gunpowder.png",
      icon_size = 256,
      prerequisites = { "planet-discovery-castra" },
      research_trigger =
      {
        type = "mine-entity",
        entity = "gunpowder"
      },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "explosives-gunpowder"
        },
        {
          type = "unlock-recipe",
          recipe = "grenade-gunpowder"
        },
        {
          type = "unlock-recipe",
          recipe = "engine-unit-gunpowder"
        },
        {
          type = "unlock-recipe",
          recipe = "gunpowder-carbon"
        }
      }
    },
    {
      type = "technology",
      name = "forge",
      icon = "__castra__/graphics/technology/atom-forge.png",
      icon_size = 256,
      prerequisites = { "millerite-processing", "hydrogen-sulfide-processing", "gunpowder-processing", "quality-module-2" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "forge"
        }
      },
      research_trigger =
      {
        type = "craft-item",
        item = "nickel-plate"
      }
    },
    {
      type = "technology",
      name = "battlefield-science-pack",
      icon = "__castra__/graphics/technology/battlefield-science-pack.png",
      icon_size = 256,
      prerequisites = { "forge", "tank", "uranium-ammo" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "battlefield-science-pack"
        }
      },
      research_trigger =
      {
        type = "craft-item",
        item = "forge"
      }
    },
    {
      type = "technology",
      name = "reverse-cracking",
      icons =
      {
        {
          icon = "__base__/graphics/icons/fluid/heavy-oil.png",
          scale = 0.7,
          shift = { -10, 10 }
        },
        {
          icon = "__base__/graphics/icons/fluid/crude-oil.png",
          scale = 0.7,
          shift = { 10, -10 }
        },
        {
          icon = "__castra__/graphics/icons/millerite.png",
          scale = 0.5,
          shift = { -10, -10 }
        },
        {
          icon = "__base__/graphics/icons/fluid/light-oil.png",
          scale = 0.5,
          shift = { 0, -10 }
        },
        {
          icon = "__base__/graphics/icons/fluid/water.png",
          scale = 0.5,
          shift = { 10, 10 }
        }
      },
      icon_size = 64,
      prerequisites = { "battlefield-science-pack" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "reverse-cracking"
        }
      },
      unit =
      {
        count = 500,
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 }
        },
        time = 30
      }
    },
    {
      -- advanced nickel processing which outputs molten iron instead of iron ore
      type = "technology",
      name = "advanced-nickel-processing",
      icons =
      {
        {
          icon = "__castra__/graphics/icons/nickel-plate.png",
          scale = 0.7,
          shift = { 0, -10 }
        },
        {
          icon = "__space-age__/graphics/icons/fluid/molten-iron.png",
          scale = 0.5,
          shift = { -10, 10 }
        },
        {
          icon = "__base__/graphics/icons/sulfur.png",
          scale = 0.5,
          shift = { 10, 10 }
        }
      },
      icon_size = 64,
      prerequisites = { "battlefield-science-pack", "metallurgic-science-pack" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "advanced-nickel-processing"
        }
      },
      unit =
      {
        count = 1000,
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 },
          { "metallurgic-science-pack", 1 }
        },
        time = 30
      }
    },
    {
      type = "technology",
      name = "lithium-battery",
      icon = "__castra__/graphics/technology/lithium-battery.png",
      icon_size = 256,
      prerequisites = { "battlefield-science-pack", "cryogenic-science-pack" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "lithium-battery"
        }
      },
      unit =
      {
        count = 500,
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 },
          { "cryogenic-science-pack",   1 }
        },
        time = 30
      }
    },
    {
      type = "technology",
      name = "holmium-catalyzing",
      icon = "__castra__/graphics/technology/holmium-catalyzing.png",
      icon_size = 256,
      prerequisites = { "battlefield-science-pack", "electromagnetic-science-pack" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "holmium-catalyzing"
        }
      },
      unit =
      {
        count = 1000,
        ingredients =
        {
          { "automation-science-pack",      1 },
          { "logistic-science-pack",        1 },
          { "chemical-science-pack",        1 },
          { "space-science-pack",           1 },
          { "battlefield-science-pack",     1 },
          { "electromagnetic-science-pack", 1 }
        },
        time = 30
      }
    },
    {
      type = "technology",
      name = "energy-shield-mk3-equipment",
      icon = "__castra__/graphics/technology/energy-shield-mk3-equipment.png",
      icon_size = 256,
      prerequisites = { "lithium-battery", "quantum-processor", "energy-shield-mk2-equipment" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "energy-shield-mk3-equipment"
        }
      },
      unit =
      {
        count = 500,
        ingredients =
        {
          { "automation-science-pack",      1 },
          { "logistic-science-pack",        1 },
          { "chemical-science-pack",        1 },
          { "production-science-pack",      1 },
          { "utility-science-pack",         1 },
          { "space-science-pack",           1 },
          { "metallurgic-science-pack",     1 },
          { "agricultural-science-pack",    1 },
          { "electromagnetic-science-pack", 1 },
          { "cryogenic-science-pack",       1 },
          { "battlefield-science-pack",     1 }
        },
        time = 30
      }
    },
    {
      type = "technology",
      name = "combat-roboport",
      icon = "__castra__/graphics/technology/combat-roboport.png",
      icon_size = 256,
      prerequisites = { "battlefield-science-pack", "defender" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "combat-roboport"
        },
        {
          type = "unlock-recipe",
          recipe = "defender-capsule-castra-data"
        },
        {
          type = "unlock-recipe",
          recipe = "distractor-capsule-castra-data"
        },
        {
          type = "unlock-recipe",
          recipe = "destroyer-capsule-castra-data"
        }
      },
      unit =
      {
        count = 500,
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "space-science-pack",       1 },
          { "military-science-pack",    1 },
          { "battlefield-science-pack", 1 }
        },
        time = 30
      }
    },
    {
      type = "technology",
      name = "engine-productivity",
      icons = util.technology_icon_constant_productivity("__base__/graphics/technology/engine.png"),
      effects =
      {
        {
          type = "change-recipe-productivity",
          recipe = "engine-unit",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "electric-engine-unit",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "engine-unit-gunpowder",
          change = 0.1
        }
      },
      prerequisites = { "battlefield-science-pack" },
      unit =
      {
        count_formula = "1.5^(L-1)*1375",
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "production-science-pack",  1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 }
        },
        time = 60
      },
      max_level = "infinite",
      upgrade = true
    },
    {
      type = "technology",
      name = "physical-ammo-productivity",
      icons = util.technology_icon_constant_productivity("__base__/graphics/technology/military.png"),
      effects =
      {
        {
          type = "change-recipe-productivity",
          recipe = "firearm-magazine",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "firearm-magazine-nickel",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "piercing-rounds-magazine",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "piercing-rounds-catalyzing",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "uranium-rounds-magazine",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "cannon-shell",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "uranium-cannon-shell",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "shotgun-shell",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "piercing-shotgun-shell",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "artillery-shell",
          change = 0.05
        },
        {
          type = "change-recipe-productivity",
          recipe = "railgun-ammo",
          change = 0.1
        },
      },
      prerequisites = { "battlefield-science-pack", "promethium-science-pack" },
      unit =
      {
        count_formula = "2.0^(L-1)*2000",
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "military-science-pack",    1 },
          { "production-science-pack",  1 },
          { "utility-science-pack",     1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 },
          { "promethium-science-pack",  1 }
        },
        time = 60
      },
      max_level = "infinite",
      upgrade = true
    },
    {
      type = "technology",
      name = "explosive-ammo-productivity",
      icons = util.technology_icon_constant_productivity("__base__/graphics/technology/rocketry.png"),
      effects =
      {
        {
          type = "change-recipe-productivity",
          recipe = "rocket",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "explosive-rocket",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "atomic-bomb",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "explosive-cannon-shell",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "explosive-uranium-cannon-shell",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "grenade",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "cluster-grenade",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "grenade-gunpowder",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "land-mine",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "artillery-shell",
          change = 0.05
        },
      },
      prerequisites = { "battlefield-science-pack" },
      unit =
      {
        count_formula = "1.75^(L-1)*5000",
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "military-science-pack",    1 },
          { "production-science-pack",  1 },
          { "utility-science-pack",     1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 }
        },
        time = 60
      },
      max_level = "infinite",
      upgrade = true
    },
    {
      type = "technology",
      name = "special-ammo-productivity",
      icons = util.technology_icon_constant_productivity("__base__/graphics/technology/flammables.png"),
      effects =
      {
        {
          type = "change-recipe-productivity",
          recipe = "flamethrower-ammo",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "tesla-ammo",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "poison-capsule",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "poison-capsule-sulfur",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "slowdown-capsule",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "slowdown-capsule-sulfur",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "defender-capsule",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "distractor-capsule",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "destroyer-capsule",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "defender-capsule-castra-data",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "distractor-capsule-castra-data",
          change = 0.1
        },
        {
          type = "change-recipe-productivity",
          recipe = "destroyer-capsule-castra-data",
          change = 0.1
        }
      },
      prerequisites = { "battlefield-science-pack" },
      unit =
      {
        count_formula = "1.5^(L-1)*2000",
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "military-science-pack",    1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 }
        },
        time = 60
      },
      max_level = "infinite",
      upgrade = true
    },
    {
      type = "technology",
      name = "castra-enemy-research",
      icon = "__castra__/graphics/icons/technology-castra-enemy-research.png",
      icon_size = 256,
      prerequisites = { "battlefield-science-pack", "radar" },
      effects =
      {
        {
          type = "nothing",
          effect_description = { "technology-effect-description.castra-enemy-research" }
        }
      },
      unit =
      {
        count = 200,
        ingredients =
        {
          { "automation-science-pack",  1 },
          { "logistic-science-pack",    1 },
          { "chemical-science-pack",    1 },
          { "military-science-pack",    1 },
          { "space-science-pack",       1 },
          { "battlefield-science-pack", 1 }
        },
        time = 60
      }
    },
    {
      type = "technology",
      name = "military-transport-belt",
      icon = "__castra__/graphics/technology/military-transport-belt.png",
      icon_size = 256,
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "military-transport-belt"
        },
        {
          type = "unlock-recipe",
          recipe = "military-underground-belt"
        },
        {
          type = "unlock-recipe",
          recipe = "military-splitter"
        },
      },
      prerequisites = {"battlefield-science-pack", "reverse-cracking"},
      unit =
      {
        count = 1000,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"production-science-pack", 1},
          {"space-science-pack", 1},
          {"battlefield-science-pack", 1}
        },
        time = 60
      }
    },
    {
      type = "technology",
      name = "carbon-fiber-wall",
      icon = "__castra__/graphics/technology/carbon-fiber-wall.png",
      icon_size = 256,
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "carbon-fiber-wall"
        }
      },
      prerequisites = {"battlefield-science-pack", "carbon-fiber"},
      unit =
      {
        count = 1000,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"space-science-pack", 1},
          {"battlefield-science-pack", 1},
          {"agricultural-science-pack", 1}
        },
        time = 30
      }
    },
    {
      type = "technology",
      name = "jammer-radar",
      icon = "__castra__/graphics/technology/jammer-radar.png",
      icon_size = 256,
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "jammer-radar"
        }
      },
      prerequisites = {"battlefield-science-pack", "castra-enemy-research", "electromagnetic-science-pack"},
      unit =
      {
        count = 2000,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"space-science-pack", 1},
          {"battlefield-science-pack", 1},
          {"electromagnetic-science-pack", 1}
        },
        time = 30
      }
    },
    {
      type = "technology",
      name = "jammed-data-collector",
      icons = {
        {
          icon = "__castra__/graphics/technology/combat-roboport.png",
          icon_size = 256,
        },
        {
          icon = "__castra__/graphics/technology/combat-roboport.png",
          icon_size = 256,
          tint = { r = 0.5, g = 0.0, b = 0.5, a = 0.3 }
        }
      },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "jammed-data-collector"
        }
      },
      prerequisites = {"jammer-radar", "quantum-processor", "lithium-battery"},
      unit =
      {
        count = 5000,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
          {"military-science-pack", 1},
          {"space-science-pack", 1},
          {"battlefield-science-pack", 1},
          {"electromagnetic-science-pack", 1},
          {"cryogenic-science-pack", 1}
        },
        time = 30
      }
    }
  }
)

if settings.startup["castra-edits-add-disruption"].value then
	data:extend({
		{
		  type = "technology",
		  name = "castra-enemy-research-disruption",
		  icon = "__castra__/graphics/technology/research-disruption.png",
		  icon_size = 256,
		  effects = {
			{
			  type = "nothing",
			  effect_description = { "technology-effect-description.castra-enemy-research-disruption" }	  
			}
		  },
		  prerequisites = { "battlefield-science-pack", "jammer-radar" },
		  unit =
		  {
			count_formula = "1.5^(L-1)*1000",
			ingredients =
			{
			  { "automation-science-pack",  1 },
			  { "logistic-science-pack",    1 },
			  { "chemical-science-pack",    1 },
			  { "military-science-pack",    1 },
			  { "space-science-pack",       1 },
			  { "battlefield-science-pack", 1 }
			},
			time = 60
		  },
		  max_level = "infinite",
		  upgrade = true
		}
	})	
end
