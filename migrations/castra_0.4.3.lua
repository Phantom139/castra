-- Rebuild castra data collector dataCollectorsRoboportStatus
local surface = game.surfaces["castra"]
if not surface then return end
storage.castra = storage.castra or {}
storage.castra.dataCollectors = storage.castra.dataCollectors or {}
storage.castra.dataCollectorsRoboportStatus = {}

for _, entity in pairs(storage.castra.dataCollectors) do
    if entity.valid then
        local roboport = entity.surface.find_entities_filtered({ force = "player", name = "roboport", position = entity.position, area = {{-55 + entity.position.x, -55 + entity.position.y}, {55 + entity.position.x, 55 + entity.position.y}} })
        if roboport and #roboport > 0 then
            storage.castra.dataCollectorsRoboportStatus[entity.unit_number] = true
        else
            storage.castra.dataCollectorsRoboportStatus[entity.unit_number] = false
        end
    end
end