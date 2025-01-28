data.raw["tile"]["nuclear-ground"].autoplace = {
    probability_expression = 'max(expression_in_range_base(-10, 0.25, 0.45, 0.3),\z
                                               expression_in_range_base(0.4, -10, 0.45, 0.25)) + noise_layer_noise(6)'
}

table.insert(water_tile_type_names, "light-oil-ocean-deep")

-- Copy the oil-ocean-deep and make light-oil-ocean-deep
local light_oil_ocean_deep = table.deepcopy(data.raw["tile"]["oil-ocean-deep"])
light_oil_ocean_deep.name = "light-oil-ocean-deep"
light_oil_ocean_deep.fluid = "light-oil"
light_oil_ocean_deep.autoplace = {
    probability_expression =
    "90 * fulgora_oil_mask * water_base(fulgora_coastline - 50 - fulgora_coastline_drop / 0.8, 1000)"
}
light_oil_ocean_deep.effect_color = { 240, 170, 40 }
light_oil_ocean_deep.effect_color_secondary = { 110, 76, 5 }
light_oil_ocean_deep.map_color = { 214/256, 127/256, 13/256 }
light_oil_ocean_deep.variants = tile_variations_template_with_transitions(
    "__castra__/graphics/terrain/light-oil-ocean-deep.png",
    {
        max_size = 4,
        [1] = { weights = { 0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
        [2] = { probability = 1, weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
        [4] = { probability = 0.1, weights = { 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
    }
)

data:extend({ light_oil_ocean_deep })

-- Add { data = 0.000001 } to all tiles absorptions_per_second
for _, tile in pairs(data.raw.tile) do
    if tile.absorptions_per_second then
        tile.absorptions_per_second.data = 0.000001
    else
        tile.absorptions_per_second = { data = 0.000001 }
    end
end
