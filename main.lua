local fun = require "fun"

local Ship = require "./ship"
local utils = require "./utils"

local space = require "./vspace"

function love.load()
  for i=1,10 do
    space:add_ship(
      i,
      { x=math.random() * space.bounds.x, y=space.bounds.y * math.random() },
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

  fun.each(function(ship)
    ship.location.x, ship.location.y = Ship.update(ship, dt)
    ship.location = utils.fit_location(space.bounds, ship.location)
  end, space.ships)
end

function love.draw()
  fun.each(Ship.draw, space.ships)
end

function love.keypressed(key)
  if key == "-" or key == "kp-" then
    space:remove_ship()
  elseif key == "escape" then
    love.event.quit()
  end
end

