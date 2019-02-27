local utils = {}

local next_print = 0

function utils.delayed_log(s, dt)
  next_print = next_print - dt
  if next_print <= 0 then
    print(s)
    next_print = 0.3
  end
end

function utils.round(number, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(number * mult + 0.5) / mult
end

function utils.deg(angle) return angle * 180 / math.pi end

function utils.pytag(x1, y1, x2, y2) return ((x2-x1) ^ 2 + (y2-y1) ^ 2) ^ 0.5 end

function utils.angle4(x1, y1, x2, y2) return math.atan2(y2-y1, x2-x1) end

function utils.angle2(a, b) return utils.angle4(a.x, a.y, b.x, b.y) end

function utils.rand(a, b, c)
  if a == nil then return math.random() end

  -- from 0 to A, floating point numbers
  if b == nil then return math.random() * a end

  -- from A to B, only integers
  if c == nil then return math.floor(math.random() * (b - a)) + a end

  -- from A to B, step = C
  return math.floor(math.random() * (b - a) / c) * c + a
end

function utils.to_range(x, from, to)
  if x < from then return from
  elseif x > to then return to
  else return x end
end

function utils.constrict_rotation(x, old, dt)
  if x - old > math.pi then old = old + 2 * math.pi end
  if old - x > math.pi then x = x + 2 * math.pi end

  local delta_angle = math.pi * dt -- I.e. rotate PI radians per second
  return utils.to_range(x, old - delta_angle, old + delta_angle)
end

function utils.fit_location(bounds, location)
  if not bounds then
    return location
  end

  return {
    x = location.x % bounds.x,
    y = location.y % bounds.y
  }
end

function utils.in_circle(point, circle_center, radius)
  local dx = point.x - circle_center.x
  local dy = point.y - circle_center.y

  return (dx * dx + dy * dy) <= radius * radius
end

function utils.set_color(color)
  if color == 'red' then love.graphics.setColor(1,0,0)
  -- white by default
  else love.graphics.setColor(1,1,1)
  end
end

function utils.merge(a, b)
  for k,v in pairs(b) do a[k] = v end
end

return utils
