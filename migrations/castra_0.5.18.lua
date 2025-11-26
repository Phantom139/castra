-- Castra migration: 0.5.18
-- Safely removes invalid or unwanted entities and rebuilds caches

local surface = game.surfaces["castra"]
if not surface then return end

local item_cache = require("__castra__.castra-cache")

local CLUSTER_RADIUS = 32                 -- collectors considered overlapping
local BASE_CLEAN_RADIUS = 48              -- wipe bases in this range around invalid collectors
local CLUSTER_RADIUS_SQ = CLUSTER_RADIUS * CLUSTER_RADIUS
local BASE_CLEAN_RADIUS_SQ = BASE_CLEAN_RADIUS * BASE_CLEAN_RADIUS

----------------------------------------------------------------------
-- 1. Remove all player-owned combat roboports
----------------------------------------------------------------------

for _, ent in pairs(surface.find_entities_filtered{
    name = "combat-roboport",
    force = "player"
}) do
    if ent.valid then
        ent.destroy()
    end
end

----------------------------------------------------------------------
-- 2. Wipe map of enemy units
----------------------------------------------------------------------

for _, ent in pairs(surface.find_entities_filtered{
    name = "castra-enemy-tank", "castra-enemy-car", "castra-enemy-explosive-rc",
    force = "enemy"
}) do
    if ent.valid then
        ent.destroy()
    end
end

----------------------------------------------------------------------
-- 3. Cleanup duplicate / overlapping data collectors
--    (This helps fix old worlds where the old RNG bug created clusters)
----------------------------------------------------------------------

local collectors = {}
for _, dc in pairs(surface.find_entities_filtered{
    name = "data-collector",
    force = "enemy"
}) do
    if dc.valid then
        table.insert(collectors, dc)
    end
end

local clusters = {}

for _, dc in ipairs(collectors) do
    if dc.valid then
        local placed = false

        for _, cluster in ipairs(clusters) do
            for _, other in ipairs(cluster) do
                if other.valid then
                    local dx = dc.position.x - other.position.x
                    local dy = dc.position.y - other.position.y
                    if dx*dx + dy*dy <= CLUSTER_RADIUS_SQ then
                        table.insert(cluster, dc)
                        placed = true
                        break
                    end
                end
            end
            if placed then break end
        end

        if not placed then
            table.insert(clusters, { dc })
        end
    end
end


for _, cluster in pairs(clusters) do
    local cx, cy, n = 0, 0, 0
    for _, dc in pairs(cluster) do
        if dc.valid then
            cx = cx + dc.position.x
            cy = cy + dc.position.y
            n = n + 1
        end
    end
    if n == 0 then goto continue_cluster end
    cx, cy = cx / n, cy / n

    -- find farthest collector
    local keep = nil
    local max_d2 = -1
    for _, dc in pairs(cluster) do
        if dc.valid then
            local dx = dc.position.x - cx
            local dy = dc.position.y - cy
            local d2 = dx*dx + dy*dy
            if d2 > max_d2 then
                max_d2 = d2
                keep = dc
            end
        end
    end

    --------------------------------------------------------
    -- Delete bases around all other collectors in cluster
    --------------------------------------------------------
    for _, dc in pairs(cluster) do
        if dc.valid and dc ~= keep then
            local px, py = dc.position.x, dc.position.y

            -- 1. Delete the collector itself
            dc.destroy()

            -- 2. Delete the ENTIRE base within BASE_CLEAN_RADIUS
            local ents = surface.find_entities_filtered{
                area = {
                    { px - BASE_CLEAN_RADIUS, py - BASE_CLEAN_RADIUS },
                    { px + BASE_CLEAN_RADIUS, py + BASE_CLEAN_RADIUS }
                },
                force = "enemy"
            }

            for _, e in pairs(ents) do
                if e.valid then
                    -- double-check distance (circle, not square)
                    local dx = e.position.x - px
                    local dy = e.position.y - py
                    if dx*dx + dy*dy <= BASE_CLEAN_RADIUS_SQ then
                        e.destroy()
                    end
                end
            end
        end
    end

    ::continue_cluster::
end

----------------------------------------------------------------------
-- 4. Rebuild all Castra enemy data (research, turrets, etc.)
----------------------------------------------------------------------

item_cache.update_castra_enemy_data()

----------------------------------------------------------------------
-- 5. Clear stale storage tables then repopulate cleanly
----------------------------------------------------------------------

storage.castra.dataCollectors = nil
storage.castra.combat_roboports = nil
storage.castra.jammers = nil

local function get_jamming_range(quality)
    if not quality then
        return 30
    end
    return math.floor(30 + quality.level * 1.5)
end

local function get_combat_roboport_range(quality)
    if not quality then
        return 35
    end
    return 35 + (2 * quality.level)
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

-- Re-scan the world for valid Castra-related entities
for _, entity in pairs(surface.find_entities_filtered{force = "enemy"}) do
    if entity.valid then
        local name = entity.name

        if name == "data-collector" then
            storage.castra.dataCollectors = storage.castra.dataCollectors or {}
            table.insert(storage.castra.dataCollectors, entity)		

            -- Add any player jammer radars in range
            storage.castra = storage.castra or {}
            storage.castra.data_collectors_jammers = storage.castra.data_collectors_jammers or {}
            storage.castra.jammed_data_collectors_jammers = storage.castra.jammed_data_collectors_jammers or {}
            storage.castra.jammers = storage.castra.jammers or {}			
			
            for _, jammer in pairs(storage.castra.jammers) do
                add_jammer_to_data_collector(entity, jammer)
            end
        elseif name == "combat-roboport" then
			storage.castra = storage.castra or {}
			storage.castra.combat_roboports = storage.castra.combat_roboports or {}
            table.insert(storage.castra.combat_roboports, entity)
        end
    end
end

for _, entity in pairs(surface.find_entities_filtered{force = "player"}) do
	if entity.valid then
		if name == "jammed-data-collector" then
            storage.castra.jammed_data_collectors = storage.castra.jammed_data_collectors or {}
            table.insert(storage.castra.jammed_data_collectors, entity)

            -- Add any player jammer radars in range
            storage.castra = storage.castra or {}
            storage.castra.data_collectors_jammers = storage.castra.data_collectors_jammers or {}						
            storage.castra.jammed_data_collectors_jammers = storage.castra.jammed_data_collectors_jammers or {}					
            storage.castra.jammers = storage.castra.jammers or {}			
			
            for _, jammer in pairs(storage.castra.jammers) do
                add_jammer_to_data_collector(entity, jammer)
            end		
		elseif name == "jammer-radar" then
            storage.castra = storage.castra or {}
            storage.castra.jammers = storage.castra.jammers or {}
            table.insert(storage.castra.jammers, entity)

            -- Find enemy data collectors in box range
            storage.castra.data_collectors_jammers = storage.castra.data_collectors_jammers or {}
            local dataCollectors = storage.castra.dataCollectors or {}
            for _, dataCollector in pairs(dataCollectors) do
                add_jammer_to_data_collector(dataCollector, entity)
            end

            local jammedDataCollectors = storage.castra.jammed_data_collectors or {}
            for _, dataCollector in pairs(jammedDataCollectors) do
                add_jammer_to_data_collector(dataCollector, entity)
            end		
		end
	end
end

----------------------------------------------------------------------
-- Migration complete
----------------------------------------------------------------------
game.print("[Castra] Migration 0.5.18 complete — cleaned invalid entities.")