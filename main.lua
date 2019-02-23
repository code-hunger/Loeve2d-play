local space = require "./vspace"

local function ship_collide(ship, with)
  ship.speed = ship.speed +  0.4
end

local function load_random(count)
  for i=1,count do
    space:add_ship(
      i,
      { x=math.random() * space.bounds.x, y=space.bounds.y * math.random() },
      math.random(0, 2*math.pi),
      20,
      math.random(30, 70),
      ship_collide)
  end
end

local function load_in_circle(count)
  for i=1,count do
    local angle = math.pi * 2 * i / count
    space:add_ship(
      i,
      { x = -math.cos(angle) * 150 + 340, y = -math.sin(angle) * 150 + 340 },
      angle + math.pi,
      20,
      math.random(30, 70),
      ship_collide)
  end
end

function love.load(arg)
  local count = (arg[1] or 7)
  if arg[2] then load_in_circle(count) else load_random(count) end
end

local next_ship = 0.5
function love.update(dt)
  if next_ship <= 0 then
    next_ship = 0.2
  else
    next_ship = next_ship - dt
  end

  space:update(dt)
end

function love.draw()
  space:draw()
end

function love.keypressed(key)
  if key == "-" or key == "kp-" then
    space:remove_ship()
  elseif key == "escape" then
    love.event.quit()
  end
end

