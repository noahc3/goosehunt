module("shoot", package.seeall)

goose_module = require "goose"

-- functions for shooting shit yeehaw

CURSORSIZE = 30

function shoot:init()
  self.shoot_sound = love.audio.newSource("assets/sounds/shoot.ogg", "stream")
end


function centrecoords(coords)
    return {coords[1] + (CURSORSIZE/2), coords[2] + (CURSORSIZE/2)}
end

function collides(coords, goose)
    return (goose.x <= coords[1]) and (goose.x + goose.width >= coords[1]) and (goose.y <= coords[2]) and (coords[2] <= goose.y + goose.height)
end

function shoot:shoot(joystick, coords, geeselist)
    -- apply max rumble for 0.5 seconds
    local vibe = joystick:setVibration(1, 1, 0.5)
    self.shoot_sound:play()

    centredcoords = centrecoords(coords)

    for i,goose in ipairs(geeselist) do
        if goose.state == goose.states.FLYING and collides(centredcoords, goose) then
            goose:get_shot()
        end
    end
end