local fun = require "fun"

local squadron = {
  ships = {}
}

function squadron:add_ship(ship)
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
