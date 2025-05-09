if data.raw["technology"]["railgun"] then
    if data.raw["technology"]["railgun"].unit and data.raw["technology"]["railgun"].unit.ingredients then
        table.insert(data.raw["technology"]["railgun"].unit.ingredients, { "battlefield-science-pack", 1 })
    end
    table.insert(data.raw["technology"]["railgun"].prerequisites, "lithium-battery")
end

if data.raw["technology"]["railgun-damage-1"] and data.raw["technology"]["railgun-damage-1"].unit and data.raw["technology"]["railgun-damage-1"].unit.ingredients then
    table.insert(data.raw["technology"]["railgun-damage-1"].unit.ingredients, { "battlefield-science-pack", 1 })
    -- Remove agricultural science pack from railgun-damage-1
    for i, ingredient in ipairs(data.raw["technology"]["railgun-damage-1"].unit.ingredients) do
        if ingredient[1] == "agricultural-science-pack" then
            table.remove(data.raw["technology"]["railgun-damage-1"].unit.ingredients, i)
            break
        end
    end
end

if data.raw["technology"]["promethium-science-pack"] then
    if data.raw["technology"]["promethium-science-pack"].unit and data.raw["technology"]["promethium-science-pack"].unit.ingredients then
        table.insert(data.raw["technology"]["promethium-science-pack"].unit.ingredients,
            { "battlefield-science-pack", 1 })
    end
    table.insert(data.raw["technology"]["promethium-science-pack"].prerequisites, "lithium-battery")
end

if data.raw["technology"]["research-productivity"] and data.raw["technology"]["research-productivity"].unit and data.raw["technology"]["research-productivity"].unit and data.raw["technology"]["research-productivity"].unit.ingredients then
    table.insert(data.raw["technology"]["research-productivity"].unit.ingredients, { "battlefield-science-pack", 1 })
end

-- Move atomic bomb and flamethrowers to battlefield-science-pack
if data.raw["technology"]["atomic-bomb"] then
    if data.raw["technology"]["atomic-bomb"].unit and data.raw["technology"]["atomic-bomb"].unit.ingredients then
        table.insert(data.raw["technology"]["atomic-bomb"].unit.ingredients, { "battlefield-science-pack", 1 })
    end
    table.insert(data.raw["technology"]["atomic-bomb"].prerequisites, "battlefield-science-pack")
end

-- Add battlefield-science-pack to all refined flammables techs and remove agricultural from any of them
if data.raw["technology"]["refined-flammables-1"] then
    table.insert(data.raw["technology"]["refined-flammables-1"].prerequisites, "battlefield-science-pack")
end
for _, tech in pairs(data.raw["technology"]) do
    if string.find(tech.name, "refined%-flammables") then
        -- if it's missing chemical or space science pack, add them
        if tech.unit and tech.unit.ingredients then
            local has_chemical = false
            local has_space = false
            for _, ingredient in ipairs(tech.unit.ingredients) do
                if ingredient[1] == "chemical-science-pack" then
                    has_chemical = true
                elseif ingredient[1] == "space-science-pack" then
                    has_space = true
                end
            end
            if not has_chemical then
                table.insert(tech.unit.ingredients, { "chemical-science-pack", 1 })
            end
            if not has_space then
                table.insert(tech.unit.ingredients, { "space-science-pack", 1 })
            end

            table.insert(tech.unit.ingredients, { "battlefield-science-pack", 1 })
            for i, ingredient in ipairs(tech.unit.ingredients) do
                if ingredient[1] == "agricultural-science-pack" then
                    table.remove(tech.unit.ingredients, i)
                    break
                end
            end
        end
    end
end

-- Move follower-robot-count to battlefield-science-pack
if data.raw["technology"]["follower-robot-count-1"] then
    table.insert(data.raw["technology"]["follower-robot-count-1"].prerequisites, "battlefield-science-pack")
end
for _, tech in pairs(data.raw["technology"]) do
    if string.find(tech.name, "follower%-robot%-count") then
        if tech.unit and tech.unit.ingredients then
            -- if it's missing chemical or space science pack, add them
            local has_chemical = false
            local has_space = false
            for _, ingredient in ipairs(tech.unit.ingredients) do
                if ingredient[1] == "chemical-science-pack" then
                    has_chemical = true
                elseif ingredient[1] == "space-science-pack" then
                    has_space = true
                end
            end
            if not has_chemical then
                table.insert(tech.unit.ingredients, { "chemical-science-pack", 1 })
            end
            if not has_space then
                table.insert(tech.unit.ingredients, { "space-science-pack", 1 })
            end

            table.insert(tech.unit.ingredients, { "battlefield-science-pack", 1 })
            for i, ingredient in ipairs(tech.unit.ingredients) do
                if ingredient[1] == "military-science-pack" then
                    table.remove(tech.unit.ingredients, i)
                    break
                end
            end
        end

        if tech.unit.count_formula then
            tech.unit.count_formula = tech.unit.count_formula .. "*2"
        else
            tech.unit.count = tech.unit.count * 2
        end
    end
