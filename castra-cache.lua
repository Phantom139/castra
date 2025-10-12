local function castra_exists()
    return game.surfaces["castra"] ~= nil
end

local has_item_cache = nil

local function update_item_cache()
    has_item_cache = {}
    for _, recipe in pairs(game.forces["enemy"].recipes) do
        if recipe.category and string.find(recipe.category, "recycling") or recipe.hidden then
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

local function does_module_exist(module_type, tier)
    if tier == 1 then
        -- Special case for tier 1 modules, which are not named with a number, 
        -- but just in case, also check in the numbered version exists
        return prototypes.item[module_type] ~= nil or prototypes.item[module_type .. "-1"] ~= nil
    end

    return prototypes.item[module_type .. "-" .. tier] ~= nil
end

local function get_highest_module_tier(module_type)
    -- Increment a number until the module does not exist as an item
    local i = 1
    while does_module_exist(module_type, i) do
        i = i + 1
    end
    return i - 1
end

-- Dictionary of lists of ammo types, sorted by damage value
local sorted_ammo_types = {
    bullet = {"firearm-magazine", "piercing-rounds-magazine", "uranium-rounds-magazine", "plutonium-rounds-magazine"},
    rocket = {"rocket", "explosive-rocket", "atomic-bomb", "hydrogen-bomb"},
    railgun = {"railgun-ammo"},
    artillery_shell = {"artillery-shell", "cerys-neutron-bomb", "maraxsis-fat-man" },
}
if settings.startup["castra-edits-extend-GrenadeLauncher"].value then
	grenades = {"PLORD_40mm_gl_flare", "PLORD_40mm_gl_lighted", "PLORD_40mm_gl_pellets_piercing", "PLORD_40mm_gl_uranium_fist", "PLORD_40mm_gl_promethium" ,"PLORD_40mm_gl_he", 
				"PLORD_40mm_gl_cluster", "PLORD_40mm_gl_plasma_hydroxygen", "PLORD_40mm_gl_uranium_frag", "PLORD_40mm_gl_plasma_phosphorus", "PLORD_40mm_gl_plasma_hydrargyrum",
				"PLORD_40mm_gl_inferno", "PLORD_40mm_gl_incendiary", "PLORD_40mm_gl_poison", "PLORD_40mm_gl_venom", "PLORD_40mm_gl_acidic", "PLORD_40mm_gl_thermobaric", 
				"PLORD_40mm_gl_shock", "PLORD_40mm_gl_stun", "PLORD_40mm_gl_stasis", "PLORD_40mm_gl_discharge"}
	sorted_ammo_types["grenades"] = grenades
end
if settings.startup["castra-edits-extend-Cannons"].value then
	-- To-Do Note: Right now the way research is unlocked, the enemy will only ever use explosive rounds, perhaps throw in a random statement here to go between them?
	cannon_turret_rounds = {}
	if settings.startup["vtk-cannon-turret-ammo-use"].value == 1 or 3 then
		cannon_turret_rounds = {"castra-enemy-cannon-shell-magazine", "castra-enemy-explosive-cannon-shell-magazine", "castra-enemy-uranium-cannon-shell-magazine", "castra-enemy-explosive-uranium-cannon-shell-magazine"}
	else
		cannon_turret_rounds = {"castra-enemy-cannon-shell", "castra-enemy-explosive-cannon-shell", "castra-enemy-uranium-cannon-shell", "castra-enemy-explosive-uranium-cannon-shell"}
	end
	sorted_ammo_types["cannon_turret_rounds"] = cannon_turret_rounds
end

