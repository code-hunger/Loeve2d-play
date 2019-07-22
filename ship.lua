local Ship = {}
local utils = require "./utils"

local max = math.max
local min = math.min

function Ship:draw(color)
  local cid = self.id % 3

-- cid c1 c2 c3
--  1  1  0  0
--  0  0  1  0
-- -1  0  0  1

  color = color or { 0.2 + max(0, 1-cid), 0.2 + (cid % 2) * 0.7, 0.2 + 0.7 * min(cid, cid / 2) }
  local l = self.location
  local x = l.x + 50
  local y = l.y + 50

  love.graphics.setColor(unpack(color))
  love.graphics.setLineWidth(3)
  love.graphics.circle("line", x, y, 5)

  love.graphics.setColor(1, 1, 0)
  love.graphics.line(x, y, x + math.cos(self.angle) * 10, y + math.sin(self.angle) * 10)

  love.graphics.setColor(1,1,1)
  love.graphics.print("ID = " .. self.id, x - 20, y + 15)
  love.graphics.print("E = " .. utils.round(self.energy, 1), x - 20, y)

  if self.scan then
    love.graphics.setLineWidth(1)
    utils.set_color(self.scan.color)
    love.graphics.circle("line", x, y, self.scan.radius)
  end

  if self.energy then
    local r = self.energy / (self.initial_energy or 20) * math.pi * 2
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.arc("line", x, y, (self.scan.radius or 20) * 0.8, self.angle,r + self.angle)
  end
end

function Ship:update(delta_time)
  return self.location.x + delta_time * self.speed * math.cos(self.angle),
         self.location.y + delta_time * self.speed * math.sin(self.angle)
end

return Ship
