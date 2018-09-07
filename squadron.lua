local squadron = {
  max_ships = 20;
  ships = {};
}

local pilots = require "./pilots"
local utils = require "./utils"

local PI = math.pi
local PI2 = math.pi ^ 2
local PI3 = math.pi ^ 3

function squadron:add_ship(ship)
  if self.max_ships > 0 and #self.ships >= self.max_ships then
    self:remove_ship()
  end

  table.insert(self.ships, ship)
end

function squadron:remove_ship(ship)
  table.remove(self.ships, ship or 1)
end

function squadron:set_formation(formation)
  self.formation = formation
end

local function accel_coeff_by_angle(target_angle_delta)
  assert(target_angle_delta <= PI and target_angle_delta >= -PI, "Target angle not in range -PI → +PI: " .. utils.deg(target_angle_delta))
  local x = math.abs(target_angle_delta)
  return (x / PI - 1) ^ 2
end

local function rotation_coeff_by_distance(dist_to_target)
  assert(dist_to_target >= 0, "da")
  local x = dist_to_target
  return -1 / (x + 1) + 1
end

function squadron:update(dt)
  local ships = self.ships
  for i, ship in ipairs(ships) do
    local x, y = self.formation(ships, i)
    local angle = self.leader.angle - math.pi / 2

    ship.target = {
      x = x * math.cos(angle) - y * math.sin(angle) + self.leader.x,
      y = x * math.sin(angle) + y * math.cos(angle) + self.leader.y
    }

    local dist_to_target = utils.pytag(ship.target.x, ship.target.y, ship.x, ship.y)
    local allowed_delta, delta_angle = pilots.straight_to_target(ship, ship.target, dt)

    ship.angle = ship.angle + allowed_delta *
      rotation_coeff_by_distance(dist_to_target)

    ship.speed = math.abs(dist_to_target) * dt * self.leader.speed *
      accel_coeff_by_angle(delta_angle)

    local max_speed = self.leader.speed * 2
    if ship.speed > max_speed then ship.speed = max_speed end
  end
end

return squadron
