local utils = require "./utils"
local fun = require "fun"
local Ship = require "./ship"

local Space = {
  ships = {},
  time_speed = 1,
  movement_cost = 0.01, -- per time per unit
  energy_available = 10000,
  energy_in_use = 0,
  bounds = { x = 800, y = 600 },
  gravity_cost = function (radius) -- what about weight?
    return radius * 0.1
  end,
}

function Space:add_ship(id, location, angle, energy, scan_radius, on_collide)
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
    scan = { radius = scan_radius },
    on_collide = on_collide or function () end,
    speed = 100,
    angle = angle
  }
  table.insert(self.ships, ship)
end

function Space:draw()
  love.graphics.print("energy available:" .. self.energy_available
    .. "\nenergy in use: " .. self.energy_in_use)

  fun.each(Ship.draw, self.ships)
  fun.each(function (ship)
    if ship.scan.radius > 0 then
      love.graphics.print("Grav cost: " .. 10 * self.gravity_cost(ship.scan.radius),
        ship.location.x - 40, ship.location.y + 15)
    end
  end, self.ships)

  love.graphics.setLineWidth(3)
  love.graphics.setColor(0,1,0)
  fun.each(function (ship, collisions)
    local a = ship.location
    for _,b in ipairs(collisions) do
      b = b.location
      love.graphics.line(a.x, a.y, b.x, b.y)
    end
  end, self.collisions)
end

function Space:find_collisions(ship_i)
  local collisions = {}
  local ship = self.ships[ship_i]
  for j,jhip in ipairs(self.ships) do
    if j ~= ship_i then
      if utils.in_circle(jhip.location, ship.location, ship.scan.radius) then
        table.insert(collisions, jhip)
      end
    end
  end
  return collisions
end

function Space:update(dt)
  self.collisions = {}
  for i,ship in ipairs(self.ships) do
    ship.energy = ship.energy - self.movement_cost  * dt * ship.speed
    ship.energy = ship.energy - self.gravity_cost(ship.scan.radius) * dt
    if ship.energy <= 0 then
      table.remove(self.ships, i)
    else
      ship.location.x, ship.location.y = Ship.update(ship, dt)
      ship.location = utils.fit_location(self.bounds, ship.location)

      local collisions = self:find_collisions(i)
      self.collisions[ship] = collisions
      if #collisions > 0 then
        ship.scan.color = 'red'
        ship:on_collide(collisions)
      else
        ship.scan.color = 'white'
      end
    end
  end
end

return Space
