local pilots = {}

local function angle2(x1, y1, x2, y2) return math.atan2(y2-y1, x2-x1) end

local function pytag(x1, y1, x2, y2) return ((x2-x1) ^ 2 + (y2-y1) ^ 2) ^ 0.5 end

local function idle(x, y, idle_state, delta_time)
  local center_x = idle_state.center.x
  local center_y = idle_state.center.y

  local delta_radius = pytag(center_x, center_y, x, y) - idle_state.radius

  local current_angle = angle2(center_x, center_y,  x, y)
  local new_angle = current_angle + delta_time * (5 + 30 * math.abs(delta_radius / idle_state.radius))

  local target_x = center_x + idle_state.radius * math.cos(new_angle)
  local target_y = center_y + idle_state.radius * math.sin(new_angle)

  idle_state.target = { x = target_x, y = target_y }

  return angle2(target_x, target_y, x, y)
end

function pilots.idle(ship, t)
  return idle(ship.x, ship.y, ship.idle_state, t)
end

return pilots

