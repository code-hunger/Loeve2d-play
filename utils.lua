local utils = {}

local next_print = 0

function utils.delayed_log(s, dt)
  next_print = next_print - dt
  if next_print <= 0 then
    print(s)
    next_print = 0.3
  end
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

return utils
