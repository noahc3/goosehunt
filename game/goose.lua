module("goose_module", package.seeall)

function Goose.new(self, x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end