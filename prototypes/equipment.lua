local shield_mk3 = table.deepcopy(data.raw["energy-shield-equipment"]["energy-shield-mk2-equipment"])
shield_mk3.name = "energy-shield-mk3-equipment"
shield_mk3.sprite.filename = "__castra__/graphics/equipment/energy-shield-mk3-equipment.png"
shield_mk3.max_shield_value = 275
shield_mk3.energy_source.buffer_capacity = "540kJ"
shield_mk3.energy_source.input_flow_limit = "800kW"
shield_mk3.energy_per_shield = "50kJ"
data:extend({ shield_mk3 })