local pilots = {}
local PI = math.pi

local function deg(angle) return angle * 180 / math.pi end

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

  return { x = target_x, y = target_y }
end

function pilots.idle(ship, t)
  ship.target = idle(ship.x, ship.y, ship.idle_state, t)
  return angle2(ship.target.x, ship.target.y, ship.x, ship.y)
end

local function next_square_target(current_angle)
  local positive_angle = current_angle + PI -- for easier maths bellow

  -- Down Right
  if positive_angle > PI * 7 / 4 or positive_angle < PI / 4 then
    return 1, 1
  end

  -- Down Left
  if positive_angle < PI * 3 / 4 then
    return -1, 1
  end

  -- Up Left
  if positive_angle < PI * 5 / 4 then
    return -1, -1
  end

  -- Up Right
  if positive_angle <= PI * 7 / 4 then
    return 1, -1
  end

  error ('Angle given out of bounds - ' .. current_angle)
end

function pilots.square(ship, _)
  local center = ship.square_state.center

  local current_angle = angle2(ship.x, ship.y, center.x, center.y)
  local dx, dy = next_square_target(current_angle)
  local a = ship.square_state.a / 2
  return angle2(center.x + dx * a, center.y + dy * a, ship.x, ship.y)
end

return pilots

