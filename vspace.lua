local utils = require "./utils"

local Space = {
  ships = {},
  time_speed = 1,
  energy_available = 1000,
  energy_in_use = 0,
  bounds = { x = 800, y = 600 },
  gravity_cost = function (radius) -- what about weight?
    return 2 ^ radius
  end,
}

function Space:add_ship(id, location, energy, scan_radius)
  if energy > self.energy_available then
    return
  end

  self.energy_available = self.energy_available - energy
  self.energy_in_use = self.energy_in_use + energy

  local ship = {
    id = id,
    location = utils.fit_location(self.bounds, location),
    energy = energy,
    scan_radius = scan_radius
    ,speed = 40,angle = math.pi
  }
  table.insert(self.ships, ship)
end

return Space
