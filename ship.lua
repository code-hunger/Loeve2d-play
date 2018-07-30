local pilots = require "./pilots"
local Ship = {}

function Ship:draw()
  love.graphics.setColor(0.9, 0.2, 0.2)
  love.graphics.setLineWidth(4)
  love.graphics.circle("line", self.x, self.y, 10)
  if self.idle_state then
    local c = self.idle_state.center
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", c.x, c.y, self.idle_state.radius)
  end

  if self.target then
    local t = self.target
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", t.x, t.y, 5)
    love.graphics.line(self.x, self.y, t.x, t.y)
  end
end

function Ship:update(delta_time, speed)
  return self.x - delta_time * speed * math.cos(self.angle),
    self.y - delta_time * speed * math.sin(self.angle)
end

function Ship:set_idle()
  local radius = math.floor(math.random() * 15) * 20 + 30
  self.idle_state = {
    radius = radius;
    center = {
      x = 300;
      y = 300;
    }
  }
  self.pilot = pilots.idle
end

return Ship
