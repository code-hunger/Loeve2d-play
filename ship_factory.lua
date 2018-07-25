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

return ship_factory
