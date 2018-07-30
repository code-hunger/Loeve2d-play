local fun = require "fun"

local squadron = {
  max_ships = 10;
  ships = {};
}

function squadron:add_ship(ship)
  while self.max_ships > 0 and #self.ships >= self.max_ships do
    table.remove(self.ships, 1)
  end

  table.insert(self.ships, ship)
end

function squadron:set_formation(formation)
  self.formation = formation
end

function squadron:update()
  local ships = self.ships
  for i, ship in ipairs(ships) do
    local x, y = self.formation(ships, i, self.leader)
    ship.target = { x = x, y = y }
    ship.angle = math.atan2(- y + ship.y, - x + ship.x)
  end
end

return squadron
