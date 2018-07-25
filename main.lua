require "fun"()

local ship_factory = require "./ship_factory"

function love.load()
  ships = {}
end

function love.draw()
  love.graphics.rectangle("line", ship_factory.x, ship_factory.y, ship_factory.width, ship_factory.height)
  love.graphics.print("Ship count: " .. #ships)

  each(draw_ship, ships)
end

function love.keypressed(key)
  if key == "+" or key == "kp+" then
    table.insert(ships, ship_factory:produce_ship())
  elseif key == "-" or key == "kp-" then
    table.remove(ships, 1)
  end
end

function draw_ship(ship)
  love.graphics.circle("line", ship.x, ship.y, 10)
end
