local space = require "./vspace"
local setup = require "./scene_setups"

function love.load(arg)
  local count = (arg[1] or 7)

  local t = tonumber(arg[2])
  if t == 1 then
    setup.circle(space, count)
  elseif t == 2 then
    setup.mixed(space, count)
  else
    setup.random(space, count)
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

