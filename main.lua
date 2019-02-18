local space = require "./vspace"

function love.load(arg)
  for i=1,(arg[1] or 7) do
    space:add_ship(
      i,
      { x=math.random() * space.bounds.x, y=space.bounds.y * math.random() },
      math.random(0, 2*math.pi),
      20,
      math.random(30, 70))
  end
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

