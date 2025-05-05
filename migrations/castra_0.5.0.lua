local surface = game.surfaces["castra"]
if not surface then return end

if not storage.castra then
    storage.castra = {}
end

-- Rebuild data collectors
storage.castra.dataCollectors = {}
for _, entity in pairs(game.surfaces["castra"].find_entities_filtered({ name = "data-collector", force="enemy" })) do
    table.insert(storage.castra.dataCollectors, entity)
end

-- Rebuild jammed data collectors
storage.castra.jammed_data_collectors = {}
for _, entity in pairs(game.surfaces["castra"].find_entities_filtered({ name = "jammed-data-collector", force="player" })) do
    table.insert(storage.castra.jammed_data_collectors, entity)
end

-- Rebuild jammers
storage.castra.jammers = {}
for _, entity in pairs(game.surfaces["castra"].find_entities_filtered({ name = "jammer-radar", force="player" })) do
    table.insert(storage.castra.jammers, entity)
end

local function get_search_area_size(data_collector, size)
    return {
        left_top = { x = data_collector.position.x - size, y = data_collector.position.y - size },
        right_bottom = { x = data_collector.position.x + size, y = data_collector.position.y + size }
    }
end

local function get_jamming_range(quality)
    if not quality then
        return 30
    end
    return math.floor(30 + quality.level * 1.5)
end

local function add_jammer_to_data_collector(data_collector, jammer)
    if not data_collector or not jammer then
        return
    end
    if not data_collector.valid or not jammer.valid then
        return
    end

    -- If the jammer's quality < data collector's quality, ignore
    if jammer.quality.level < data_collector.quality.level then
        return
    end

    local is_jammer_data_collector = data_collector.name == "jammed-data-collector"
    
    -- Account for data collector's size
    local range = get_jamming_range(jammer.quality) + 3
    if data_collector.valid and math.abs(data_collector.position.x - jammer.position.x) <= range and math.abs(data_collector.position.y - jammer.position.y) <= range then
        local jammers = {}
        if is_jammer_data_collector then
            jammers = storage.castra.jammed_data_collectors_jammers[data_collector.unit_number] or {}
        else
            jammers = storage.castra.data_collectors_jammers[data_collector.unit_number] or {}
        end
        table.insert(jammers, jammer)
        if is_jammer_data_collector then
            storage.castra.jammed_data_collectors_jammers[data_collector.unit_number] = jammers
        else
            storage.castra.data_collectors_jammers[data_collector.unit_number] = jammers
        end
    end
end

-- Add any player jammer radars in range
storage.castra.data_collectors_jammers = {}
storage.castra.jammed_data_collectors_jammers = {}
for _, jammer in pairs(storage.castra.jammers) do
    for _, data_collector in pairs(storage.castra.dataCollectors) do
        if data_collector.valid then
            local area = get_search_area_size(data_collector, 30)
            if data_collector.surface == jammer.surface and data_collector.position.x >= area.left_top.x and data_collector.position.x <= area.right_bottom.x and data_collector.position.y >= area.left_top.y and data_collector.position.y <= area.right_bottom.y then
                add_jammer_to_data_collector(data_collector, jammer)
            end
        end
    end

    for _, data_collector in pairs(storage.castra.jammed_data_collectors) do
        if data_collector.valid then
            local area = get_search_area_size(data_collector, 30)
            if data_collector.surface == jammer.surface and data_collector.position.x >= area.left_top.x and data_collector.position.x <= area.right_bottom.x and data_collector.position.y >= area.left_top.y and data_collector.position.y <= area.right_bottom.y then
                add_jammer_to_data_collector(data_collector, jammer)
            end
        end
    end
end

-- Rebuild combat roboports from every surface
storage.castra.combat_roboports = {}
for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered({ name = "combat-roboport" })) do
        table.insert(storage.castra.combat_roboports, entity)
    end
end

-- Rebuild enemy data
local item_cache = require("__castra__.castra-cache")
item_cache.update_castra_enemy_data()