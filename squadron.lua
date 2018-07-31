local squadron = {
  max_ships = 20;
  ships = {};
}

local utils = require "./utils"

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

function squadron:update()
  local ships = self.ships
  for i, ship in ipairs(ships) do
    local x, y = self.formation(ships, i)
    local angle = self.leader.angle - math.pi / 2

    ship.target = {
      x = x * math.cos(angle) - y * math.sin(angle) + self.leader.x,
      y = x * math.sin(angle) + y * math.cos(angle) + self.leader.y
    }

    ship.angle = utils.angle2(ship.target, ship)
  end
end

return squadron
