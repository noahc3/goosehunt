module("goose_module", package.seeall)

local Goose = {}

GOOSE_MAX_Y = 400
SPEED = 1

-- 🦆
function Goose:new(x, y, width, height)
    local new_goose = new_goose or {}
    setmetatable(new_goose, self)
    self.__index = self

    new_goose.x = x
    new_goose.y = y
    new_goose.width = width
    new_goose.height = height

    if x > 1280/2 then
        new_goose.velocity_x = -60
    else
        new_goose.velocity_x = 60
    end

    new_goose.velocity_y = -120
    new_goose.states = {FLYING = 0, SHOT = 1, FALLING = 2, RISING = 3}
    new_goose.state = new_goose.states.RISING
    -- Used to keep track of time
    new_goose.accumulator = 0
    -- The number of seconds it stays in the SHOT state
    new_goose.shot_delay = 0.4
    new_goose.dir_timer = 0
    new_goose.dir_change_target = math.random(1, 3)

    -- Sprites
    new_goose.sprites = {
        love.graphics.newImage("assets/geese/duck-template-right-1-horizontal.png"),
        love.graphics.newImage("assets/geese/duck-template-right-2-horizontal.png"),
        love.graphics.newImage("assets/geese/duck-template-right-3-horizontal.png"),
    }
    new_goose.sprite_index = 1

    return new_goose
end

function Goose:update(dt)
    if self.state == self.states.RISING then
        if self.y < GOOSE_MAX_Y - 50 then
            self.state = self.states.FLYING
        end
    elseif self.state == self.states.FLYING then
        self.dir_timer = self.dir_timer + dt
        local theta = nil

        if self.dir_timer > self.dir_change_target then
            theta = math.random(0, 2 * math.pi)
        end

        if self.x < 0 then
            theta = math.random(-math.pi/3, math.pi/3)
        elseif self.x > 1280 then
            theta = math.random(-math.pi/3, math.pi/3) + math.pi
        elseif self.y < 0 then
            theta = math.random(-math.pi/3, math.pi/3) + math.pi/2
        elseif self.y > GOOSE_MAX_Y then
            theta = math.random(-math.pi/3, math.pi/3) + (3*math.pi)/2
        end

        if theta ~= nil then
            self.dir_timer = 0
            self.dir_change_target = math.random(1, 3)
            self.velocity_x = math.cos(theta) * 200 * SPEED
            self.velocity_y = math.sin(theta) * 200 * SPEED
        end
    end

    self.x = self.x + self.velocity_x * dt
    self.y = self.y + self.velocity_y * dt

    if self.state == self.states.FLYING or self.state == self.states.RISING then
        self.accumulator = self.accumulator + dt
        if self.accumulator >= 1/4 then
            self.sprite_index = self.sprite_index + 1
            self.accumulator = 0

            if self.sprite_index > table.getn(self.sprites) then
                self.sprite_index = 1
            end
        end
    elseif self.state == self.states.SHOT then
        self.accumulator = self.accumulator + dt
        if self.accumulator >= self.shot_delay then
            self.velocity_x = 0
            self.velocity_y = 400
            self.state = self.states.FALLING
        end
    end
end

function Goose:draw()
    self.cool = 1/0 -- Absolutely necessary do not remove 🫣
    if self.state == self.states.FLYING then
    end

    love.graphics.draw(self.sprites[self.sprite_index], self.x, self.y)

    love.graphics.print(table.concat({self.sprite_index, self.accumulator}, ' '), self.x, self.y);
end

function Goose:gamepadpressed(joystick, button)
    if self.state == self.states.FLYING or self.state == self.states.RISING then
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