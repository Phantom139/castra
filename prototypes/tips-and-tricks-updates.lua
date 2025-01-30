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
