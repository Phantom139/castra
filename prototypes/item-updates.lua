-- Update foundation place_as_tile condition to include light-oil-ocean-deep
if data.raw["item"]["foundation"] then
    if data.raw["item"]["foundation"].place_as_tile then
        if not data.raw["item"]["foundation"].place_as_tile.tile_condition then
            data.raw["item"]["foundation"].place_as_tile.tile_condition = {}
        end
        table.insert(data.raw["item"]["foundation"].place_as_tile.tile_condition, "light-oil-ocean-deep")
    end
end