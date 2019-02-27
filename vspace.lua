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

function Space:add_ship(id, location, energy, angle, conf)
  if energy > self.energy_available then
    return
  end

  self.energy_available = self.energy_available - energy
  self.energy_in_use = self.energy_in_use + energy

  conf = conf or {}

  assert(not self.ships[1] or not self.ships[1].cargo or (self.ships[1].conf.cargo ~= conf.cargo), "Has same cargo as the first!")

  local ship = {
    id = id,
    location = utils.fit_location(self.bounds, location),
    energy = energy,
    initial_energy = energy,
    scan = { radius = conf.radius or 50 },
    on_collide = conf.on_collide,
    speed = conf.speed or 100,
    angle = angle,
    conf = conf
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

Space.instructions = {}

function Space.instructions:acquire (ship_list, collisions)
  for _,i in ipairs(ship_list) do
    for id,v in ipairs(self.ships) do
      if v == collisions[i] then
        table.remove(self.ships, id)
      end
    end
  end
end

function Space.instructions:deploy (ship, collisions)
  if type(ship) == "table" then
    for _,s in ipairs(ship) do
      self.instructions.deploy(self, s, collisions)
    end
    return
  end
end

function Space:run_instructions(instructions, collisions)
  for k,v in pairs(instructions or {}) do
    assert(type(k) == 'string')
    self.instructions[k](self, v, collisions)
  end
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
      local eps = (1 - 2*(i % 2))
      ship.angle = ship.angle + eps * dt * math.pi / 10
      ship.location = utils.fit_location(self.bounds, ship.location)

      local collisions = self:find_collisions(i)
      self.collisions[ship] = collisions
      if #collisions > 0 then
        ship.scan.color = 'red'
        self:run_instructions(ship:on_collide(collisions), collisions)
      else
        ship.scan.color = 'white'
      end
    end
  end
end

return Space
