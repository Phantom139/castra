local function update_description(entity, amount)
    local description = {""}
    table.insert(description, "\n")
    table.insert(description, {"entity-description.data-emission"})
    table.insert(description, amount)
    table.insert(description, "/m")
    if not entity.localised_description then
        entity.localised_description = {"", {"?", {"", {"entity-description." .. entity.name}}, "" }, description }
    else
        entity.localised_description = {"", entity.localised_description, description }
    end
end

local function set_data_emission_per_min(entity, amount)
    entity.energy_source = entity.energy_source or {}
    if entity.energy_source.emissions_per_minute then
        table.insert(entity.energy_source.emissions_per_minute, { data = amount })
    else
        entity.energy_source.emissions_per_minute = { data = amount }
    end
    
    update_description(entity, tostring(amount))
end

local function set_data_emission_per_sec(entity, amount)
    entity.emissions_per_second = entity.emissions_per_second or {}
    if entity.emissions_per_second.data then
        table.insert(entity.emissions_per_second, { data = amount })
    else
        entity.emissions_per_second = { data = amount }
    end

    update_description(entity, tostring(amount * 60))
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
