local item_cache = require("castra-cache")
local base_gen = require("base-generator")
local base_upgrades = require("base-upgrades")

-- Event: on_chunk_generated
script.on_event(defines.events.on_chunk_generated, function(event)
    local surface = event.surface
    if surface.name == "castra" then
        -- Create an enemy base if there are any ores in the chunk
        local resources = surface.find_entities_filtered { type = "resource", area = event.area }
        local distance_from_center = math.sqrt(event.area.left_top.x ^ 2 + event.area.left_top.y ^ 2)
        if (#resources > 0 or math.random() < 0.04 * math.log(distance_from_center / 40, 5)) and distance_from_center > 200 then
            base_gen.create_enemy_base(event.area)
        end

        -- Remove decorations on light-oil-ocean-deep tiles and nuclear-ground
        local invalidTiles = surface.find_tiles_filtered { area = event.area, name = "light-oil-ocean-deep" }
        for _, tile in pairs(surface.find_tiles_filtered { area = event.area, name = "nuclear-ground" }) do
            table.insert(invalidTiles, tile)
        end

        -- Select 3 random tiles and remove decorations around it in 16 radius
        if #invalidTiles > 0 then
            for i = 1, 3 do
                local randomTile = invalidTiles[math.random(1, #invalidTiles)]
                surface.destroy_decoratives { area = { { x = randomTile.position.x - 16, y = randomTile.position.y - 16 },
                    { x = randomTile.position.x + 16, y = randomTile.position.y + 16 } } }
            end
        end
    end
end)

function get_surrounding_pollution(center)
    -- Get the pollution in a 3x3 chunk area
    local pollution = 0
    for x = -1, 1 do
        for y = -1, 1 do
            pollution = pollution + game.surfaces["castra"].get_pollution({ center.x + x * 32, center.y + y * 32 })
        end
    end
    return pollution
end

function on_data_collector_item_spawned(event)
    local pollution = get_surrounding_pollution(event.spawner.position)
    -- 90% chance to skip and destroy the item if pollution is less than 50
    if pollution < 50 and math.random() < 0.9 then
        event.entity.destroy()
        return
    end

    -- Look for any non-enemy roboports nearby
    local roboports = event.entity.surface.find_entities_filtered { name = "roboport", area = { { event.entity.position.x - 55, event.entity.position.y - 55 }, { event.entity.position.x + 55, event.entity.position.y + 55 } } }
    -- If there are, get the force of the first one and spawn the item on the ground with the force
    local force = nil
    for _, roboport in pairs(roboports) do
        if roboport.force.name ~= "enemy" then
            force = roboport.force
            break
        end
    end

    local quality = event.spawner.quality

    -- Check for any nearby item-on-ground entities so that we don't spawn too many items
    local items = event.entity.surface.find_entities_filtered { name = "item-on-ground", area = { { event.spawner.position.x - 5, event.spawner.position.y - 5 }, { event.spawner.position.x + 5, event.spawner.position.y + 5 } } }
    if #items < 200 then
        -- Spawn item on the ground with the suffix
        local item_name = string.gsub(event.entity.name, "data%-collector%-", "")
        event.entity.surface.spill_item_stack { position = event.spawner.position, stack = { name = item_name, count = 1, quality = quality }, enable_looted = true, allow_belts = true, force = force, max_radius = 5 }
    end

    -- Increase evolution by 0.0000015 / (evolution_factor * 2 + 1)
    local factor = 0.0000015 / (game.forces["enemy"].get_evolution_factor(event.entity.surface) * 2 + 1)
    event.entity.force.set_evolution_factor(game.forces["enemy"].get_evolution_factor(event.entity.surface) + factor,
        event.entity.surface)

    event.entity.destroy()
end

-- on_tick command to track all data-collector entities and keep in storage
local function on_tick_update_data_collectors(event)
    -- Check every 30000 ticks
    if event.tick % 30000 == 0 then
        if not item_cache.castra_exists() then
            return
        end

        -- Check if any no longer exist
        storage.castra = storage.castra or {}
        if storage.castra.dataCollectors then
            for i = #storage.castra.dataCollectors, 1, -1 do
                local dataCollector = storage.castra.dataCollectors[i]
                if not dataCollector.valid then
                    table.remove(storage.castra.dataCollectors, i)
                end
            end
        end

        local surface = game.surfaces["castra"]
        local dataCollectors = surface.find_entities_filtered { name = "data-collector" }
        for _, dataCollector in pairs(dataCollectors) do
            storage.castra.dataCollectors = storage.castra.dataCollectors or {}
            table.insert(storage.castra.dataCollectors, dataCollector)
        end
    end

    -- Check for any wandering tanks and give them a random command
    if event.tick % 3000 == 1500 then
        if not item_cache.castra_exists() then
            return
        end

        local surface = game.surfaces["castra"]
        local tanks = surface.find_entities_filtered { name = "castra-enemy-tank" }
        for _, tank in pairs(tanks) do
            if tank.commandable and tank.commandable.command and tank.commandable.command.type == defines.command.wander then
                give_tank_random_command(tank)
            end
        end
    end
end

function give_tank_random_command(tank)
    -- 80% to wander
    -- 5% to make a new base
    -- 10% to move to another data collector
    -- 4% to attack a player military entity nearby
    -- 1% to attack nearest player entity nearby

    if not tank.valid then
        return
    end

    local randSelection = math.random()
    if randSelection < 0.80 then
        -- Wander
        tank.commandable.set_command { type = defines.command.wander, distraction = defines.distraction.by_anything, ticks_to_wait = math.random(600, 5000) }
        return
    elseif randSelection < 0.85 then
        -- Expansion
        -- Check if there are any nearby data collectors
        local dataCollectors = tank.surface.find_entities_filtered { name = "data-collector", area = { { tank.position.x - 30, tank.position.y - 30 }, { tank.position.x + 30, tank.position.y + 30 } } }
        if #dataCollectors == 0 then
            local area = { left_top = { x = tank.position.x - 15, y = tank.position.y - 15 }, right_bottom = { x = tank.position.x + 15, y = tank.position.y + 15 } }
            base_gen.create_enemy_base(area)
        end
        -- Wander again
        tank.commandable.set_command { type = defines.command.wander, distraction = defines.distraction.by_anything, ticks_to_wait = math.random(600, 5000) }
    elseif randSelection < 0.95 then
        -- Pick a random data collector to go to from storage
        if storage.castra and storage.castra.dataCollectors then
            local dataCollector = storage.castra.dataCollectors[math.random(1, #storage.castra.dataCollectors)]
            if dataCollector.valid then
                tank.commandable.set_command { type = defines.command.go_to_location, destination = dataCollector.position, distraction = defines.distraction.by_anything }
                return
            end
        end
    elseif randSelection < 0.99 then
        -- Find a player military entity nearby
        local playerForce = game.forces["player"]
        local entities = tank.surface.find_entities_filtered { force = playerForce, area = { { tank.position.x - 100, tank.position.y - 100 }, { tank.position.x + 100, tank.position.y + 100 } } }
        for _, entity in pairs(entities) do
            if entity.is_military_target then
                tank.commandable.set_command { type = defines.command.attack_area, destination = entity.position, radius = 8, distraction = defines.distraction.by_anything }
                return
            end
        end
    else
        -- Find the nearest player entity
        local closest = tank.surface.find_nearest_enemy { position = tank.position, force = tank.force, max_distance = 500 }
        if closest then
            tank.commandable.set_command { type = defines.command.attack_area, destination = closest.position, radius = 8, distraction = defines.distraction.by_anything }
            return
        end
    end

    -- Default to wander
    tank.commandable.set_command { type = defines.command.wander, distraction = defines.distraction.by_anything, ticks_to_wait = math.random(600, 5000) }
end

-- on_entity_spawned for deleting data-collector-<item> when it spawns and dropping its loot
script.on_event(defines.events.on_entity_spawned, function(event)
    item_cache.build_cache_if_needed()

    -- check if name starts with data-collector-
    if string.find(event.entity.name, "data%-collector%-") then
        on_data_collector_item_spawned(event)
        return
    end

    if event.entity.name == "castra-enemy-tank" and event.spawner.name == "data-collector" then
        -- If the tank is not yet unlocked, destroy it
        if not storage.castra.enemy.tank then
            event.entity.destroy()
            return
        end
        give_tank_random_command(event.entity)
    end
end)

local function get_castra_research_speed()
    item_cache.build_cache_if_needed()

    if not item_cache.castra_exists() then
        return 0
    end

    local evolution = game.forces["enemy"].get_evolution_factor("castra")
    -- 90/minute at 100% evolution
    local research_speed = evolution * 90

    -- Include lab research speed tech bonus and lab productivity
    research_speed = research_speed * (1 + game.forces["enemy"].laboratory_speed_modifier)
    research_speed = research_speed * (1 + game.forces["enemy"].laboratory_productivity_bonus)

    -- Include a bonus based on speed module tier: 1 = 5%, 2 = 10%, 3 = 20%
    if storage.castra.enemy.speed_module_tier then
        if storage.castra.enemy.speed_module_tier == 1 then
            research_speed = research_speed * 1.05
        elseif storage.castra.enemy.speed_module_tier == 2 then
            research_speed = research_speed * 1.10
        elseif storage.castra.enemy.speed_module_tier == 3 then
            research_speed = research_speed * 1.20
        end
    end

    -- Include les a bonus based on productivity module tier: 1 = 2%, 2 = 4%, 3 = 7%
    if storage.castra.enemy.productivity_module_tier then
        if storage.castra.enemy.productivity_module_tier == 1 then
            research_speed = research_speed * 1.02
        elseif storage.castra.enemy.productivity_module_tier == 2 then
            research_speed = research_speed * 1.04
        elseif storage.castra.enemy.productivity_module_tier == 3 then
            research_speed = research_speed * 1.07
        end
    end

    -- Include bonus from quality
    if storage.castra.enemy.quality_tier then
        research_speed = research_speed * (1 + storage.castra.enemy.quality_tier.level * 0.08)
    end

    -- Factor in current research unit count
    -- #enemy_force.current_research.research_unit_ingredients
    if game.forces["enemy"].current_research then
        local current_research = game.forces["enemy"].current_research
        if current_research.research_unit_ingredients then
            research_speed = research_speed / (math.log(#current_research.research_unit_ingredients, 2) + 1)
        end
    end

    -- Minimum of 5
    if research_speed < 5 then
        research_speed = 5
    end

    return research_speed
end

local function unlock_research_up_to(technology_name)
    local force = game.forces["enemy"]
    local tech = force.technologies[technology_name]
    if tech then
        tech.researched = true
        if tech.prerequisites then
            for _, prereq in pairs(tech.prerequisites) do
                unlock_research_up_to(prereq.name)
            end
        end
    end
end

local trigger_research = nil

--on_tick update enemy research progress based on the evolution on castra
local function update_castra_research_progress(event)
    if event.tick % 3600 == 0 then
        if not item_cache.castra_exists() then
            return
        end

        local enemy_force = game.forces["enemy"]
        enemy_force.enable_research()
        local research_speed = get_castra_research_speed()
        -- Update Research progress based on the current research units count
        local current_research_units = 0
        if enemy_force.current_research then
            if enemy_force.current_research.prototype.research_trigger then
                current_research_units = 10
            else
                current_research_units = enemy_force.current_research.research_unit_count
            end
        end

        local completed_tech = false
        if current_research_units > 0 then
            local progress = enemy_force.research_progress * current_research_units + research_speed
            if progress / current_research_units >= 1 then
                game.forces["player"].print("Castra enemies have completed [technology=" ..
                    enemy_force.current_research.name .. ",level=" .. enemy_force.current_research.level .. "]")
                enemy_force.current_research.researched = true
                -- Infinite techs will not be cleared so we need to manually clear the progress
                if enemy_force.current_research then
                    enemy_force.current_research.saved_progress = 0
                    while enemy_force.current_research do
                        enemy_force.cancel_current_research()
                    end
                end
                item_cache.update_castra_enemy_data()
                completed_tech = true
            else
                enemy_force.research_progress = progress / current_research_units
            end
        end

        if enemy_force.current_research == nil or completed_tech then
            -- Unlock gun-turret and stone-wall if they exist and have not been unlocked
            if prototypes.technology["gun-turret"] and not enemy_force.technologies["gun-turret"].researched then
                unlock_research_up_to("gun-turret")
                item_cache.update_castra_enemy_data()
            end
            if prototypes.technology["stone-wall"] and not enemy_force.technologies["stone-wall"].researched then
                unlock_research_up_to("stone-wall")
                item_cache.update_castra_enemy_data()
            end

            -- Find any researches that have not been fully researched and have all prerequisites
            local valid = {}
            for _, research in pairs(enemy_force.technologies) do
                if (not research.researched or research.level < research.prototype.max_level) and research.enabled then
                    local allPrereqs = true
                    for _, prereq in pairs(research.prerequisites) do
                        if not prereq.researched then
                            allPrereqs = false
                            break
                        end
                    end

                    -- Check that they have all the science packs
                    local allSciencePacks = true
                    for _, ingredient in pairs(research.research_unit_ingredients) do
                        if not item_cache.has_castra_researched_item(ingredient.name) then
                            allSciencePacks = false
                            break
                        end
                    end

                    if allPrereqs and allSciencePacks then
                        table.insert(valid, research)
                    end
                end
            end

            if #valid == 0 then
                return
            end

            local nextResearch = nil
            if trigger_research then
                nextResearch = trigger_research
            else
                -- Pick a random strategy
                -- 0-5 = lowest cost
                -- 6-20 = random
                -- 21 = highest cost
                local strategy = math.random(0, 21)
                if strategy >= 0 and strategy <= 5 then
                    table.sort(valid, function(a, b)
                        return a.research_unit_count < b.research_unit_count
                    end)
                    nextResearch = valid[1]
                elseif strategy >= 6 and strategy <= 20 then
                    nextResearch = valid[math.random(1, #valid)]
                elseif strategy == 21 then
                    table.sort(valid, function(a, b)
                        return a.research_unit_count > b.research_unit_count
                    end)
                    nextResearch = valid[1]
                end
            end

            if nextResearch == nil then
                return
            end

            if nextResearch.prototype.research_trigger then
                trigger_research = nextResearch
            end

            -- If it's a trigger research, it can't be queued, so update it's status now
            -- Skip if already completed a tech this tick
            if trigger_research and not completed_tech then
                local progress = nextResearch.saved_progress * 10 + research_speed
                if progress >= 10 then
                    game.forces["player"].print("Castra enemies have completed [technology=" ..
                        nextResearch.name .. ",level=" .. nextResearch.level .. "]")
                    nextResearch.researched = true
                    item_cache.update_castra_enemy_data()
                    trigger_research = nil
                else
                    nextResearch.saved_progress = progress / 10
                end
            else
                enemy_force.add_research(nextResearch)
                -- If the player has monitoring research has been completed, show the next one
                if game.forces["player"] and
                    game.forces["player"].technologies and
                    game.forces["player"].technologies["castra-enemy-research"] and
                    game.forces["player"].technologies["castra-enemy-research"].researched then
                    game.forces["player"].print("Castra enemies have started [technology=" .. nextResearch.name .. ",level=" .. nextResearch.level .. "]")
                end
            end
        end
    end
end

-- Every 10 seconds, for every combat roboport, check if there are any enemies nearby and spawn 5 combat robots
local function update_combat_roboports(event)
    if event.tick % 600 == 0 then
        storage.castra = storage.castra or {}
        storage.castra.combat_roboports = storage.castra.combat_roboports or {}
        -- Loop through all combat roboports
        for _, roboport in pairs(storage.castra.combat_roboports) do
            if roboport.valid then
                -- Get the opposite force
                local enemy_force = roboport.force.name == "enemy" and game.forces["player"] or game.forces["enemy"]

                -- Find any enemies within 10 tiles
                local enemies = roboport.surface.find_entities_filtered { force = enemy_force, area = { { roboport.position.x - 10, roboport.position.y - 10 }, { roboport.position.x + 10, roboport.position.y + 10 } }, is_military_target = true }
                if #enemies > 0 then
                    -- Check inventory if it's a valid combat robot
                    local combat_robot = nil
                    local inventory = roboport.get_inventory(defines.inventory.chest)
                    if inventory and inventory[1] and inventory[1].valid and inventory[1].name and
                        (inventory[1].name == "destroyer-capsule" or
                            inventory[1].name == "distractor-capsule" or
                            inventory[1].name == "defender-capsule") then
                        -- Remove the capsule part of the name
                        combat_robot = string.gsub(inventory[1].name, "-capsule", "")
                    end

                    if combat_robot then
                        -- Spawn 5 + quality combat robots
                        for i = 1, 5 + roboport.quality.level do
                            -- Randomize the position
                            local pos = {
                                x = roboport.position.x + math.random(-2, 2),
                                y = roboport.position.y +
                                    math.random(-2, 2)
                            }
                            local robot = roboport.surface.create_entity { name = combat_robot, position = pos, force = roboport.force }

                            -- Pick a random enemy to be their "owner"
                            local enemy = enemies[math.random(1, #enemies)]
                            if enemy.valid then
                                robot.combat_robot_owner = enemy
                            else
                                robot.combat_robot_owner = roboport
                            end
                        end
                        -- Remove 1 combat robot from the inventory
                        inventory[1].count = inventory[1].count - 1
                    end
                end
            end
        end
    end
end

-- on_built_entity for combat roboports
script.on_event(defines.events.on_built_entity, function(event)
    if event.entity.name == "combat-roboport" then
        storage.castra.combat_roboports = storage.castra.combat_roboports or {}
        table.insert(storage.castra.combat_roboports, event.entity)
    end
end)

local function get_available_upgrades()
    item_cache.build_cache_if_needed()
    local upgrades = {}
    if storage.castra.enemy.gun_turret then
        table.insert(upgrades, base_upgrades.add_turrets)
    end
    if storage.castra.enemy.wall_tier then
        table.insert(upgrades, base_upgrades.add_walls)
    end
    if storage.castra.enemy.roboport then
        table.insert(upgrades, base_upgrades.add_roboport)
    end
    if storage.castra.enemy.land_mine then
        table.insert(upgrades, base_upgrades.add_land_mines)
    end
    if storage.castra.enemy.solar_panel then
        table.insert(upgrades, base_upgrades.add_solar)
    end
    if storage.castra.enemy.quality_tier and storage.castra.enemy.quality_tier.level > 0 then
        table.insert(upgrades, base_upgrades.upgrade_quality)
    end
    return upgrades
end

local function randomly_upgrade_base(event)
    -- Every 5 minutes, randomly upgrade either 5% of the bases or 20 bases, whichever is lower. and at least 5
    if event.tick % 18000 == 0 then
        if not item_cache.castra_exists() then
            return
        end
        local possible = get_available_upgrades()
        if #possible == 0 then
            return
        end

        local surface = game.surfaces["castra"]
        local dataCollectors = surface.find_entities_filtered { name = "data-collector", force = "enemy" }
        if #dataCollectors > 0 then
            local count = math.max(math.min(#dataCollectors, 5), math.min(20, math.floor(#dataCollectors * 0.05)))
            for i = 1, count do
                local dataCollector = dataCollectors[math.random(1, #dataCollectors)]
                if dataCollector.valid then
                    local upgrade_type = possible[math.random(1, #possible)]
                    local position = dataCollector.position
                    upgrade_type(dataCollector)
                    -- If the data collector is no longer valid, its quality was upgraded and we need to find a new one at its position
                    if not dataCollector.valid then
                        dataCollectors = surface.find_entities_filtered { name = "data-collector", force = "enemy", position = position }
                        if #dataCollectors == 0 then
                            break
                        end
                        dataCollector = dataCollectors[1]
                    end
                    base_upgrades.fill_roboports(dataCollector)
                    base_upgrades.fill_turrets(dataCollector)
                end
            end
        end
    end
end

-- on_tick for updating the combat roboport storage
script.on_event(defines.events.on_tick, function(event)
    update_castra_research_progress(event)
    on_tick_update_data_collectors(event)
    update_combat_roboports(event)
    randomly_upgrade_base(event)

    -- Every 13 minutes
    if event.tick % 46800 == 0 then
        storage.castra.combat_roboports = storage.castra.combat_roboports or {}
        for i = #storage.castra.combat_roboports, 1, -1 do
            if not storage.castra.combat_roboports[i].valid then
                table.remove(storage.castra.combat_roboports, i)
            end
        end

        -- Check for any combat roboports on any surface
        for _, surface in pairs(game.surfaces) do
            local combatRoboports = surface.find_entities_filtered { name = "combat-roboport" }
            for _, roboport in pairs(combatRoboports) do
                storage.castra.combat_roboports = storage.castra.combat_roboports or {}
                -- Only add if it's not already in the list
                local found = false
                for _, storedRoboport in pairs(storage.castra.combat_roboports) do
                    if storedRoboport == roboport then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(storage.castra.combat_roboports, roboport)
                end
            end
        end
    end
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
    -- Send the player a message an update on the enemy research progress
    if event.prototype_name == "castra-enemy-research" then
        local player = game.players[event.player_index]
        local surface = game.surfaces["castra"]
        if not item_cache.castra_exists() then
            player.print("Castra is not available.")
            return
        end

        -- Check for player radars with power
        local radars = surface.find_entities_filtered { name = "radar", force = player.force }
        local hasRadar = false
        for _, radar in pairs(radars) do
            if radar.energy > 0 then
                hasRadar = true
                break
            end
        end
        if not hasRadar then
            player.print("You need a powered radar on Castra to get an update on enemy research progress.")
            return
        end

        local enemy_force = game.forces["enemy"]
        local research_speed = math.floor(get_castra_research_speed() * 100) / 100
        local current_research_progress = 0
        if enemy_force.current_research then
            current_research_progress = math.floor(enemy_force.research_progress * 10000) / 100
            player.print("Currently researching: [technology=" ..
                enemy_force.current_research.name .. ",level=" .. enemy_force.current_research.level .. "] " .. current_research_progress .. "% at " .. research_speed .. "/m")
        elseif trigger_research then
            player.print("Currently researching: [technology=" ..
                trigger_research.name .. ",level=" .. trigger_research.level .. "]")
        else
            player.print("Currently researching nothing, or a trigger technology.")
        end
    end
end)
