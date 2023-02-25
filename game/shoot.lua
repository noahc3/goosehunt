module("shoot", package.seeall)

-- functions for shooting shit yeehaw

function shoot:shoot(joystick, coords)
    -- apply max rumble for 0.5 seconds
    local vibe = joystick:setVibration(1, 1, 0.5)
end