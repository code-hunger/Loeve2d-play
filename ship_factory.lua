local ship_factory = {
  x = 10,
  y = 10,
  width = 200,
  height = 100,
  paused = false,
}

function ship_factory:produce_ship()
  if self.paused then return end

  return {
    speed = 200,
    angle = 0,
    x = self.x + self.width / 2,
    y = self.y + self.height / 2,
  }
end

function ship_factory:draw()
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function ship_factory:toggle_pause()
  self.paused = not self.paused
end

return ship_factory