end

-- Move cargo-landing-pad-capacity to battlefield-science-pack
-- Remove agricultural, electromagnetic, metallurgic
if data.raw["technology"]["cargo-landing-pad-capacity"] then
    if data.raw["technology"]["cargo-landing-pad-capacity"].unit and data.raw["technology"]["cargo-landing-pad-capacity"].unit.ingredients then
        table.insert(data.raw["technology"]["cargo-landing-pad-capacity"].unit.ingredients,
            { "battlefield-science-pack", 1 })
        local removedCargoIngre = true
        while removedCargoIngre do
            removedCargoIngre = false
            for i, ingredient in ipairs(data.raw["technology"]["cargo-landing-pad-capacity"].unit.ingredients) do
                if ingredient[1] == "agricultural-science-pack" or ingredient[1] == "electromagnetic-science-pack" or ingredient[1] == "metallurgic-science-pack" then
                    table.remove(data.raw["technology"]["cargo-landing-pad-capacity"].unit.ingredients, i)
                    removedCargoIngre = true
                    break
                end
            end
        end

        local removedCargoPrereq = true
        while removedCargoPrereq do
            removedCargoPrereq = false
            for i, prereq in ipairs(data.raw["technology"]["cargo-landing-pad-capacity"].prerequisites) do
                if prereq == "agricultural-science-pack" or prereq == "electromagnetic-science-pack" or prereq == "metallurgic-science-pack" then
                    table.remove(data.raw["technology"]["cargo-landing-pad-capacity"].prerequisites, i)
                    removedCargoPrereq = true
                    break
                end
            end
        end
        data.raw["technology"]["cargo-landing-pad-capacity"].unit.count_formula = "10000*2.5^(L-1)"
    end
    table.insert(data.raw["technology"]["cargo-landing-pad-capacity"].prerequisites, "battlefield-science-pack")

    -- Add maraxsis support for cargo-landing-pad-capacity
    -- Landing Pad Rsearch overrides the research, just need to add back prereq and science pack
    if mods["maraxsis"] and mods["landing-pad-research"] then
        table.insert(data.raw["technology"]["cargo-landing-pad-capacity"].prerequisites, "maraxsis-project-seadragon")
        if data.raw["technology"]["cargo-landing-pad-capacity"].unit and data.raw["technology"]["cargo-landing-pad-capacity"].unit.ingredients then
            table.insert(data.raw["technology"]["cargo-landing-pad-capacity"].unit.ingredients,
                { "hydraulic-science-pack", 1 })
        end
    end
end

-- Modify battery-mk3-equipment to require lithium battery
if data.raw["technology"]["battery-mk3-equipment"] then
    if data.raw["technology"]["battery-mk3-equipment"].unit and data.raw["technology"]["battery-mk3-equipment"].unit.ingredients then
        table.insert(data.raw["technology"]["battery-mk3-equipment"].unit.ingredients, { "battlefield-science-pack", 1 })
        table.insert(data.raw["technology"]["battery-mk3-equipment"].unit.ingredients, { "cryogenic-science-pack", 1 })
    end
    table.insert(data.raw["technology"]["battery-mk3-equipment"].prerequisites, "lithium-battery")
end

local function add_productivity_bonus(search_name, add_recipe, amount)
    if not add_recipe then return end

    -- Find any tech which has "change-recipe-productivity" for the search_name
    for _, tech in pairs(data.raw["technology"]) do
        if tech.effects then
            for _, effect in pairs(tech.effects) do
                if effect.type == "change-recipe-productivity" and effect.recipe == search_name then
                    table.insert(tech.effects, { type = "change-recipe-productivity", recipe = add_recipe, change = amount })
                end
            end
        end
    end
end

add_productivity_bonus("plastic-bar", "plastic-hydrogen-sulfide", 0.1)
add_productivity_bonus("rocket-fuel", "rocket-fuel-sulfur", 0.1)

if mods["planet-muluna"] then
    -- Add electric-engine-unit-from-carbon to producitivty tech
    local recipe = data.raw["recipe"]["electric-engine-unit-from-carbon"]
    if recipe then
        add_productivity_bonus("electric-engine-unit", "electric-engine-unit-from-carbon", 0.1)
    end
end

add_productivity_bonus("holmium-plate", "holmium-catalyzing", 0.1)
add_productivity_bonus("processing-unit", "processing-unit-battlefield-data", 0.1)

-- If Cerys is installed and the user has enabled the option to claim Engine producitivty, remove the Cerys tech.
if mods["Cerys-Moon-of-Fulgora"] and settings.startup["castra-edits-claim-engine-productivity"].value then
	local cerys_techs = {
		"cerys-engine-unit-productivity-1",
		"cerys-engine-unit-productivity-2"
	}

	for _, name in pairs(cerys_techs) do
		local tech = data.raw["technology"][name]
		if tech then
			tech.enabled = false             
			tech.hidden = true               
			tech.ignore_tech_cost_multiplier = true
			tech.effects = {}               
			tech.prerequisites = nil          
		end
	end
end