local function update_castra_enemy_data()
    storage.castra = storage.castra or {}
    local enemy_storage = storage.castra.enemy or {}

    update_item_cache()

    -- Update the highest tier of speed module unlocked by checking recipes
    local speed_module_tier = 0
    for i = 1, get_highest_module_tier("speed-module") do
        if i == 1 and has_castra_researched_item("speed-module") then
            speed_module_tier = i
        end
        if has_castra_researched_item("speed-module-" .. i) then
            speed_module_tier = i
        end
    end
    enemy_storage.speed_module_tier = speed_module_tier

    -- Update the highest tier of productivity module unlocked by checking recipes
    local productivity_module_tier = 0
    for i = 1, get_highest_module_tier("productivity-module") do
        if i == 1 and has_castra_researched_item("productivity-module") then
            productivity_module_tier = i
        end
        if has_castra_researched_item("productivity-module-" .. i) then
            productivity_module_tier = i
        end
    end
    enemy_storage.productivity_module_tier = productivity_module_tier

    -- Update highest tier of quality module
    local quality_module_tier = 0
    for i = 1, get_highest_module_tier("quality-module") do
        if i == 1 and has_castra_researched_item("quality-module") then
            quality_module_tier = i
        end
        if has_castra_researched_item("quality-module-" .. i) then
            quality_module_tier = i
        end
    end
    enemy_storage.quality_module_tier = quality_module_tier

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
    if has_castra_researched_item("carbon-fiber-wall") then
        wall_tier = "carbon-fiber-wall"
    end
    enemy_storage.wall_tier = wall_tier

    -- Check highest tier of ammo
    local ammo_tier = nil
    for _, ammo in pairs(sorted_ammo_types.bullet) do
        if has_castra_researched_item(ammo) then
            ammo_tier = ammo
        end
    end
    enemy_storage.ammo_tier = ammo_tier

    -- Check highest tier of rocket
    local rocket_tier = nil
    for _, rocket in pairs(sorted_ammo_types.rocket) do
		if rocket == "atomic-bomb" or rocket == "hydrogen-bomb" then
			if settings.startup["castra-enemy-allowed-nukes"].value then
				if has_castra_researched_item(rocket) then
					rocket_tier = rocket
				end		
			end
		else
			if has_castra_researched_item(rocket) then
				rocket_tier = rocket
			end
		end
    end
    enemy_storage.rocket_tier = rocket_tier

    -- Check highest tier of railgun ammo
    local railgun_tier = nil
    for _, railgun in pairs(sorted_ammo_types.railgun) do
        if has_castra_researched_item(railgun) then
            railgun_tier = railgun
        end
    end
    enemy_storage.railgun_tier = railgun_tier

    -- Check highest tier of artillery-shell
    local artillery_tier = nil
	if settings.startup["castra-enemy-allowed-artillery"].value then
		for _, artillery in pairs(sorted_ammo_types.artillery_shell) do
			if artillery == "cerys-neutron-bomb" or artillery == "maraxsis-fat-man" then
				if settings.startup["castra-enemy-allowed-nukes"].value then
					if has_castra_researched_item(artillery) then
						artillery_tier = artillery
					end				
				end
			else		
				if has_castra_researched_item(artillery) then
					artillery_tier = artillery
				end
			end
		end
	end
    enemy_storage.artillery_tier = artillery_tier

    -- Check highest tier of combat robot
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
    enemy_storage.solar_panel = has_castra_researched_item("solar-panel")
    enemy_storage.repair_pack = has_castra_researched_item("repair-pack")
    enemy_storage.big_electric_pole = has_castra_researched_item("big-electric-pole")
    enemy_storage.roboport = has_castra_researched_item("roboport")
    enemy_storage.construction_robot = has_castra_researched_item("construction-robot")
	enemy_storage.car = has_castra_researched_item("car")
    enemy_storage.tank = has_castra_researched_item("tank")
    enemy_storage.artillery_turret = has_castra_researched_item("artillery-turret")
    enemy_storage.spidertron = has_castra_researched_item("spidertron")
    enemy_storage.land_mine = has_castra_researched_item("land-mine")
    enemy_storage.tesla_turret = has_castra_researched_item("tesla-turret")
    enemy_storage.combat_roboport = has_castra_researched_item("combat-roboport")
	-- Mod extensions
	if settings.startup["castra-edits-extend-RC"].value then
		enemy_storage.explosive_rc = has_castra_researched_item("explosive-rc-car")
	end
	if settings.startup["castra-edits-extend-Mammoth"].value then
		enemy_storage.mammoth = has_castra_researched_item("mammoth-mk3")
	end	
	if settings.startup["castra-edits-extend-GrenadeLauncher"].value then
		enemy_storage.PLORD_gl_40mm_turret = has_castra_researched_item("PLORD_gl_40mm_turret")
		enemy_storage.grenade_tank = has_castra_researched_item("PLORD_gl_tank")	
		enemy_storage.available_grenades = {}
		-- Individual grenades are not "sorted", but instead are just added to a dictionary of availability, the enemy will use all of the different types as they see fit.
		for _, grenade in pairs(sorted_ammo_types.grenades) do
			enemy_storage.available_grenades[grenade] = false
			if has_castra_researched_item(grenade) then
				enemy_storage.available_grenades[grenade] = true
			end
		end
	end
	if settings.startup["castra-edits-extend-Cannons"].value then
		enemy_storage.vtk_cannon_turret = has_castra_researched_item("vtk-cannon-turret")
		enemy_storage.vtk_cannon_turret_heavy = has_castra_researched_item("vtk-cannon-turret-heavy")
	
		local cannon_shell_tier = nil
		for _, ammo in pairs(sorted_ammo_types.cannon_turret_rounds) do
			if has_castra_researched_item(ammo) then
				cannon_shell_tier = ammo
			end
		end
		enemy_storage.cannon_shell_tier = cannon_shell_tier	
	end

    storage.castra.enemy = enemy_storage
