local pilots = {}

local utils = require "./utils"
local PI = math.pi

local function idle(x, y, idle_state, delta_time)
  local center_x = idle_state.center.x
  local center_y = idle_state.center.y

  local delta_radius = utils.pytag(center_x, center_y, x, y) - idle_state.radius

  local current_angle = utils.angle4(center_x, center_y,  x, y)
  local new_angle = current_angle + delta_time * (5 + 30 * math.abs(delta_radius / idle_state.radius))

  local target_x = center_x + idle_state.radius * math.cos(new_angle)
  local target_y = center_y + idle_state.radius * math.sin(new_angle)

  return { x = target_x, y = target_y }
end

function pilots.idle(ship, t)
  ship.target = idle(ship.x, ship.y, ship.idle_state, t)
  return utils.angle2(ship.target, ship)
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

  local current_angle = utils.angle2(ship, center)
  local dx, dy = next_square_target(current_angle)
  local a = ship.square_state.a / 2
  return utils.angle4(center.x + dx * a, center.y + dy * a, ship.x, ship.y)
end

function pilots.manual(ship, t)
  local angle = ship.angle
  if love.keyboard.isDown("left") then
    ship.mouse_controlled = false
    return angle - 0.7 * PI * t
  end
  if love.keyboard.isDown("right") then
    ship.mouse_controlled = false
    return angle + 0.7 * PI * t
  end
  if ship.mouse_controlled then
    return pilots.straight_to_target(ship, ship.target, t)
  end
  return angle
end

function pilots.straight_to_target(ship, target, t)
  local requested_angle = utils.angle2(target, ship)

  if requested_angle < 0 and ship.angle > requested_angle + math.pi then
    requested_angle = requested_angle + 2 * math.pi
  end

  local new_angle = utils.constrict_rotation(requested_angle, ship.angle, t)

  if new_angle > 2 * math.pi then
    return new_angle - 2 * math.pi, new_angle - ship.angle
  end
  return new_angle, new_angle - ship.angle
end

return pilots

