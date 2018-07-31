local fun = require "fun"

local ship_factory = require "./ship_factory"
local Ship = require "./ship"

local squadron = require "./squadron"
local formations = require "./formations"
squadron:set_formation(formations.irow)

local next_ship = 0.5
local add_squadron_ship

function love.update(dt)
  if next_ship <= 0 then
    next_ship = 0.2
    add_squadron_ship()
  else
    next_ship = next_ship - dt
  end

  squadron:update()

  if squadron.leader then
    local leader = squadron.leader
    leader.angle = leader:pilot(dt)
    leader.x, leader.y = Ship.update(leader, dt)
  end

  fun.each(function(ship)
    ship.x, ship.y = Ship.update(ship, dt)
  end, squadron.ships)
end

function love.draw()
  ship_factory:draw()

  if squadron.leader then
    Ship.draw(squadron.leader, {0.2, 0.2, 0.9})
  end
  fun.each(Ship.draw, squadron.ships)
end

function love.keypressed(key)
  if key == "+" or key == "kp+" then
    add_squadron_ship()
  elseif key == "-" or key == "kp-" then
    squadron:remove_ship()
  elseif key == "escape" then
    love.event.quit()
  elseif key == "space" then
    ship_factory:toggle_pause()
  end
end

function add_squadron_ship()
  local ship = ship_factory:produce_ship()
  if not ship then return false end -- no ship produced :(

  if squadron.leader then
    squadron:add_ship(ship)
  else
    squadron.leader = ship
    Ship.set_square_pilot(ship, 300)
  end
end
