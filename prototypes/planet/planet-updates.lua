local castra = data.raw["planet"]["castra"]

-- Remove any non existing decoratives from map gen settings
for key, _ in pairs(castra.map_gen_settings.autoplace_settings.decorative.settings) do
  if not data.raw["optimized-decorative"][key] or not data.raw["optimized-decorative"][key].autoplace then
    log("Removing non existing decorative from castra map gen settings: " .. key)
    castra.map_gen_settings.autoplace_settings.decorative.settings[key] = nil
  end
end

-- Remove any non existing entities from map gen settings
for key, _ in pairs(castra.map_gen_settings.autoplace_settings.entity.settings) do
  if (not data.raw["simple-entity"][key] or not data.raw["simple-entity"][key].autoplace) and not data.raw["resource"][key] then
    log("Removing non existing entity from castra map gen settings: " .. key)
    castra.map_gen_settings.autoplace_settings.entity.settings[key] = nil
  end
end

-- Yoink the Vulcanus music so we at least have something to listen to...
for _, music in pairs(data.raw["ambient-sound"]) do
	if music.planet == "vulcanus" or (music.track_type == "hero-track" and music.name:find("vulcanus")) then
		local new_music = table.deepcopy(music)
		new_music.name = music.name .. "-castra"
		new_music.planet = "castra"
		if new_music.track_type == "hero-track" then
			new_music.track_type = "main-track"
			new_music.weight = 10
		end
		data:extend {new_music}
	end
end