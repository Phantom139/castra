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

-- Rebuild artillery turrets
storage.castra.enemy_artillery = {}
for _, entity in pairs(game.surfaces["castra"].find_entities_filtered({ name = "artillery-turret", force="enemy" })) do
    table.insert(storage.castra.enemy_artillery, entity)
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