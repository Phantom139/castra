local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
    {
        type = "item-subgroup",
        name = "castra-processes",
        group = "intermediate-products",
        order = "n"
    },
    {
        type = "item",
        name = "forge",
        icon = "__castra__/graphics/atom-forge/atom-forge-icon.png",
        subgroup = "production-machine",
        order = "i[forge]",
        inventory_move_sound = item_sounds.steam_inventory_move,
        pick_sound = item_sounds.steam_inventory_pickup,
        drop_sound = item_sounds.steam_inventory_move,
        place_result = "forge",
        stack_size = 20,
        default_import_location = "castra",
        weight = 120 * kg
    },
    {
        type = "item",
        name = "millerite",
        icon = "__castra__/graphics/icons/millerite.png",
        pictures =
        {
            { size = 64, filename = "__castra__/graphics/icons/millerite.png",   scale = 0.5, mipmap_count = 4 },
            { size = 64, filename = "__castra__/graphics/icons/millerite-1.png", scale = 0.5, mipmap_count = 4 },
            { size = 64, filename = "__castra__/graphics/icons/millerite-2.png", scale = 0.5, mipmap_count = 4 },
            { size = 64, filename = "__castra__/graphics/icons/millerite-3.png", scale = 0.5, mipmap_count = 4 }
        },
        subgroup = "castra-processes",
        color_hint = { text = "T" },
        order = "c[millerite]-a[millerite-ore]",
        inventory_move_sound = item_sounds.resource_inventory_move,
        pick_sound = item_sounds.resource_inventory_pickup,
        drop_sound = item_sounds.resource_inventory_move,
        stack_size = 50,
        default_import_location = "castra",
        weight = 10 * kg
    },
    {
      type = "item",
      name = "nickel-plate",
      icon = "__castra__/graphics/icons/nickel-plate.png",
      subgroup = "castra-processes",
      order = "c[millerite]-c[nickel-plate]",
      inventory_move_sound = item_sounds.metal_small_inventory_move,
      pick_sound = item_sounds.metal_small_inventory_pickup,
      drop_sound = item_sounds.metal_small_inventory_move,
      stack_size = 100,
      default_import_location = "castra",
      weight = 2*kg
    },
    {
      type = "item",
      name = "gunpowder",
      icon = "__castra__/graphics/icons/gunpowder.png",
      subgroup = "castra-processes",
      order = "c[gunpowder]",
      inventory_move_sound = item_sounds.metal_small_inventory_move,
      pick_sound = item_sounds.metal_small_inventory_pickup,
      drop_sound = item_sounds.metal_small_inventory_move,
      stack_size = 100,
      default_import_location = "castra",
      weight = 2*kg
    },
    {
      type = "tool",
      name = "battlefield-science-pack",
      localised_description = {"item-description.science-pack"},
      icon = "__castra__/graphics/icons/battlefield-science-pack.png",
      subgroup = "science-pack",
      color_hint = { text = "B" },
      order = "j",
      inventory_move_sound = item_sounds.science_inventory_move,
      pick_sound = item_sounds.science_inventory_pickup,
      drop_sound = item_sounds.science_inventory_move,
      stack_size = 200,
      default_import_location = "castra",
      weight = 1*kg,
      durability = 1,
      durability_description_key = "description.science-pack-remaining-amount-key",
      factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
      durability_description_value = "description.science-pack-remaining-amount-value",
      random_tint_color = item_tints.iron_rust
    },
    {
        type = "item",
        name = "castra-data",
        icon = "__castra__/graphics/icons/castra-data.png",
        subgroup = "castra-processes",
        order = "n",
        stack_size = 100,
        default_import_location = "castra",
        weight = 5 * kg,
        spoil_ticks = 1 * minute
    },
    {
        type = "item",
        name = "lithium-battery",
        icon = "__castra__/graphics/icons/lithium-battery.png",
        subgroup = "castra-processes",
        order = "n",
        stack_size = 100,
        default_import_location = "aquilo",
        weight = 10 * kg
    },
    {
        type = "item",
        name = "combat-roboport",
        icon = "__castra__/graphics/icons/combat-roboport.png",
        icon_size = 64,
        subgroup = "turret",
        order = "f[combat-roboport]",
        place_result = "combat-roboport",
        stack_size = 10,
        default_import_location = "castra",
        weight = 40 * kg
    }
})

local shield_mk3 = table.deepcopy(data.raw["item"]["energy-shield-mk2-equipment"])
shield_mk3.name = "energy-shield-mk3-equipment"
shield_mk3.icon = "__castra__/graphics/icons/energy-shield-mk3-equipment.png"
shield_mk3.place_as_equipment_result = "energy-shield-mk3-equipment"
order = "a[shield]-c[energy-shield-mk3-equipment]"
data:extend({ shield_mk3 })