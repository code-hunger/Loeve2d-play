local Ship = {}

function Ship:draw(color)
  color = color or { 0.9, 0.2, 0.2 }
  local l = self.location

  love.graphics.setColor(unpack(color))
  love.graphics.setLineWidth(4)
  love.graphics.circle("line", l.x, l.y, 10)

  love.graphics.setColor(1, 1, 0)
  love.graphics.line(l.x, l.y, l.x - math.cos(self.angle) * 10, l.y - math.sin(self.angle) * 10)

  love.graphics.setColor(1,1,1)
  love.graphics.print("E = " .. self.energy, l.x - 20, l.y)

  if self.scan_radius then
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", l.x, l.y, self.scan_radius)
  end
end

function Ship:update(delta_time)
  return self.location.x - delta_time * self.speed * math.cos(self.angle),
    self.location.y - delta_time * self.speed * math.sin(self.angle)
end

return Ship
