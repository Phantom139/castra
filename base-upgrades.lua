local item_cache = require("castra-cache")
local base_gen = require("base-generator")

local function get_search_area_size(data_collector, size)
    return {
        left_top = { x = data_collector.position.x - size, y = data_collector.position.y - size },
        right_bottom = { x = data_collector.position.x + size, y = data_collector.position.y + size }
    }
end

local function get_search_area(data_collector)
    return get_search_area_size(data_collector, 10)
end

local function find_missing_powered_entities(data_collector)
    local area = get_search_area_size(data_collector, 30)
    local entities = data_collector.surface.find_entities_filtered { area = area, force = "enemy" }
    local missing_powered_entities = {}
    for _, entity in pairs(entities) do
        if entity.valid and entity.electric_buffer_size and entity.electric_buffer_size > 0 and not entity.is_connected_to_electric_network then
            table.insert(missing_powered_entities, entity)
        end
    end
    return missing_powered_entities
end

local function add_walls(data_collector)
    -- Get 20x20 area around the collector
    local area = get_search_area(data_collector)
    -- If there are over 20 walls, don't add more
    if #data_collector.surface.find_entities_filtered { area = get_search_area_size(data_collector, 30), type = "wall" } > 20 then
        return
    end

    base_gen.create_enemy_base(area)
end

local function hyphen_to_underscore(str)
    return string.gsub(str, "-", "_")
end

