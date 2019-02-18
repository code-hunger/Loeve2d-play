local utils = require "./utils"
local fun = require "fun"
local Ship = require "./ship"

local Space = {
  ships = {},
  time_speed = 1,
  movement_cost = 0.02, -- per time per unit
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
    initial_energy = energy,
    scan_radius = scan_radius
    ,speed = 40,angle = math.pi
  }
  table.insert(self.ships, ship)
end

function Space:update(dt)
  fun.each(function(ship)
    ship.location.x, ship.location.y = Ship.update(ship, dt)
    ship.location = utils.fit_location(self.bounds, ship.location)
    ship.energy = ship.energy - self.movement_cost * dt * ship.speed
  end, self.ships)
end

return Space
