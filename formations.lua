local formations = {}

function formations.sine(_, i)
  return 30 * i,
         30 * math.sin(i * math.pi / 5)
end

function formations.row(ships, i, leader)
  local previous
  if i == 1 then previous = leader else previous = ships[i-1] end

  return previous.x + 30 * math.cos(previous.angle),
         previous.y + 30 * math.sin(previous.angle)
end

function formations.irow(_, i)
  return 0, 30 * i
end

function formations.circle(radius, arc, ships, i)
  local angle
  if #ships == 1 then -- for a single ship, (i-1)/(#ships-1) is 0/0
    angle = math.pi
  else
    angle = (i - 1) / (#ships - 1) * arc + math.pi - arc / 2
  end

  return math.sin(angle) * radius,
         math.cos(angle) * radius
end

return formations
