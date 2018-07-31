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

function utils.angle2(x1, y1, x2, y2) return math.atan2(y2-y1, x2-x1) end

return utils
