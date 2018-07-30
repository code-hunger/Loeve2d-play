local pilots = require "./pilots"
local Ship = {}

function Ship.draw(ship)
  love.graphics.setColor(0.9, 0.2, 0.2)
  love.graphics.setLineWidth(4)
  love.graphics.circle("line", ship.x, ship.y, 10)
  if ship.idle_state then
    local c = ship.idle_state.center
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", c.x, c.y, ship.idle_state.radius)
  end

  if ship.target then
    local t = ship.target
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", t.x, t.y, 5)
    love.graphics.line(ship.x, ship.y, t.x, t.y)
  end
end

function Ship.update(ship, delta_time, speed)
  assert(ship.angle, "Angle is nil")
  return ship.x - delta_time * speed * math.cos(ship.angle),
    ship.y - delta_time * speed * math.sin(ship.angle)
end

function Ship.set_idle(ship)
  local radius = math.floor(math.random() * 15) * 20 + 30
  ship.idle_state = {
    radius = radius;
    center = {
      x = 300;
      y = 300;
    }
  }
  ship.pilot = pilots.idle
end

return Ship
