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
            -- Ignore hidden or recycling recipes
            if recipe.hidden or (recipe.category and string.find(recipe.category, "recycling")) then
                goto continueRecipe
            end
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
            ::continueRecipe::
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

local function get_prototype(base_type, name)
  for type_name in pairs(defines.prototypes[base_type]) do
    local prototypes = data.raw[type_name]
    if prototypes and prototypes[name] then
      return prototypes[name]
    end
  end
end

for _, item in pairs(data.raw["item"]) do
    -- Check item's place_result if it's a turret or a wall type
    if item.place_result then
        local entity = get_prototype("entity", item.place_result)
        if entity and entity.type and (entity.type == "wall" or string.find(entity.type, "turret") or entity.type == "gate") then
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

-- Update the character's crafting categories
if data.raw.character.character.crafting_categories then
    local original = table.deepcopy(data.raw.character.character.crafting_categories)
    for _, category in pairs(original) do
        -- If "castra-<name>" exists, add it to the categories
        if data.raw["recipe-category"]["castra-" .. category] then
            table.insert(data.raw.character.character.crafting_categories, "castra-" .. category)
        end
    end
end
if data.raw["god-controller"].default.crafting_categories then
    local original = table.deepcopy(data.raw["god-controller"].default.crafting_categories)
    for _, category in pairs(original) do
        -- If "castra-<name>" exists, add it to the categories
        if data.raw["recipe-category"]["castra-" .. category] then
            table.insert(data.raw["god-controller"].default.crafting_categories, "castra-" .. category)
        end
    end
end

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

-- Phantom139: Removed this as no other mod alters the promethium packs
-- Add lithium battery to the promethium-science-pack recipe
--table.insert(data.raw["recipe"]["promethium-science-pack"].ingredients, { type="item", name="lithium-battery", amount=1 })

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

local function get_surface_condition(recipe, condition_type)
    if recipe.surface_conditions then
        for _, condition in pairs(recipe.surface_conditions) do
            if condition.property == condition_type then
                return condition
            end
        end
    end
    -- If the condition doesn't exist, add it and return it
    local new_condition = { property = condition_type }
    table.insert(recipe.surface_conditions, new_condition)
    return new_condition
end

-- Limit rocket-fuel-sulfur recipe to >= 255 K if cerys is installed
if mods["Cerys-Moon-of-Fulgora"] then
    local recipe = data.raw["recipe"]["rocket-fuel-sulfur"]
    if recipe then
        if not recipe.surface_conditions then
            recipe.surface_conditions = {}
        end
        local temperature_condition = get_surface_condition(recipe, "temperature")
        if temperature_condition.min == nil or temperature_condition.min < 255 then
            temperature_condition.min = 255
        end
    end
end