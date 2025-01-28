local function set_data_emission_per_min(entity, amount)
    entity.energy_source = entity.energy_source or {}
    if entity.energy_source.emissions_per_minute then
        table.insert(entity.energy_source.emissions_per_minute, { data = amount })
    else
        entity.energy_source.emissions_per_minute = { data = amount }
    end
end

local function set_data_emission_per_sec(entity, amount)
    entity.emissions_per_second = entity.emissions_per_second or {}
    if entity.emissions_per_second.data then
        table.insert(entity.emissions_per_second, { data = amount })
    else
        entity.emissions_per_second = { data = amount }
    end
end

set_data_emission_per_min(data.raw["roboport"]["roboport"], 10)
set_data_emission_per_min(data.raw["radar"]["radar"], 20)
set_data_emission_per_sec(data.raw["lab"]["lab"], 20.0 / 60.0)
set_data_emission_per_sec(data.raw["lab"]["biolab"], 30.0 / 60.0)
set_data_emission_per_sec(data.raw["cargo-landing-pad"]["cargo-landing-pad"], 50.0 / 60.0)
set_data_emission_per_sec(data.raw["rocket-silo"]["rocket-silo"], 30.0 / 60.0)

-- Inserters emit data pollution
for _, inserter in pairs(data.raw["inserter"]) do
    set_data_emission_per_sec(inserter, 0.1 / 60.0)
end

-- Update furnace result slot counts to at least 3
for _, furnace in pairs(data.raw["furnace"]) do
    if furnace.result_inventory_size < 3 then
        furnace.result_inventory_size = 3
    end
end

-- Set belts as military targets
for _, belt in pairs(data.raw["transport-belt"]) do
    belt.is_military_target = true
end

for _, belt in pairs(data.raw["underground-belt"]) do
    belt.is_military_target = true
end

for _, belt in pairs(data.raw["splitter"]) do
    belt.is_military_target = true
end

for _, loader in pairs(data.raw["loader"]) do
    loader.is_military_target = true
end

-- Set roboports as military targets
for _, roboport in pairs(data.raw["roboport"]) do
    roboport.is_military_target = true
end

-- Set walls as military targets
for _, wall in pairs(data.raw["wall"]) do
    wall.is_military_target = true
end
