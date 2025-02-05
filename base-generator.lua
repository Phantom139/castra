local item_cache = require("castra-cache")

-- Define a point as a table with x and y coordinates
local function createPoint(x, y)
    return { x = x, y = y }
end

-- Function to negate the y-coordinates of a list of points
local function negateYCoordinates(points)
    local transformed = {}
    for _, p in ipairs(points) do
        table.insert(transformed, createPoint(p.x, -p.y))
    end
    return transformed
end

-- Function to restore the original y-coordinates
local function restoreYCoordinates(points)
    local restored = {}
    for _, p in ipairs(points) do
        table.insert(restored, createPoint(p.x, -p.y))
    end
    return restored
end

-- Function to determine the orientation of the triplet (p, q, r)
-- Returns:
-- 0 if p, q, and r are collinear
-- 1 if Clockwise
-- 2 if Counter-clockwise
local function orientation(p, q, r)
    local val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
    if val == 0 then
        return 0
    elseif val > 0 then
        return 1
    else
        return 2
    end
end

-- Function to compute the squared distance between two points
local function distanceSquared(p1, p2)
    return (p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2
end

-- Function to sort points with respect to the starting point
local function sortByPolarAngle(points, start)
    table.sort(points, function(a, b)
        local o = orientation(start, a, b)
        if o == 0 then
            return distanceSquared(start, a) < distanceSquared(start, b)
        else
            return o == 2
        end
    end)
end

-- Function to implement Graham's Scan algorithm
local function grahamScan(points)
    -- Step 1: Find the starting point
    local n = #points
    local ymin = points[1].y
    local min = 1
    for i = 2, n do
        local y = points[i].y
        if (y < ymin) or (y == ymin and points[i].x < points[min].x) then
            ymin = points[i].y
            min = i
        end
    end

    -- Place the starting point at the first position
    points[1], points[min] = points[min], points[1]
    local start = points[1]

    -- Step 2: Sort the remaining points based on polar angle
    sortByPolarAngle(points, start)

    -- Step 3: Initialize the convex hull stack
    local stack = { points[1], points[2], points[3] }

    -- Step 4: Process the remaining points
    for i = 4, n do
        while #stack >= 2 and orientation(stack[#stack - 1], stack[#stack], points[i]) ~= 2 do
            table.remove(stack)
        end
        table.insert(stack, points[i])
    end

    return stack
end

-- Function to subtract two points
local function subtractPoints(p1, p2)
    return { x = p1.x - p2.x, y = p1.y - p2.y }
end

-- Function to add two points
local function addPoints(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

-- Function to multiply a point by a scalar
local function multiplyPoint(p, scalar)
    return { x = p.x * scalar, y = p.y * scalar }
end

-- Function to compute the length of a vector
local function vectorLength(v)
    return math.sqrt(v.x * v.x + v.y * v.y)
end

-- Function to normalize a vector
local function normalizeVector(v)
    local length = vectorLength(v)
    return { x = v.x / length, y = v.y / length }
end

-- Function to compute the outward normal of an edge defined by two points
local function outwardNormal(p1, p2)
    local edge = subtractPoints(p2, p1)
    local normal = { x = -edge.y, y = edge.x }
    return normalizeVector(normal)
end

-- Function to expand a convex polygon by distance N
local function expandConvexHull(polygon, N)
    local expandedPolygon = {}
    local numVertices = #polygon

    for i = 1, numVertices do
        local prevIndex = (i - 2) % numVertices + 1
        local nextIndex = i % numVertices + 1

        local prevVertex = polygon[prevIndex]
        local currVertex = polygon[i]
        local nextVertex = polygon[nextIndex]

        local normal1 = outwardNormal(prevVertex, currVertex)
        local normal2 = outwardNormal(currVertex, nextVertex)

        local averageNormal = normalizeVector(addPoints(normal1, normal2))
        local translation = multiplyPoint(averageNormal, N)
        -- Round the translation to the nearest integer
        translation = { x = math.floor(translation.x + 0.5), y = math.floor(translation.y + 0.5) }

        local expandedVertex = addPoints(currVertex, translation)
        table.insert(expandedPolygon, expandedVertex)
    end

    return expandedPolygon
end

local function plotLine(x0, y0, x1, y1)
    local points = {}
    local dx = x1 - x0
    local dy = y1 - y0
    local nx = math.abs(dx)
    local ny = math.abs(dy)
    local sign_x = dx > 0 and 1 or -1
    local sign_y = dy > 0 and 1 or -1

    local px, py = x0, y0
    table.insert(points, { x = px, y = py })

    local ix, iy = 0, 0
    while ix < nx or iy < ny do
        if (0.5 + ix) / nx < (0.5 + iy) / ny then
            -- Next step is horizontal
            px = px + sign_x
            ix = ix + 1
        else
            -- Next step is vertical
            py = py + sign_y
            iy = iy + 1
        end
        table.insert(points, { x = px, y = py })
    end

    return points
end

local function isPointInPolygon(polygon, point)
    local x, y = point.x, point.y
    local inside = false
    local n = #polygon

    for i = 1, n do
        local j = i % n + 1
        local xi, yi = polygon[i].x, polygon[i].y
        local xj, yj = polygon[j].x, polygon[j].y

        if ((yi > y) ~= (yj > y)) and
            (x < (xj - xi) * (y - yi) / (yj - yi) + xi) then
            inside = not inside
        end
    end

    return inside
end

local function floodFill(hull, x, y)
    -- Stack to hold the points to be processed
    local stack = { { x, y } }

    local setPositions = {}

    while #stack > 0 do
        -- Pop the last point from the stack
        local point = table.remove(stack)
        local px, py = point[1], point[2]

        -- Check if the point is inside the convex hull and not yet filled
        if isPointInPolygon(hull, { x = px, y = py }) and not setPositions[px .. "," .. py] then
            -- Set to concrete
            game.surfaces["castra"].set_tiles({ { name = "concrete", position = { px, py } } })
            setPositions[px .. "," .. py] = true

            -- Add neighboring points to the stack
            table.insert(stack, { px + 1, py }) -- Right
            table.insert(stack, { px - 1, py }) -- Left
            table.insert(stack, { px, py + 1 }) -- Down
            table.insert(stack, { px, py - 1 }) -- Up
        end
    end
end

local function select_random_quality()
    item_cache.build_cache_if_needed()
    local qualities = {}
    local max_quality = storage.castra.enemy.quality_tier

    -- Add any qualities from the table that are lower thanl the max quality
    for _, quality in pairs(prototypes.quality) do
        if quality and not quality.hidden and quality.level <= max_quality.level then
            table.insert(qualities, quality)
        end
    end

    if #qualities == 0 then
        return prototypes.quality["normal"]
    end

    -- Assign a weight to each quality based on the level: (1/2)^level * 1000
    local total_weight = 0
    local weights = {}
    for _, quality in pairs(qualities) do
        local weight = math.pow(0.5, quality.level) * 1000
        total_weight = total_weight + weight
        table.insert(weights, weight)
    end

    -- Select a random quality based on the weights
    local random_weight = math.random() * total_weight
    local sum = 0
    for i, weight in pairs(weights) do
        sum = sum + weight
        if sum >= random_weight then
            return qualities[i]
        end
    end

    return prototypes.quality["normal"]
end

local function build_enemy_wall(chunk_area, pos)
    item_cache.build_cache_if_needed()
    local wall_type = storage.castra.enemy.wall_tier or nil
    if not wall_type then
        return
    end

    -- Find and enemy force entities in a 15x15 range
    local surface = game.surfaces["castra"]
    local enemy_force = game.forces["enemy"]
    local entities = surface.find_entities_filtered { force = enemy_force, area = { { chunk_area.left_top.x - 15, chunk_area.left_top.y - 15 }, { chunk_area.right_bottom.x + 15, chunk_area.right_bottom.y + 15 } } }
    -- Remove walls from entities list
    for i = #entities, 1, -1 do
        if entities[i].type == "wall" then
            table.remove(entities, i)
        end
    end

    -- Create points to use for the convex hull. Each entity of size n x m needs to be represented by the 4 corners
    local points = {}
    for _, entity in pairs(entities) do
        local x = entity.position.x
        local y = entity.position.y
        local width = entity.prototype.selection_box.right_bottom.x - entity.prototype.selection_box.left_top.x
        local height = entity.prototype.selection_box.right_bottom.y - entity.prototype.selection_box.left_top.y
        table.insert(points, createPoint(x - width / 2, y - height / 2))
        table.insert(points, createPoint(x + width / 2, y - height / 2))
        table.insert(points, createPoint(x + width / 2, y + height / 2))
        table.insert(points, createPoint(x - width / 2, y + height / 2))
    end

    -- Create the orthogonalized convex hull

    local transformedPoints = negateYCoordinates(points)
    local convexHull = grahamScan(transformedPoints)
    local restoredHull = restoreYCoordinates(convexHull)
    local expandedHull = expandConvexHull(restoredHull, 2)

    local quality = select_random_quality()

    -- Create the walls along the expanded hull
    local emptyWallSpots = 0
    for i = 1, #expandedHull do
        local p1 = expandedHull[i]
        local p2 = expandedHull[(i % #expandedHull) + 1]
        local wallPoints = plotLine(p1.x, p1.y, p2.x, p2.y)
        for _, point in pairs(wallPoints) do
            -- Randomly set some wall spots to be empty
            if math.random() < 0.1 then
                emptyWallSpots = emptyWallSpots + 3
            end
            if emptyWallSpots > 0 then
                emptyWallSpots = emptyWallSpots - 1
            else
                if surface.can_place_entity { name = wall_type, position = point, force = enemy_force } then
                    surface.create_entity { name = wall_type, position = point, force = enemy_force, quality = quality }
                end
            end
        end
    end

    -- This is laggy, so we'll skip it for now
    -- Fill the area inside the convex hull with concrete
    --local concreteHull = expandConvexHull(restoredHull, 2)
    --floodFill(concreteHull, pos.x, pos.y)
end

local function place_roboport(chunk_area, data_collector_pos)
    if not storage.castra.enemy.roboport then
        return
    end

    local surface = game.surfaces["castra"]
    local enemy_force = game.forces["enemy"]
    local otherRoboports = surface.find_entities_filtered { name = "roboport", force = enemy_force, area = { { chunk_area.left_top.x - 45, chunk_area.left_top.y - 45 }, { chunk_area.right_bottom.x + 45, chunk_area.right_bottom.y + 45 } } }

    -- Create a roboport if there is another roboport nearby or a 50% chance
    if #otherRoboports > 0 or math.random() < 0.8 then
        local pos = surface.find_non_colliding_position("roboport", data_collector_pos, 16, 1, true)
        if pos then
            local roboport = surface.create_entity { name = "roboport", position = pos, force = enemy_force, quality = select_random_quality() }

            -- Add a few construction bots and repair packs to the roboport
            if roboport then
                if storage.castra.enemy.construction_robots then
                    roboport.insert { name = "construction-robot", count = 25, quality = select_random_quality() }
                end
                if storage.castra.enemy.repair_pack then
                    roboport.insert { name = "repair-pack", count = 100, quality = select_random_quality() }
                end
            end

            return roboport
        end
    end

    return nil
end

local function place_solar(chunk_area)
    item_cache.build_cache_if_needed()

    if not storage.castra.enemy.solar_panel then
        return
    end

    local surface = game.surfaces["castra"]
    local enemy_force = game.forces["enemy"]

    -- Place a power pole and up to 5 solar panels around it if it's in the pole's range
    local power_type = storage.castra.enemy.best_power_pole
    if not power_type then
        return
    end

    local pole_pos = surface.find_non_colliding_position(power_type,
        { math.random(chunk_area.left_top.x, chunk_area.right_bottom.x), math.random(chunk_area.left_top.y,
            chunk_area.right_bottom.y) }, 8, 1, true)

    if pole_pos then
        local power_pole = surface.create_entity { name = power_type, position = pole_pos, force = enemy_force, quality = select_random_quality() }

        if not power_pole then
            return
        end

        local pole_range = power_pole.prototype.get_supply_area_distance(power_pole.quality)

        local quality = select_random_quality()

        local created = false
        for i = 1, math.random(2, 5) do
            local solar_panel_pos = surface.find_non_colliding_position("solar-panel",
                { pole_pos.x + math.random(-pole_range - 2, pole_range + 2), pole_pos.y +
                math.random(-pole_range - 2, pole_range + 2) }, 8, 1, true)
            if solar_panel_pos then
                local solar = surface.create_entity { name = "solar-panel", position = solar_panel_pos, force = enemy_force, quality = quality }
                if solar then
                    created = true

                    -- If the solar panel isn't connected to a power network, try to add a power pole
                    if not solar.is_connected_to_electric_network() then
                        local power_pole_pos = surface.find_non_colliding_position(power_type, solar.position, pole_range + 2, 1, true)
                        if power_pole_pos then
                            surface.create_entity { name = power_type, position = power_pole_pos, force = enemy_force, quality = quality }
                        end
                    end
                end
            end
        end

        if not created then
            power_pole.destroy()
        else
            return power_pole
        end
    end

    return nil
end

local function find_closest_entity(filters)
    local surface = game.surfaces["castra"]
    local enemy_force = game.forces["enemy"]
    local entities = surface.find_entities_filtered(filters)
    local closest_entity = nil
    local closest_distance = math.huge

    for _, entity in pairs(entities) do
        -- Ignore entity at this position
        if filters.position and entity.position.x == filters.position.x and entity.position.y == filters.position.y then
            goto continue_entity
        end

        local distance = entity.position.x ^ 2 + entity.position.y ^ 2
        if distance < closest_distance then
            closest_entity = entity
            closest_distance = distance
        end

        ::continue_entity::
    end

    return closest_entity
end

local function place_power_poles(chunk_area, powered_entities)
    item_cache.build_cache_if_needed()
    if #powered_entities == 0 or not storage.castra.enemy.solar_panel then
        return
    end

    local power_type = storage.castra.enemy.best_power_pole
    if not power_type then
        return
    end

    local quality = select_random_quality()

    local pole_supply_area = prototypes.entity[power_type].get_supply_area_distance(quality)

    local surface = game.surfaces["castra"]
    local enemy_force = game.forces["enemy"]

    -- Place power poles to connect the power source to the powered entities
    -- Find a non-colliding position for the power pole, and if it closes the distance to the next entity, place it
    for _, entity in pairs(powered_entities) do
        if not entity.valid or entity.is_connected_to_electric_network() then
            goto continue_pole
        end

        local power_pole_pos = surface.find_non_colliding_position(power_type, entity.position, pole_supply_area + 2, 1, true)
        if not power_pole_pos then
            goto continue_pole
        end
        surface.create_entity { name = power_type, position = power_pole_pos, force = enemy_force, quality = quality }

        -- Check if it's now connected to power
        if entity.is_connected_to_electric_network() then
            goto continue_pole
        end

        local pole_reach = prototypes.entity[power_type].get_max_wire_distance(quality)
        
        -- Find where the solar panels are and add power poles to connect them
        local solar_panel = find_closest_entity { area = { top_left = { entity.position.x - 50, entity.position.y - 50 }, bottom_right = { entity.position.x + 50, entity.position.y + 50 } }, type = "solar-panel" }
        if solar_panel then
            -- Draw a line of poles based on the pole's max distance
            local pole_distance = math.floor(math.sqrt((power_pole_pos.x - solar_panel.position.x) ^ 2 + (power_pole_pos.y - solar_panel.position.y) ^ 2))
            local pole_count = math.floor(pole_distance / pole_reach)
            -- need to round down
            local pole_step = { x = math.floor((solar_panel.position.x - power_pole_pos.x) / pole_count), y = math.floor((solar_panel.position.y - power_pole_pos.y) / pole_count) }
            

            for i = 1, pole_count do
                local pole_pos_test = { x = power_pole_pos.x + pole_step.x * i, y = power_pole_pos.y + pole_step.y * i }
                local pole_pos = surface.find_non_colliding_position(power_type, pole_pos_test, 3, 1, true)
                if pole_pos then
                    surface.create_entity { name = power_type, position = pole_pos, force = enemy_force, quality = quality }
                end
            end
        end

        ::continue_pole::
    end
end

local function get_corresponding_ammo(turret_type)
    item_cache.build_cache_if_needed()
    if turret_type == "gun-turret" then
        return storage.castra.enemy.ammo_tier
    elseif turret_type == "laser-turret" then
        return "N_A"
    elseif turret_type == "flamethrower-turret" then
        return "flamethrower-ammo"
    elseif turret_type == "rocket-turret" then
        return storage.castra.enemy.rocket_tier
    elseif turret_type == "railgun-turret" then
        return "railgun-ammo"
    elseif turret_type == "artillery-turret" then
        return "artillery-shell"
    elseif turret_type == "tesla-turret" then
        return "N_A"
    elseif turret_type == "combat-roboport" then
        return storage.castra.enemy.combat_robot
    end
end

local function hyphen_to_underscore(str)
    return string.gsub(str, "-", "_")
end

local function place_turrets(data_collector_pos, type)
    local turret_types = nil
    if not type then
        -- Select a random turret type from the available turrets
        turret_types = { "gun-turret", "laser-turret", "flamethrower-turret", "rocket-turret", "railgun-turret",
            "tesla-turret", "combat-roboport" }
    else
        turret_types = { type }
    end
    -- Remove any turrets that art researched
    for i = #turret_types, 1, -1 do
        if not storage.castra.enemy[hyphen_to_underscore(turret_types[i])] or not get_corresponding_ammo(turret_types[i]) then
            table.remove(turret_types, i)
        end

        -- Remove power based turrets if solar panels are not researched
        if not storage.castra.enemy.solar_panel and (turret_types[i] == "laser-turret" or turret_types[i] == "railgun-turret" or turret_types[i] == "tesla-turret") then
            table.remove(turret_types, i)
        end
    end

    if #turret_types == 0 then
        return
    end

    local powered_turrets = {}

    -- Select a random turret type
    local turret_type = turret_types[math.random(1, #turret_types)]

    -- Railgun has 8 orientations
    local railgun_orients = { defines.direction.east, defines.direction.northeast, defines.direction.north, defines.direction.northwest,
        defines.direction.west, defines.direction.southwest, defines.direction.south, defines.direction.southeast }

    -- Place a random number of turrets around the data-collector
    for i = 1, math.random(1, 6) do
        local turret_pos = game.surfaces["castra"].find_non_colliding_position(turret_type,
            { data_collector_pos.x + math.random(-8, 8), data_collector_pos.y + math.random(-8, 8) }, 8, 1, true)
        if turret_pos then
            local orientation = turret_type == "railgun-turret" and railgun_orients[math.random(1, #railgun_orients)] or
                nil

            local turret = game.surfaces["castra"].create_entity { name = turret_type, position = turret_pos, force = game.forces["enemy"], direction = orientation, quality = select_random_quality() }
            if turret then
                if turret_type == "railgun-turret" or turret_type == "tesla-turret" or turret_type == "laser-turret" then
                    table.insert(powered_turrets, turret)
                end

                -- Add ammo to the turret
                local ammo = get_corresponding_ammo(turret_type)
                if ammo and ammo ~= "N_A" then
                    turret.insert { name = ammo, count = prototypes.item[ammo].stack_size, quality = select_random_quality() }
                end
            end
        end
    end

    return powered_turrets
end

local function place_land_mines(data_collector_pos)
    item_cache.build_cache_if_needed()
    if not storage.castra.enemy.land_mine then
        return
    end

    local surface = game.surfaces["castra"]
    local enemy_force = game.forces["enemy"]

    -- Place a ~20 land mines around the data collector within a range of 20
    for i = 1, math.random(10, 30) do
        local land_mine_pos = surface.find_non_colliding_position("land-mine",
            { data_collector_pos.x + math.random(-20, 20), data_collector_pos.y + math.random(-20, 20) }, 8, 1, true)
        if land_mine_pos then
            surface.create_entity { name = "land-mine", position = land_mine_pos, force = enemy_force, quality = select_random_quality() }
        end
    end
end

local function create_enemy_base(chunk_area)
    item_cache.build_cache_if_needed()

    -- Check if there are any enemy force roboports in 45x45 range
    local surface = game.surfaces["castra"]
    local enemy_force = game.forces["enemy"]


    -- Find a random valid position in the chunk
    local dataPos = surface.find_non_colliding_position("data-collector",
        { math.random(chunk_area.left_top.x, chunk_area.right_bottom.x), math.random(chunk_area.left_top.y,
            chunk_area.right_bottom.y) }, 16, 1, true)
    if not dataPos then
        return
    end

    -- Place the data collector
    surface.create_entity { name = "data-collector", position = dataPos, force = enemy_force, quality = select_random_quality() }
    local powered_entities = {}

    -- Place turrets
    if math.random() < 0.95 then
        local powered_turrets = place_turrets(dataPos, nil)
        if powered_turrets then
            for _, turret in pairs(powered_turrets) do
                table.insert(powered_entities, turret)
            end
        end
    end

    -- Place power based on if solar panels are available
    if storage.castra.enemy.solar_panel then
        local power_source = place_solar(chunk_area)

        if power_source then
            local roboport = place_roboport(chunk_area, dataPos)
            if roboport then
                table.insert(powered_entities, roboport)
            end
            place_power_poles(chunk_area, powered_entities)
        end
    end

    if math.random() < 0.5 then
        build_enemy_wall(chunk_area, dataPos)
    end

    if math.random() < 0.4 then
        place_land_mines(dataPos)
    end
end

return {
    create_enemy_base = create_enemy_base,
    build_enemy_wall = build_enemy_wall,
    place_turrets = place_turrets,
    place_land_mines = place_land_mines,
    place_solar = place_solar,
    place_roboport = place_roboport,
    place_power_poles = place_power_poles,
    get_corresponding_ammo = get_corresponding_ammo,
    select_random_quality = select_random_quality
}
