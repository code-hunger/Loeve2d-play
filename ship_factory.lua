local ship_factory = {
  x = 10,
  y = 10,
  width = 200,
  height = 100,
}

function ship_factory:produce_ship()
  return {
    angle = 0,
    x = self.x + self.width / 2,
    y = self.y + self.height / 2,
  }
end

function ship_factory:draw()
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return ship_factory
