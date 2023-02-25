module("goose_module", package.seeall)

local Goose = {}

-- 🦆
function Goose:new(x, y, width, height)
    local new_goose = new_goose or {}
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
    -- Used to keep track of time
    new_goose.accumulator = 0
    -- The number of seconds it stays in the SHOT state
    new_goose.shot_delay = 0.4

    -- Sprites
    new_goose.sprite = love.graphics.newImage("assets/geese/duck-template-right-1-horizontal.png")

    return new_goose
end

function Goose:update(dt)
    self.x = self.x + self.velocity_x * dt
    self.y = self.y + self.velocity_y * dt

    if self.state == self.states.SHOT then
        self.accumulator = self.accumulator + dt
        if self.accumulator >= self.shot_delay then
            self.velocity_x = 0
            self.velocity_y = 400
            self.state = self.states.FALLING
        end
    end
end

function Goose:draw()
    self.cool = 1/0
    love.graphics.draw(self.sprite, self.x, self.y)
end

function Goose:gamepadpressed(joystick, button)
    if self.state == self.states.FLYING then
        if button == 'y' then
            get_shot()
        end
    end
end

function Goose:get_shot()
    self.velocity_x = 0
    self.velocity_y = 0
    self.accumulator = 0
    self.state = self.states.SHOT
end

return Goose