local function add_turrets(data_collector)
    item_cache.build_cache_if_needed()
    -- Select a random turret type
    local turret_types = { "gun-turret", "laser-turret", "rocket-turret", "railgun-turret",
    "tesla-turret", "combat-roboport", "flamethrower-turret", "artillery-turret" }
	if settings.startup["castra-edits-extend-Cannons"].value then
		table.insert(turret_types, "vtk-cannon-turret")
		table.insert(turret_types, "vtk-cannon-turret-heavy")
	end
	if settings.startup["castra-edits-extend-GrenadeLauncher"].value then
		table.insert(turret_types, "PLORD_gl_40mm_turret")
	end	

    -- Remove any unresearched turrets, and artillery-turret if not allowed.
    for i = #turret_types, 1, -1 do
        if not item_cache[hyphen_to_underscore(turret_types[i])] then
            table.remove(turret_types, i)
        end
		if turret_types[i] == "artillery-turret" and not settings.startup["castra-enemy-allowed-artillery"].value then
			table.remove(turret_types, i)
		end		
    end

    if #turret_types == 0 then
        return
    end

    local turret_type = turret_types[item_cache.castra_rng(1, #turret_types)]
    -- Check if this turret type is already present with > 3
    if #data_collector.surface.find_entities_filtered { area = get_search_area_size(data_collector, 30), type = turret_type } > 3 then
        return
    end

    local powered = base_gen.place_turrets(data_collector.position, turret_type)
    base_gen.place_power_poles(get_search_area_size(data_collector, 30), powered)
end

local function fill_turrets(data_collector)
    -- Fill all turrets in the area with ammo
    local area = get_search_area_size(data_collector, 20)
    local turret_types = { "gun-turret", "laser-turret", "rocket-turret", "railgun-turret",
        "tesla-turret", "combat-roboport", "flamethrower-turret", "artillery-turret" }
	if settings.startup["castra-edits-extend-Cannons"].value then
		table.insert(turret_types, "vtk-cannon-turret")
		table.insert(turret_types, "vtk-cannon-turret-heavy")
	end
	if settings.startup["castra-edits-extend-GrenadeLauncher"].value then
		table.insert(turret_types, "PLORD_gl_40mm_turret")
	end			
		
    for _, turret_type in pairs(turret_types) do
        for _, turret in pairs(data_collector.surface.find_entities_filtered { area = area, type = base_gen.get_enemy_variant(turret_type), force = "enemy" }) do
            if turret.valid then
                local ammo = base_gen.get_corresponding_ammo(turret_type)
                if ammo and ammo ~= "N_A" then
                    turret.insert({ name = ammo, count = prototypes.item[ammo].stack_size, quality = base_gen.select_random_quality() })
                end

                if turret_type == "flamethrower-turret" then
                    turret.insert_fluid({ name = "light-oil", amount = 1000 })
                end
            end
        end
    end
end

local function fill_roboports(data_collector)
    item_cache.build_cache_if_needed()
    -- Stock up on construction bots and repair packs if available
    local area = get_search_area_size(data_collector, 30)
    for _, roboport in pairs(data_collector.surface.find_entities_filtered { area = area, type = "roboport", force = "enemy" }) do
        if roboport.valid then
            if storage.castra.enemy.construction_robot then
                local construction_bots = roboport.get_item_count("construction-robot")
                if construction_bots < 25 then
                    roboport.insert({ name = "construction-robot", count = 25 - construction_bots })
                end
            end
            if storage.castra.enemy.repair_pack then
                local repair_packs = roboport.get_item_count("repair-pack")
                if repair_packs < 100 then
                    roboport.insert({ name = "repair-pack", count = 100 - repair_packs })
                end
            end
        end
    end
end

local function add_land_mines(data_collector)
    item_cache.build_cache_if_needed()

    if not storage.castra.enemy.land_mine then
        return
    end

    -- Check if there are already land mines in the area
    if #data_collector.surface.find_entities_filtered { area = get_search_area_size(data_collector, 30), type = "land-mine" } > 5 then
        return
    end

    base_gen.place_land_mines(data_collector.position)
end

local function add_solar(data_collector)
    item_cache.build_cache_if_needed()

    if not storage.castra.enemy.solar_panel then
        return
    end

    -- Check if there are already solar panels in the area
    if #data_collector.surface.find_entities_filtered { area = get_search_area_size(data_collector, 30), type = "solar-panel" } > 5 then
        return
    end

    local area = get_search_area(data_collector)
    base_gen.place_solar(area)
    base_gen.place_power_poles(get_search_area_size(data_collector, 30), find_missing_powered_entities(data_collector))
end

local function add_roboport(data_collector)
    item_cache.build_cache_if_needed()

    if not storage.castra.enemy.roboport then
        return
    end

    -- Check if there are already roboports in the area
    if #data_collector.surface.find_entities_filtered { area = get_search_area_size(data_collector, 30), type = "roboport" } > 5 then
        return
    end

    local area = get_search_area(data_collector)
    base_gen.place_roboport(area, data_collector.position)
    base_gen.place_power_poles(get_search_area_size(data_collector, 30), find_missing_powered_entities(data_collector))
end

local function containsValue(array, value)
    if not value then
        return false
    end

    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

local function upgrade_quality(data_collector)
    item_cache.build_cache_if_needed()
    local random_quality = base_gen.select_random_quality()

    -- Find any enemy entities in 30x30 area
    local area = get_search_area_size(data_collector, 30)
    local entities = data_collector.surface.find_entities_filtered { area = area, force = "enemy" }

    local valid_entities = {"gun-turret", base_gen.get_enemy_variant("laser-turret"), "rocket-turret", base_gen.get_enemy_variant("railgun-turret"),
        base_gen.get_enemy_variant("tesla-turret"), "combat-roboport", base_gen.get_enemy_variant("flamethrower-turret"), "artillery-turret", "roboport", "solar-panel", 
        "accumulator", "land-mine", "data-collector", "stone-wall", "carbon-fiber-wall" }

    for _, entity in pairs(entities) do
        -- Skip if a ghost or invalid
        if not entity.valid or entity.name == "entity-ghost" then
            goto continue
        end

        -- Skip if not a valid entity
        if not containsValue(valid_entities, entity.name) then
            goto continue
        end

        if entity.quality and entity.quality.level < random_quality.level then
            local entity_name = entity.name
            local surface = entity.surface
            local position = entity.position
            local direction = entity.direction
            local orientation = entity.orientation
            surface.create_entity { name = entity_name, position = position, force = "enemy", quality = random_quality, raise_built = true, direction = direction, orientation = orientation }

            -- Delete the old one
            entity.destroy()
        end
        ::continue::
    end
end

return {
    add_walls = add_walls,
    add_turrets = add_turrets,
    fill_turrets = fill_turrets,
    fill_roboports = fill_roboports,
    add_land_mines = add_land_mines,
    add_solar = add_solar,
    add_roboport = add_roboport,
    upgrade_quality = upgrade_quality
}
