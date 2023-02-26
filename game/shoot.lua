module("shoot", package.seeall)

goose_module = require "goose"
score_module = require "score"

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
    bulletcount = bulletcount - 1

    centredcoords = centrecoords(coords)

    hit_goose = false

    for i,goose in ipairs(geeselist) do
        if goose.state == goose.states.FLYING and collides(centredcoords, goose) then
            hit_goose = true
            goose:get_shot()
            goosecount = goosecount + 1
            if goosecount > 9 then
                if stage == 3 then
                    --win screen
                    love.event.quit()
                else
                    goosecount = 0
                    stage = stage + 1
                end
            end
        end
    end

    if(hit_goose == false) then
        score_module:miss_shot()
    end
end