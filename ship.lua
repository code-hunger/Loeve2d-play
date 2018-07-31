local pilots = require "./pilots"
local utils = require "./utils"
local Ship = {}

function Ship:draw(color)
  color = color or { 0.9, 0.2, 0.2 }
  love.graphics.setColor(unpack(color))
  love.graphics.setLineWidth(4)
  love.graphics.circle("line", self.x, self.y, 10)
  if self.idle_state then
    local c = self.idle_state.center
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", c.x, c.y, self.idle_state.radius)
  end

  if self.square_state then
    local c = self.square_state.center
    local a = self.square_state.a
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("line", c.x - a / 2, c.y - a / 2, a, a)
  end

  if self.target then
    local t = self.target
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", t.x, t.y, 2)
    love.graphics.line(self.x, self.y, t.x, t.y)
  end
end

function Ship:update(delta_time)
  return self.x - delta_time * self.speed * math.cos(self.angle),
    self.y - delta_time * self.speed * math.sin(self.angle)
end

function Ship:set_idle(radius, center)
  radius = radius or utils.rand(30, 300, 20)
  self.idle_state = {
    radius = radius;
    center = center or {
      x = 300;
      y = 300;
    }
  }
  self.pilot = pilots.idle
end

function Ship:set_square_pilot(square_a, center)
  square_a = square_a or utils.rand(50, 300, 15)
  self.square_state = {
    a = square_a;
    center = center or {
      x = square_a;
      y = square_a;
    }
  }
  self.pilot = pilots.square
end

return Ship
