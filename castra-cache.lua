local function castra_exists()
    return game.surfaces["castra"] ~= nil
end

local has_item_cache = nil

local function update_item_cache()
    has_item_cache = {}
    for _, recipe in pairs(game.forces["enemy"].recipes) do
        if recipe.category == "recycling" then
            goto skip_item_check
        end

        if recipe.enabled and recipe.products then
            for _, product in pairs(recipe.products) do
                if product.name then
                    has_item_cache[product.name] = true
                end
            end
        end

        ::skip_item_check::
    end
end

local function has_castra_researched_item(item_name)
    if not has_item_cache then
        update_item_cache()
    end

    return has_item_cache[item_name]
end

local function update_castra_enemy_data()
    storage.castra = storage.castra or {}
    local enemy_storage = storage.castra.enemy or {}

    update_item_cache()

    -- Update the highest tier of speed module unlocked by checking recipes
    local speed_module_tier = 0
    for i = 1, 3 do
        if has_castra_researched_item("speed-module-" .. i) then
            speed_module_tier = i
        end
    end
    enemy_storage.speed_module_tier = speed_module_tier

    -- Update the highest tier of productivity module unlocked by checking recipes
    local productivity_module_tier = 0
    for i = 1, 3 do
        if has_castra_researched_item("productivity-module-" .. i) then
            productivity_module_tier = i
        end
    end
    enemy_storage.productivity_module_tier = productivity_module_tier

    -- Check for the best power pole: none > small > medium > substation
    local best_power_pole = nil
    if has_castra_researched_item("small-electric-pole") then
        best_power_pole = "small-electric-pole"
    end
    if has_castra_researched_item("medium-electric-pole") then
        best_power_pole = "medium-electric-pole"
    end
    if has_castra_researched_item("substation") then
        best_power_pole = "substation"
    end
    enemy_storage.best_power_pole = best_power_pole

    -- Check highest tier of wall
    local wall_tier = nil
    if has_castra_researched_item("stone-wall") then
        wall_tier = "stone-wall"
    end
    enemy_storage.wall_tier = wall_tier

    -- Check highest tier of ammo
    local ammo_tier = nil
    if has_castra_researched_item("firearm-magazine") then
        ammo_tier = "firearm-magazine"
    end
    if has_castra_researched_item("piercing-rounds-magazine") then
        ammo_tier = "piercing-rounds-magazine"
    end
    if has_castra_researched_item("uranium-rounds-magazine") then
        ammo_tier = "uranium-rounds-magazine"
    end
    enemy_storage.ammo_tier = ammo_tier

    -- Check highest tier of rocket
    local rocket_tier = nil
    if has_castra_researched_item("rocket") then
        rocket_tier = "rocket"
    end
    if has_castra_researched_item("explosive-rocket") then
        rocket_tier = "explosive-rocket"
    end
    if has_castra_researched_item("atomic-bomb") then
        rocket_tier = "atomic-bomb"
    end
    enemy_storage.rocket_tier = rocket_tier

    -- Check best combat robot
    local combat_robot = nil
    if has_castra_researched_item("defender-capsule") then
        combat_robot = "defender-capsule"
    end
    if has_castra_researched_item("distractor-capsule") then
        combat_robot = "distractor-capsule"
    end
    if has_castra_researched_item("destroyer-capsule") then
        combat_robot = "destroyer-capsule"
    end
    enemy_storage.combat_robot = combat_robot

    -- Check highest quality tier unlocked
    local quality_tier = prototypes.quality["normal"]
    for _, quality in pairs(prototypes.quality) do
        if quality and not quality.hidden and game.forces["enemy"].is_quality_unlocked(quality) then
            if quality.level > quality_tier.level then
                quality_tier = quality
            end
        end
    end
    enemy_storage.quality_tier = quality_tier

    -- Check turrets and other misc buildings
    enemy_storage.gun_turret = has_castra_researched_item("gun-turret")
    enemy_storage.laser_turret = has_castra_researched_item("laser-turret")
    enemy_storage.flamethrower_turret = has_castra_researched_item("flamethrower-turret")
    enemy_storage.rocket_turret = has_castra_researched_item("rocket-turret")
    enemy_storage.railgun_turret = has_castra_researched_item("railgun-turret")
    enemy_storage.railgun_ammo = has_castra_researched_item("railgun_ammo")
    enemy_storage.solar_panel = has_castra_researched_item("solar-panel")
    enemy_storage.repair_pack = has_castra_researched_item("repair-pack")
    enemy_storage.big_electric_pole = has_castra_researched_item("big-electric-pole")
    enemy_storage.roboport = has_castra_researched_item("roboport")
    enemy_storage.construction_robot = has_castra_researched_item("construction-robot")
    enemy_storage.tank = has_castra_researched_item("tank")
    --enemy_storage.artillery_turret = has_castra_researched_item("artillery-turret")
    --enemy_storage.artillery_shell = has_castra_researched_item("artillery-shell")
    enemy_storage.spidertron = has_castra_researched_item("spidertron")
    enemy_storage.land_mine = has_castra_researched_item("land-mine")
    enemy_storage.tesla_turret = has_castra_researched_item("tesla-turret")
    enemy_storage.combat_roboport = has_castra_researched_item("combat-roboport")

    storage.castra.enemy = enemy_storage
end

local function build_cache_if_needed()
    if not storage.castra or not storage.castra.enemy or (not storage.castra.enemy.gun_turret and has_castra_researched_item("gun-turret")) then
        update_castra_enemy_data()
    end
end

return {
    update_castra_enemy_data = update_castra_enemy_data,
    has_castra_researched_item = has_castra_researched_item,
    build_cache_if_needed = build_cache_if_needed,
    castra_exists = castra_exists
}