end

local function build_cache_if_needed()
    if not storage.castra or not storage.castra.enemy or (not storage.castra.enemy.gun_turret and has_castra_researched_item("gun-turret")) then
        update_castra_enemy_data()
    end
end

local function build_pollution_cache()    
    if not castra_exists() then
        return
    end

    storage.castra = storage.castra or {}
    storage.castra.dataCollectors = storage.castra.dataCollectors or {}
    storage.castra.dataCollectorsPollution = storage.castra.dataCollectorsPollution or {}
    if #storage.castra.dataCollectors == 0 then
        return
    end
    storage.castra.pollution_iterator = storage.castra.pollution_iterator or 0

    storage.castra.pollution_iterator = storage.castra.pollution_iterator + 1
    if storage.castra.pollution_iterator > #storage.castra.dataCollectors then
        storage.castra.pollution_iterator = 1
    end
    local dataCollector = storage.castra.dataCollectors[storage.castra.pollution_iterator]
    if dataCollector.valid then
        local pollution = 0
        -- Get 3x3 chunk pollution sum
        for x = -1, 1 do
            for y = -1, 1 do
                pollution = pollution + dataCollector.surface.get_pollution { x = dataCollector.position.x + x * 32, y = dataCollector.position.y + y * 32 }
            end
        end
        -- Update pollution in storage
        storage.castra.dataCollectorsPollution[dataCollector.unit_number] = pollution
    end
end

local function hash_coords(x, y, sSeed, salt)
    local n = (x * 181) + (y * 359) + ((sSeed or 0) * 6) + (salt or 0)

    n = n % 2147483647 
    if n == 0 then n = 1 end

    return n
end

local function castra_rng(minV, maxV, seed)
    local raw_seed = math.floor((game.tick + (seed or 0) * 69) % 2147483647)
    if raw_seed == 0 then 
		raw_seed = 420
	end 
	local rng = game.create_random_generator(raw_seed)
	return rng(minV or 0, maxV or 1)
end

return {
    update_castra_enemy_data = update_castra_enemy_data,
    has_castra_researched_item = has_castra_researched_item,
    build_cache_if_needed = build_cache_if_needed,
    castra_exists = castra_exists,
    build_pollution_cache = build_pollution_cache,
	hash_coords = hash_coords,
	castra_rng = castra_rng,
}
