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
    return radius * 0.02
  end,
}

function Space:add_ship(id, location, angle, energy, scan_radius)
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
    scan_radius = scan_radius,
    speed = 40,
    angle = angle
  }
  table.insert(self.ships, ship)
end

function Space:draw()
  love.graphics.print("energy available:" .. self.energy_available
    .. "\nenergy in use: " .. self.energy_in_use)

  fun.each(Ship.draw, self.ships)
  fun.each(function (ship)
    love.graphics.print("Grav cost: " .. 10 * self.gravity_cost(ship.scan_radius), ship.location.x - 40, ship.location.y + 15)
  end, self.ships)
end

function Space:update(dt)
  for i,ship in ipairs(self.ships) do
    ship.energy = ship.energy - self.movement_cost  * dt * ship.speed
    ship.energy = ship.energy - self.gravity_cost(ship.scan_radius) * dt
    if ship.energy <= 0 then
      table.remove(self.ships, i)
    else
      ship.location.x, ship.location.y = Ship.update(ship, dt)
      ship.location = utils.fit_location(self.bounds, ship.location)
    end
  end
end

return Space
