module("goose_module", package.seeall)

local Goose = {}

-- 🦆
function Goose:new(x, y, width, height)
    local self = {}
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    return self
end

return Goose