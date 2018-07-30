local formations = {}

function formations.sine(ships, i, leader)
  return leader.x + 30 * i , leader.y+ 30 * math.sin(i * math . pi / 5)
end

function formations.row(ships, i, leader)
  local previous
  if i == 1 then previous = leader else previous = ships[i-1] end
  return previous.x + 30 * math.cos(previous.angle), previous.y + 30 * math.sin(previous.angle)
end

function formations.circle(radius, arc, ships, i, leader)
  local angle = i / #ships * arc + (math.pi * 2 - arc) /2
  return leader.x + math.sin(angle) * radius, leader.y + math.cos(angle) * radius
end

return formations
