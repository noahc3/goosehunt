module("shoot_module", package.seeall)

-- functions for shooting shit yeehaw

function shoot(joystick, coords)
    -- apply max rumble for 0.5 seconds
    local vibe = joystick:setVibration(0, 1, 0.5)

    local x = coords[1]
    local y = coords[2]

    love.graphics.setColor(1, 0, 0, 1)
end