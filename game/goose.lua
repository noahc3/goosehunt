module("goose_module", package.seeall)

local Goose = {}

-- 🦆
function Goose:new(x, y, width, height)
    new_goose = new_goose or {}
    setmetatable(new_goose, self)
    self.__index = self

    new_goose.x = x
    new_goose.y = y
    new_goose.width = width
    new_goose.height = height
    new_goose.velocity_x = 60
    new_goose.velocity_y = -120

    return new_goose
end

function Goose:update(dt)
    self.x = self.x + self.velocity_x * dt
    self.y = self.y + self.velocity_y * dt
end

function Goose:draw()
    self.cool = 1/0
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

return Goose