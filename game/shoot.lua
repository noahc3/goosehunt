module("shoot", package.seeall)

-- functions for shooting shit yeehaw

function shoot:init()
  self.shoot_sound = love.audio.newSource("assets/sounds/shoot.ogg", "stream")
 
end

function shoot:shoot(joystick, coords)
    -- apply max rumble for 0.5 seconds
    local vibe = joystick:setVibration(1, 1, 0.5)
    self.shoot_sound:play()

end