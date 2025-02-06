function containsValue(array, value)
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

function create_category_if_not_exists(name)
    if not data.raw["recipe-category"][name] then
        data:extend({
            {
                type = "recipe-category",
                name = name
            }
        })
    end
end

function change_to_category(item)
    for _, recipe in pairs(data.raw["recipe"]) do
        if recipe.results then
            for _, result in pairs(recipe.results) do
                if result.name == item.name then
                    if not recipe.category or recipe.category == "crafting" then
                        recipe.category = "castra-crafting"
                        break
                    else
                        create_category_if_not_exists("castra-" .. recipe.category)
                        recipe.category = "castra-" .. recipe.category
                        break
                    end
                end
            end
        end
    end    
end

for _, item in pairs(data.raw["capsule"]) do
    -- Only include capsule actions with type "throw"
    if item.capsule_action and item.capsule_action.type == "throw" then
        change_to_category(item)
    end
end

for _, item in pairs(data.raw["ammo"]) do
    change_to_category(item)
end

for _, item in pairs(data.raw["gun"]) do
    change_to_category(item)
end

for _, item in pairs(data.raw["armor"]) do
    change_to_category(item)
end

for _, item in pairs(data.raw["item"]) do
    -- Check item's place_result if it's a turret or a wall type
    if item.place_result then
        local entity = data.raw["item"][item.place_result]
        if entity and (entity.type == "wall" or entity.type == "turret" or entity.type == "gate") then
            change_to_category(item)
            goto continueItem
        end
    end

    -- Add any equipment to forge
    if item.place_as_equipment_result then
        change_to_category(item)
    end

    ::continueItem::
end

change_to_category(data.raw["tool"]["military-science-pack"])

-- Add the miliaary crafting category to anything that had the crafting category
table.insert(data.raw.character.character.crafting_categories, "castra-crafting")
table.insert(data.raw["god-controller"].default.crafting_categories, "castra-crafting")

-- Loop through assembling-machine entities and add the military crafting categories
for _, entity in pairs(data.raw["assembling-machine"]) do
    if entity.crafting_categories then
        local original = table.deepcopy(entity.crafting_categories)
        for _, category in pairs(original) do
            -- If "castra-<name>" exists, add it to the categories
            if data.raw["recipe-category"]["castra-" .. category] then
                table.insert(entity.crafting_categories, "castra-" .. category)
            end
        end
    end
end

-- Add any missing "castra-<name>" categories to the forge's crafting categories
local forge_entity = data.raw["assembling-machine"]["forge"]
if forge_entity.crafting_categories then
    for _, category in pairs(data.raw["recipe-category"]) do
        if string.find(category.name, "castra-") and not containsValue(forge_entity.crafting_categories, category.name) then
            table.insert(forge_entity.crafting_categories, category.name)
        end
    end
end

table.insert(data.raw.lab["lab"].inputs, "battlefield-science-pack")
table.insert(data.raw.lab["biolab"].inputs, "battlefield-science-pack")

-- Add lithium battery to railgun and railgun turret
table.insert(data.raw["recipe"]["railgun"].ingredients, { type="item", name="lithium-battery", amount=5 })
table.insert(data.raw["recipe"]["railgun-turret"].ingredients, { type="item", name="lithium-battery", amount=20 })

-- Add lithium battery to the promethium-science-pack recipe
table.insert(data.raw["recipe"]["promethium-science-pack"].ingredients, { type="item", name="lithium-battery", amount=1 })

-- Replace steel with nickel in the flamethrower recipes
for _, recipe in pairs(data.raw["recipe"]) do
    if string.find(recipe.name, "flamethrower") and recipe.ingredients then
        for _, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == "steel-plate" then
                ingredient.name = "nickel-plate"
            end
        end
    end
end

-- Replace battery-mk3-equipment supercapacitor with lithium battery
for _, recipe in pairs(data.raw["recipe"]) do
    if recipe.name == "battery-mk3-equipment" then
        for _, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == "supercapacitor" then
                ingredient.name = "lithium-battery"
            end
        end
    end
end

if mods["planet-muluna"] then
    -- Nerf electric-engine-unit-from-carbon time to x3 since it overshadows the normal lubricant recipe castra uses
    local recipe = data.raw["recipe"]["electric-engine-unit-from-carbon"]
    if recipe then
        recipe.energy_required = recipe.energy_required * 3
    end
end

if mods["modules-t4"] then
    -- Replace tungsten-carbide with millerite in the tier 4 speed module recipe if it exists
    local recipe = data.raw["recipe"]["speed-module-4"]
    if recipe then
        for _, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == "tungsten-carbide" then
                ingredient.name = "millerite"
            end
        end
    end
end