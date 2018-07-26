local pilots = {}

function math.angle(x1, y1, x2, y2) return math.atan2(y2-y1, x2-x1) end

function pilots.idle(x, y, idle_state, delta_time)
  local center_x = idle_state.center.x
  local center_y = idle_state.center.y

  local current_angle = math.angle(center_x, center_y,  x, y)
  local new_angle = current_angle + 10 * delta_time

  local target_x = center_x + idle_state.radius * math.cos(new_angle)
  local target_y = center_y + idle_state.radius * math.sin(new_angle)

  idle_state.target = { x = target_x, y = target_y }

  return math.angle(target_x, target_y, x, y)
end

return pilots

