local planet_map_gen = {}

planet_map_gen.castra = function()
  return
  {
    aux_climate_control = true,
    autoplace_controls =
    {
      ["millerite"] = {},
      ["gunpowder"] = {},
      ["hydrogen-sulfide-vent"] = {},
      ["copper-ore"] = {},
      ["stone"] = {},
      ["uranium-ore"] = {},
      ["rocks"] = {}
    },
    autoplace_settings =
    {
      ["tile"] =
      {
				treat_missing_as_default = false,
        settings =
        {
          ["grass-1"] = {},
          ["grass-2"] = {},
          ["grass-3"] = {},
          ["grass-4"] = {},
          ["red-desert-0"] = {},
          ["red-desert-1"] = {},
          ["red-desert-2"] = {},
          ["red-desert-3"] = {}, 
          ["nuclear-ground"] = {},
          ["light-oil-ocean-deep"] = {}
        }
      },
      ["decorative"] =
      {
				treat_missing_as_default = false,
        settings =
        {
          ["brown-hairy-grass"] = {},
          ["brown-carpet-grass"] = {},
          ["brown-asterisk-mini"] = {},
          ["brown-asterisk"] = {},
          ["red-asterisk"] = {},
          ["dark-mud-decal"] = {},
          ["light-mud-decal"] = {},
          ["cracked-mud-decal"] = {},
          ["red-desert-decal"] = {},
          ["sand-decal"] = {},
          ["sand-dune-decal"] = {},
          ["red-pita"] = {},
          ["red-croton"] = {},
          ["brown-fluff"] = {},
          ["brown-fluff-dry"] = {},
          ["red-desert-bush"] = {},
          ["white-desert-bush"] = {},
          ["garballo-mini-dry"] = {},
          ["garballo"] = {},
          ["green-bush-mini"] = {},
          ["medium-rock"] = {},
          ["small-rock"] = {},
          ["tiny-rock"] = {},
          ["medium-sand-rock"] = {},
          ["small-sand-rock"] = {}
        }
      },
      ["entity"] =
      {
				treat_missing_as_default = false,
        settings =
        {
          ["millerite"] = {},
          ["gunpowder"] = {},
          ["hydrogen-sulfide-vent"] = {},
          ["copper-ore"] = {},
          ["stone"] = {},
          ["uranium-ore"] = {},
          ["big-sand-rock"] = {},
          ["huge-rock"] = {},
          ["big-rock"] = {},
        }
      }
    }
  }
end

return planet_map_gen
