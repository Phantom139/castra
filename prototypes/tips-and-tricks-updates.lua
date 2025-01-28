local function create_data_pollution_page(page_num)
  return {
    type = "tips-and-tricks-item",
    name = "data-pollution-items-" .. page_num,
    category = "castra",
    order = "b[" .. page_num .. "]",
    indent = 1,
    trigger =
    {
      type = "research",
      technology = "planet-discovery-castra"
    },
    skip_trigger =
    {
      type = "or",
      triggers =
      {
        {
          type = "change-surface",
          surface = "castra"
        },
        {
          type = "sequence",
          triggers =
          {
            {
              type = "research",
              technology = "planet-discovery-castra"
            },
            {
              type = "time-elapsed",
              ticks = 15 * minute
            },
            {
              type = "time-since-last-tip-activation",
              ticks = 15 * minute
            }
          }
        }
      }
    }
  }
end

data:extend(
  {
    {
      type = "tips-and-tricks-item-category",
      name = "castra",
      order = "n-[castra]"
    },
    {
      type = "tips-and-tricks-item",
      name = "castra-briefing",
      category = "castra",
      order = "a",
      trigger =
      {
        type = "research",
        technology = "planet-discovery-castra"
      },
      skip_trigger =
      {
        type = "or",
        triggers =
        {
          {
            type = "change-surface",
            surface = "castra"
          },
          {
            type = "sequence",
            triggers =
            {
              {
                type = "research",
                technology = "planet-discovery-castra"
              },
              {
                type = "time-elapsed",
                ticks = 15 * minute
              },
              {
                type = "time-since-last-tip-activation",
                ticks = 15 * minute
              }
            }
          }
        }
      }
    }
  })

-- Set the localised string for the data item pollution tip based on the entities with emissions_per_minute
local data_pollution_items = {}
for key, category in pairs(data.raw) do
  for _, entity in pairs(category) do
    if entity.energy_source and entity.energy_source.emissions_per_minute and entity.energy_source.emissions_per_minute.data then
      table.insert(data_pollution_items,
        "[entity=" .. entity.name .. "]: " .. entity.energy_source.emissions_per_minute.data .. "/m")
    end
    if entity.emissions_per_second and entity.emissions_per_second.data then
      local per_min = tostring(entity.emissions_per_second.data * 60)
      -- Trim so that only 2 decimal places are shown
      if string.find(per_min, "%.") then
        per_min = string.sub(per_min, 1, string.find(per_min, "%.") + 2)
      end
      table.insert(data_pollution_items,
        "[entity=" .. entity.name .. "]: " .. per_min .. "/m")
    end
  end
end

-- Split the data pollution items into multiple pages, 3 items per page
local items_per_page = 3
local page_count = math.ceil(#data_pollution_items / items_per_page)
for page_i = 1, page_count do
  local tips_page = create_data_pollution_page(page_i)
  data:extend({ tips_page })

  -- Build the localised description
  local description = ""
  for i, item in ipairs(data_pollution_items) do
    if i < (page_i - 1) * items_per_page + 1 or i > page_i * items_per_page then
      goto continue
    end
    description = description .. item
    if i < #data_pollution_items then
      description = description .. "\n"
    end
    ::continue::
  end
  tips_page.localised_name = { "tips-and-tricks-item-name.data-pollution-items", tostring(page_i) }
  tips_page.localised_description = {
    "tips-and-tricks-item-description.data-pollution-items", description }
end
