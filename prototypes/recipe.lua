data:extend({    
  {
    type = "recipe-category",
    name = "castra-crafting"
  },
  {
    type = "recipe-category",
    name = "castra-chemistry"
  },
  {
    type = "recipe-category",
    name = "castra-electromagnetics"
  },
  {
    type = "recipe-category",
    name = "castra-forge"
  },
})

data:extend(
  {
    {
      type = "recipe",
      name = "nickel-extraction",
      category = "smelting",
      energy_required = 8,
      ingredients = {{type="item", name="millerite", amount=5}},
      results = {
        {type="item", name="nickel-plate", amount=4},
        {type="item", name="iron-ore", amount=1, probability=0.1},
        {type="item", name="sulfur", amount=1, probability=0.1}
      },        
      icons =
      {
        {
          icon = "__castra__/graphics/icons/nickel-plate.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__base__/graphics/icons/iron-ore.png",
          scale = 0.5,
          shift = {-10, 10}
        },
        {
          icon = "__base__/graphics/icons/sulfur.png",
          scale = 0.5,
          shift = {10, 10}
        }
      },
      subgroup = "castra-processes",
      order = "c[millerite]-b[nickel-extraction]",
      enabled = false,
      allow_productivity = true,
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "hydrogen-sulfide-electrolysis",
      category = "chemistry",
      energy_required = 5,
      ingredients = {{type="fluid", name="hydrogen-sulfide", amount=50}},
      results = {
        {type="fluid", name="water", amount=40},
        {type="item", name="sulfur", amount=5}
      },
      icons =
      {
        {
          icon = "__castra__/graphics/icons/fluid/hydrogen-sulfide.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__base__/graphics/icons/fluid/water.png",
          scale = 0.5,
          shift = {-10, 10}
        },
        {
          icon = "__base__/graphics/icons/sulfur.png",
          scale = 0.5,
          shift = {10, 10}
        }
      },
      subgroup = "castra-processes",
      order = "c[hydrogen-sulfide]-a[hydrogen-sulfide-extraction]",
      enabled = false,
      allow_productivity = true,
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "firearm-magazine-nickel",
      enabled = false,
      energy_required = 1,
      ingredients = {{type="item", name="nickel-plate", amount=2}},
      results = {{type="item", name="firearm-magazine", amount=1}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/firearm-magazine.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/nickel-plate.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "piercing-rounds-catalyzing",
      enabled = false,
      energy_required = 3,
      ingredients = {
        {type="item", name="copper-plate", amount=4},
        {type="item", name="millerite", amount=1},
        {type="item", name="firearm-magazine", amount=1}
      },
      results = {{type="item", name="piercing-rounds-magazine", amount=1}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/piercing-rounds-magazine.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/millerite.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "hydrogen-sulfide-carbon-extraction",
      enabled = false,
      category = "chemistry",
      energy_required = 10,
      ingredients = {
        {type="fluid", name="hydrogen-sulfide", amount=10},
        {type="item", name="sulfur", amount=1},
        {type="fluid", name="water", amount=5}
      },
      results = {
        {type="item", name="carbon", amount=2},
        {type="fluid", name="sulfuric-acid", amount=20}
      },
      icons =
      {
        {
          icon = "__space-age__/graphics/icons/carbon.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/fluid/hydrogen-sulfide.png",
          scale = 0.5,
          shift = {-10, 10}
        },
        {
          icon = "__base__/graphics/icons/sulfur.png",
          scale = 0.5,
          shift = {10, 10}
        }
      },
      subgroup = "castra-processes",
      order = "c[hydrogen-sulfide]-b[hydrogen-sulfide-carbon-extraction]",
      allow_productivity = true,
      auto_recycle = false
    },
    {
      -- explosives from gunpowder instead of coal
      type = "recipe",
      name = "explosives-gunpowder",
      enabled = false,
      category = "chemistry",
      energy_required = 3,
      ingredients = {
        {type="item", name="gunpowder", amount=4},
        {type="fluid", name="water", amount=10}
      },
      results = {{type="item", name="explosives", amount=2}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/explosives.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/gunpowder.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      allow_productivity = true,
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "grenade-gunpowder",
      enabled = false,
      energy_required = 8,
      ingredients = {
        {type="item", name="gunpowder", amount=10},
        {type="item", name="iron-plate", amount=5}
      },
      results = {{type="item", name="grenade", amount=1}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/grenade.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/gunpowder.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      auto_recycle = false
    },
    {
      -- engine with gunpowder
      type = "recipe",
      name = "engine-unit-gunpowder",
      enabled = false,
      energy_required = 10,
      ingredients = {
        {type="item", name="gunpowder", amount=5},
        {type="item", name="iron-gear-wheel", amount=1},
        {type="item", name="pipe", amount=2}
      },
      results = {{type="item", name="engine-unit", amount=1}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/engine-unit.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/gunpowder.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      allow_productivity = true,
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "plastic-hydrogen-sulfide",
      enabled = false,
      category = "chemistry",
      energy_required = 2,
      ingredients = {
        {type="item", name="carbon", amount=1},
        {type="fluid", name="hydrogen-sulfide", amount=10},
        {type="fluid", name="petroleum-gas", amount=30}
      },
      results = {{type="item", name="plastic-bar", amount=3}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/plastic-bar.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__space-age__/graphics/icons/carbon.png",
          scale = 0.5,
          shift = {-10, 10}
        },
        {
          icon = "__castra__/graphics/icons/fluid/hydrogen-sulfide.png",
          scale = 0.5,
          shift = {10, 10}
        }
      },
      allow_productivity = true,
      auto_recycle = false
    },
    {
      -- Battery using nickel instead of iron
      type = "recipe",
      name = "battery-nickel",
      category = "chemistry",
      enabled = false,
      energy_required = 4,
      ingredients = {
        {type="item", name="nickel-plate", amount=1},
        {type="item", name="copper-plate", amount=1},
        {type="fluid", name="sulfuric-acid", amount=10}
      },
      results = {{type="item", name="battery", amount=1}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/battery.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/nickel-plate.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      allow_productivity = true,
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "forge",
      category = "castra-forge",
      enabled = false,
      energy_required = 20,
      ingredients = {
        {type="item", name="steel-plate", amount=30},
        {type="item", name="nickel-plate", amount=20},
        {type="item", name="advanced-circuit", amount=20},
        {type="item", name="engine-unit", amount=20},
        {type="item", name="gunpowder", amount=100}
      },
      results = {{type="item", name="forge", amount=1}},      
      surface_conditions =
      {
        {
          property = "pressure",
          min = 1254,
          max = 1254
        }
      }
    },
    {
      -- battlefield science pack
      type = "recipe",
      name = "battlefield-science-pack",
      category = "castra-forge",
      enabled = false,
      energy_required = 24,
      ingredients = {
        {type="item", name="uranium-rounds-magazine", amount=5},
        {type="item", name="tank", amount=1},
        {type="item", name="castra-data", amount=1}
      },
      results = {{type="item", name="battlefield-science-pack", amount=10}},
      allow_productivity = true,
      auto_recycle = false,      
      surface_conditions =
      {
        {
          property = "pressure",
          min = 1254,
          max = 1254
        }
      }
    },
    {
      type = "recipe",
      name = "reverse-cracking",
      category = "oil-processing",
      subgroup = "castra-processes",
      order = "c[reverse-cracking]",
      enabled = false,
      energy_required = 30,
      ingredients = {
        {type="fluid", name="light-oil", amount=10},
        {type="item", name="millerite", amount=1},
        {type="fluid", name="water", amount=5}
      },
      results = {
        {type="fluid", name="heavy-oil", amount=5},
        {type="fluid", name="crude-oil", amount=5}
      },
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
      allow_productivity = true,
      auto_recycle = false
    },
    {
      -- tank with nickel instead of steel
      type = "recipe",
      name = "tank-nickel",
      enabled = false,
      energy_required = 5,
      ingredients =
      {
        {type = "item", name = "engine-unit", amount = 24},
        {type = "item", name = "nickel-plate", amount = 50},
        {type = "item", name = "iron-gear-wheel", amount = 15},
        {type = "item", name = "advanced-circuit", amount = 10}
      },
      results = {{type="item", name="tank", amount=1}},
      icons =
      {
        {
          icon = "__base__/graphics/icons/tank.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/nickel-plate.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      auto_recycle = false
    },
    {
      -- advanced nickel processing in the foundry
      type = "recipe",
      name = "advanced-nickel-processing",
      category = "metallurgy",
      subgroup = "castra-processes",
      order = "e[advanced-nickel-processing]",
      enabled = false,
      energy_required = 24,
      ingredients = {
        {type="item", name="millerite", amount=40},
        {type="item", name="carbon", amount=6}
      },
      results = {
        {type="item", name="nickel-plate", amount=36},
        {type="fluid", name="molten-iron", amount=80},
        {type="item", name="sulfur", amount=4}
      },
      icons =
      {
        {
          icon = "__castra__/graphics/icons/nickel-plate.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__space-age__/graphics/icons/fluid/molten-iron.png",
          scale = 0.5,
          shift = {-10, 10}
        },
        {
          icon = "__base__/graphics/icons/sulfur.png",
          scale = 0.5,
          shift = {10, 10}
        }
      },
      allow_productivity = true,
      auto_recycle = false
    },
    {
      type = "recipe",
      name = "lithium-battery",
      category = "cryogenics",
      enabled = false,
      energy_required = 10,
      ingredients = {
        {type="item", name="lithium-plate", amount=1},
        {type="item", name="nickel-plate", amount=1},
        {type="item", name="supercapacitor", amount=2}
      },
      results = {{type="item", name="lithium-battery", amount=1}},
      allow_productivity = true
    },
    {
      -- holmium solution + millerite = more holmium plate
      type = "recipe",
      name = "holmium-catalyzing",
      enabled = false,
      energy_required = 4,
      category = "metallurgy",
      ingredients = {
        {type="fluid", name="holmium-solution", amount=20},
        {type="item", name="millerite", amount=1}
      },
      results = {{type="item", name="holmium-plate", amount=2}},
      icons =
      {
        {
          icon = "__space-age__/graphics/icons/holmium-plate.png",
          scale = 0.7,
          shift = {0, -10}
        },
        {
          icon = "__castra__/graphics/icons/millerite.png",
          scale = 0.5,
          shift = {-10, 10}
        }
      },
      allow_productivity = true,
      auto_recycle = false
    },
    {      
      type = "recipe",
      name = "energy-shield-mk3-equipment",
      enabled = false,
      energy_required = 10,
      ingredients = {
        {type="item", name="energy-shield-mk2-equipment", amount=10},
        {type="item", name="lithium-battery", amount=8},
        {type="item", name="quantum-processor", amount=2}
      },
      results = {{type="item", name="energy-shield-mk3-equipment", amount=1}},
    },
    {
      -- combat-roboport
      type = "recipe",
      name = "combat-roboport",
      category = "castra-forge",
      enabled = false,
      energy_required = 10,
      ingredients = {
        {type="item", name="nickel-plate", amount=50},
        {type="item", name="processing-unit", amount=20},
        {type="item", name="castra-data", amount=5}
      },
      results = {{type="item", name="combat-roboport", amount=1}}      
    }
  }
)

