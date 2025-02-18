local item_cache = require("__castra__.castra-cache")

-- Convert enemy entities on "castra" to their castra variant
-- flamethrower, laser-turret, railgun-turret
local function convert_enemy_entities(name)
    local surface = game.surfaces["castra"]
    if not surface then return end
    local new_name = "castra-enemy-" .. name
    for _, entity in pairs(surface.find_entities_filtered({ name = name, force = "enemy" })) do
        local quality = entity.quality or "normal"
        local new_entity = surface.create_entity({ name = new_name, position = entity.position, force = "enemy", quality = quality, direction = entity.direction, raise_built = true })
        if new_entity then
            -- Copy ammo inventory if it exists
            if entity.get_inventory(defines.inventory.turret_ammo) then
                local ammo_inventory = entity.get_inventory(defines.inventory.turret_ammo)
                if ammo_inventory then
                    -- Loop through get_contents and insert
                    for _, ammo in pairs(ammo_inventory.get_contents()) do
                        new_entity.insert({ name = ammo.name, count = ammo.count, quality = ammo.quality })
                    end
                end
            end

            -- Copy energy if it exists
            if entity.energy then
                new_entity.energy = entity.energy
            end

            entity.destroy()
        end
    end
end

convert_enemy_entities("flamethrower-turret")
convert_enemy_entities("laser-turret")
convert_enemy_entities("railgun-turret")
convert_enemy_entities("tesla-turret")

-- Rebuild storage.castra.dataCollectors with all data collectors on castra
local function populate_data_collectors()
    local surface = game.surfaces["castra"]
    if not surface then return end

    if not storage.castra then
        storage.castra = {}
    end
    storage.castra.dataCollectors = {}

    for _, entity in pairs(game.surfaces["castra"].find_entities_filtered({ name = "data-collector" })) do
        table.insert(storage.castra.dataCollectors, entity)
    end
end

populate_data_collectors()

-- Rebuild castra data collector roboportInRange
local function update_roboport_in_range()
    local surface = game.surfaces["castra"]
    if not surface then return end
    storage.castra = storage.castra or {}
    storage.castra.dataCollectors = storage.castra.dataCollectors or {}
    storage.castra.dataCollectorsRoboportStatus = {}

    for _, entity in pairs(storage.castra.dataCollectors) do
        if entity.valid then
            local roboport = entity.surface.find_entities_filtered({ force = "player", name = "roboport", position = entity.position, area = {{-55, -55}, {55, 55}} })
            if roboport and #roboport > 0 then
                storage.castra.dataCollectorsRoboportStatus[entity.unit_number] = true
            else
                storage.castra.dataCollectorsRoboportStatus[entity.unit_number] = false
            end
        end
    end
end

update_roboport_in_range()

item_cache.build_pollution_cache()

