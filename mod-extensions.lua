-- Script extensions for mods.
local item_cache = require("castra-cache")

-- RC Car commands
function give_RC_Car_random_command(rcCar, selection)
    -- 60% to wander
    -- 10% to move to another data collector
    -- 15% to attack a player military entity nearby
    -- 15% to attack nearest player entity nearby

    if not rcCar.valid then
        return
    end

    local randSelection = selection or item_cache.castra_rng(0, 1)
    if randSelection < 0.60 then
        -- Wander
        rcCar.commandable.set_command { type = defines.command.wander, distraction = defines.distraction.by_anything, ticks_to_wait = item_cache.castra_rng(600, 5000) }
        return
    elseif randSelection < 0.70 then
        -- Pick a random data collector to go to from storage
        if storage.castra and storage.castra.dataCollectors and #storage.castra.dataCollectors > 0 then
            local dataCollector = storage.castra.dataCollectors[item_cache.castra_rng(1, #storage.castra.dataCollectors)]
            if dataCollector.valid then
                rcCar.commandable.set_command { type = defines.command.go_to_location, destination = dataCollector.position, distraction = defines.distraction.by_anything }
                return
            end
        end
    elseif randSelection < 0.85 then
        -- Find a player military entity nearby
        local playerForce = game.forces["player"]
        local entities = rcCar.surface.find_entities_filtered { force = playerForce, area = { { rcCar.position.x - 100, rcCar.position.y - 100 }, { rcCar.position.x + 100, rcCar.position.y + 100 } } }
        for _, entity in pairs(entities) do
            if entity.valid and entity.is_military_target then
                rcCar.commandable.set_command { type = defines.command.attack_area, destination = entity.position, radius = 8, distraction = defines.distraction.by_anything }
                return
            end
        end
    else
        -- Find the nearest player entity
        local closest = rcCar.surface.find_nearest_enemy { position = rcCar.position, force = rcCar.force, max_distance = 500 }
        if closest then
            rcCar.commandable.set_command { type = defines.command.attack_area, destination = closest.position, radius = 8, distraction = defines.distraction.by_anything }
            return
        end
    end

    -- Default to wander
    rcCar.commandable.set_command { type = defines.command.wander, distraction = defines.distraction.by_anything, ticks_to_wait = item_cache.castra_rng(600, 5000) }
end

return {
    give_RC_Car_random_command = give_RC_Car_random_command
}