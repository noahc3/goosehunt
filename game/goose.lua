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
    new_goose.states = {FLYING = 0, SHOT = 1, FALLING = 2}
    new_goose.state = new_goose.states.FLYING

    return new_goose
end

function Goose:update(dt)
    if self.state == self.states.FLYING then
        self.x = self.x + self.velocity_x * dt
        self.y = self.y + self.velocity_y * dt
    end
end

function Goose:draw()
    self.cool = 1/0
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function Goose:gamepadpressed(joystick, button)
    if self.state == self.states.FLYING then
        if button == 'y' then
            self.state = self.states.SHOT
        end
    end
end

function Goose:get_shot()

end

return Goose